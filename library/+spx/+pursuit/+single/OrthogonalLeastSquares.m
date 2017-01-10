classdef OrthogonalLeastSquares < handle
    %CSOLSAPPROX Implements OLS algorithm for sparse approximation
    
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
        function self  = OrthogonalLeastSquares(Dict, K)
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
        

        function result  = solve(self,y)
            % Uses QR factorization to implement the OLS 

            % Initialization
            % Solves approximation problem using OLS
            d = self.D;
            n = self.N;
            r = y;
            min_k  = self.MinK;
            dict = self.Dict;
            % Active indices 
            omega = [];
            if self.StopOnResNormStable
                oldResNorm = norm(r);
            end
            maxIter = self.MaxIters;
            % Create space for storing the Q R factors
            Q = zeros(n, maxIter);
            R = zeros(maxIter);
            % zr stores projections of y along the directions
            % in Q. 
            % Since vectors in Q are orthonormal, 
            % hence computing projections is as easy as 
            % taking inner product.
            % This also simplifies the process of updating
            % the residual as the residual is orthogonal 
            % to the vectors selected in Q so far.
            zr = [];

            ignored_atom = self.IgnoredAtom;
            % Convert the dictionary into a matrix
            dict = double(dict);

            for iter=1:maxIter
                % The Q part of previous iteration
                QLast = Q(:, 1:iter-1); % n * (k - 1)
                % The Orthogonal Projector
                OrthoProjector = eye(n) -  QLast * QLast';
                % Orthogonalize the remaining atoms of the dictionary
                qdict = OrthoProjector * dict;
                % Normalize the columns
                qdict = spx.norm.normalize_l2(qdict);
                % Compute inner products
                innerProducts = qdict' * r;
                % Mark the inner products of already selected columns as 0.
                innerProducts(omega) = 0;
                innerProducts = abs(innerProducts);
                if ignored_atom > 0
                    % forcefully ignore this atom
                    innerProducts(ignored_atom) = 0;
                end 
                % Find the highest inner product
                [~, index] = max(innerProducts);
                % Add this index to support
                omega = [omega, index];
                % Pick the new atom from the dictionary
                new_atom = dict(:, index);
                % Orthogonalize the new atom
                %Compute projections to previously selected vectors in Q
                projections = QLast'* new_atom;
                % Remove the projection
                new_q = new_atom - QLast * projections;
                % Normalize
                norm_q = norm(new_q);
                new_q = new_q / norm_q;
                % Place it 
                Q(:, iter) = new_q;
                % Update R
                R(1:iter-1, iter) = projections;
                R(iter, iter) = norm_q;
                % Compute the projection of y on new q.
                zr(iter) = new_q' * y;
                % Let us update the residual.
                r = r - zr(iter) * new_q;
                if self.StopOnResidualNorm || self.StopOnResNormStable
                    resNorm = norm(r);
                    if resNorm < self.MaxResNorm && iter > min_k
                        break;
                    end
                    if self.StopOnResNormStable
                        change = abs(oldResNorm  - resNorm);
                        if change/oldResNorm < .01  && iter > min_k
                            % No improvement
                            break;
                        end
                    end
                end
            end
            % Estimate
            z = zeros(d, 1);
            % We need to use back-substitution  with R to get z from zr.
            opts.UT = true;
            tmp = linsolve(R(1:iter,1:iter), zr(1:iter)', opts);
            z(omega)= tmp;
            % Solution vector
            result.z = z;
            % Residual obtained
            result.r = r;
            % residual norm
            result.rnorm = resNorm;
            % Number of iterations
            result.iterations = iter;
            % Solution support
            result.support = omega;
            self.result = result;
        end
        
    end

end

