classdef MatchingPursuit < handle
    % Implements matching pursuit algorithm for sparse approximation
    
    properties
        % Maximum residual norm
        MaxResNorm = 1e-4
        % Indicates if we should stop on exceeding residual norm
        StopOnResidualNorm = true
        % Indicates if we should stop when residual norm stops improving
        StopOnResNormStable = true
        % Maximum number of iterations for approximation
        MaxIters
        Verbose = false
        % Indicates if least squares should be applied at the end.
        ApplyLeastSquares = false
    end
    
    properties(SetAccess=private)
        % The dictionary
        Dict
        % Ambient signal dimensions
        N
        % Number of atoms in dictionary
        D
        % Sparsity level of representations (may be negative)
        K
        % Result of a solver
        result
    end
    
    methods
        function self  = MatchingPursuit(Dict, K)
            % We assume that all the columns in dictionary are normalized.
            if isa(Dict, 'spx.dict.Operator')
                self.Dict = Dict;
            elseif ismatrix(Dict)
                self.Dict = spx.dict.MatrixOperator(Dict); 
            else
                error('Unsupported operator.');
            end
            [self.N, self.D] = size(Dict);
            if ~exist('K', 'var')
                % No sparsity level has been pre-specified.
                K = -1;
            end
            self.K = K;
            % Maximum number of iterations
            maxIter = self.N*4;
            if K > 0
                % We have to consider pre-specified sparsity level
                maxIter = K*4;
            end
            self.MaxIters = maxIter;
        end
        
        function result  = solve(self,y)
            % Initialization
            % Solves approximation problem using OMP
            d = self.D;
            n = self.N;
            r = y;
            dict = self.Dict;
            % Active indices 
            omega = false(d, 1);
            % Estimate
            z = zeros(d, 1);
            if self.StopOnResNormStable
                oldResNorm = norm(r);
            end
            maxIter = self.MaxIters;
            % number of indices discovered so far
            k  = 0;
            target_k = self.K;
            for iter=1:maxIter
                % Compute inner products
                innerProducts = dict.apply_ctranspose(r);
                absInnerProducts = abs(innerProducts);
                % Find the highest inner product
                [~, index] = max(absInnerProducts);
                % Add this index to support
                if ~omega(index)
                    % we have discovered a new atom.
                    k = k + 1;
                    omega(index) = true;
                end
                % pick up the coefficient of this inner product
                coeff = innerProducts(index);
                % update approximation
                z(index) = z(index) + coeff;
                % update residual
                r = r - coeff * dict.column(index);
                if target_k > 0 && target_k == k
                    % We have achieved the required sparsity level
                    break;
                end
                if self.StopOnResidualNorm || self.StopOnResNormStable
                    resNorm = norm(r);
                    if resNorm < self.MaxResNorm
                        break;
                    end
                    if self.StopOnResNormStable
                        change = abs(oldResNorm  - resNorm);
                        if change/oldResNorm < .01
                            % No improvement
                            break;
                        end
                    end
                end
            end
            if self.ApplyLeastSquares
                % We should apply least squares 
                % Solve least squares problem
                subdict = dict.columns(omega);
                tmp = linsolve(subdict, y);
                % Updated solution
                z(omega) = tmp;
            end
            
            % Solution vector
            result.z = z;
            % Residual obtained
            result.r = r;
            % Number of iterations
            result.iterations = iter;
            % Solution support
            result.support = find(omega);
            self.result = result;
        end

        function result  = solve_all(self,Y)
            % Initialization
            % Solves approximation problem using OMP
            d = self.D;
            % Residuals at each stage
            R = Y;
            % Number of signals
            ns = size(Y,2);
            dict = self.Dict;
            % Active indices 
            omegas = zeros(d, ns);
            % Estimate
            Z = zeros(d, ns);

            for s=1:ns
                if self.Verbose
                    fprintf('.');
                end
                y = Y(:, s);
                result = self.solve(y);
                Z(:, s) = result.z;
                R(:, s) = result.r;
                omegas(result.support, s) = true;
                if self.Verbose && mod(s, 100) == 0
                    fprintf('\n');
                end
            end
            % Solution vector
            result.Z = Z;
            % Residual obtained
            result.R = R;
            % Solution support
            result.Supports = omegas;
            self.result = result;
            if self.Verbose
                fprintf('\n');
            end
        end

    end
end

