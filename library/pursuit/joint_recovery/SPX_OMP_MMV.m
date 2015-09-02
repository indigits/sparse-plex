classdef SPX_OMP_MMV < handle
    %CSOMPAPPROX Implements OMP-MMV algorithm for sparse approximation
    
    properties
        % Maximum residual norm
        MaxResNorm = 1e-4
        % Indicates if we should stop on exceeding residual norm
        StopOnResidualNorm = true
        % Indicates if we should stop when residual norm stops improving
        StopOnResNormStable = true
        % Maximum number of iterations for approximation
        MaxIters
        % Indicates if log messages should be printed at each iteration
        Verbose = false
        % Minimum Sparsity
        MinK = 4
        % Ignored atom (which won't be considered in identification step)
        IgnoredAtom = -1
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
        function self  = SPX_OMP_MMV(Dict, K)
            % We assume that all the columns in dictionary are normalized.
            if isa(Dict, 'SPX_Operator')
                self.Dict = Dict;
            elseif ismatrix(Dict)
                self.Dict = SPX_MatrixOperator(Dict); 
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
            maxIter = self.N;
            if K > 0
                % We have to consider pre-specified sparsity level
                maxIter = K;
            end
            self.MaxIters = maxIter;
            if K > 0 && self.MinK >= K
                self.MinK = 0;
            end
        end
        
        function result  = solve(self, Y)
            % Initialization
            % Solves approximation problem using OMP
            d = self.D;
            n = self.N;
            % The number of signals being approximated.
            s = size(Y, 2);
            % Initial residual
            R = Y;
            dict = self.Dict;
            % Active indices 
            omega = [];
            % Estimate
            Z = zeros(d, s);
            if self.StopOnResNormStable
                oldResNorm = norm(R, 'fro');
            end
            maxIter = self.MaxIters;
            for iter=1:maxIter
                % Compute inner products (DxN  * NxS = DxS )
                innerProducts = apply_ctranspose(dict, R);
                % Compute absolute values of inner products
                innerProducts = abs(innerProducts);
                % Compute sum of inner products over each row
                innerProducts = sum(innerProducts, 2);
                % Mark the inner products of already selected columns as 0.
                innerProducts(omega) = 0;
                % Find the highest inner product
                [~, index] = max(innerProducts);
                % Add this index to support
                omega = [omega, index];
                % Solve least squares problem
                subdict = columns(dict, omega);
                tmp = linsolve(subdict, Y);
                % Updated solution
                Z(omega, :) = tmp;
                % Let us update the residual.
                R = Y - dict.apply(Z);
                resNorm = norm(R, 'fro');
                if self.StopOnResidualNorm || self.StopOnResNormStable
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
            
            % Solution vector
            result.Z = Z;
            % Residual obtained
            result.R = R;
            % Number of iterations
            result.iterations = iter;
            % Solution support
            result.support = omega;
            % residual Frobenius norm
            result.residual_frobenius_norm = resNorm;
            self.result = result;
        end
                
    end
end

