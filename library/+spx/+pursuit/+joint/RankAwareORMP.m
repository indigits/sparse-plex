classdef RankAwareORMP < handle
    % Implements Rank Aware Order Recursive Matching Pursuit algorithm for sparse approximation in MMV case
    
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
        function self  = RankAwareORMP(Dict, K)
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
            if self.StopOnResNormStable
                oldResNorm = norm(R, 'fro');
            end
            maxIter = self.MaxIters;
            % Create space for storing the Q R factors
            Q_factor = zeros(n, maxIter);
            R_factor = zeros(maxIter);
            % Maintain a flat version of the dictionary
            flat_dict = double(dict);
            % ZR stores projections of y along the directions
            % in Q. 
            % Since vectors in Q are orthonormal, 
            % hence computing projections is as easy as 
            % taking inner product.
            % This also simplifies the process of updating
            % the residual as the residual is orthogonal 
            % to the vectors selected in Q so far.
            ZR = zeros(maxIter, s);
            for iter=1:maxIter

                % The Q part of previous iteration
                QLast = Q_factor(:, 1:iter-1); % n * (k - 1)
                % The Orthogonal Projector
                OrthoProjector = eye(n) -  QLast * QLast';
                % Orthogonalize the remaining atoms of the dictionary
                qdict = OrthoProjector * flat_dict;
                % Normalize the columns
                qdict = spx.commons.norm.normalize_l2(qdict);

                % Orthonormalize Residual
                U = orth(R); % R is n x s. U is n x r.
                % Compute inner products (DxN  * N x r = D x r )
                innerProducts = qdict' * U;
                % Compute absolute values of inner products
                innerProducts = abs(innerProducts);
                % Compute l2 norm inner products over each row
                innerProducts = spx.commons.norm.norms_l2_rw(innerProducts);
                % Mark the inner products of already selected columns as 0.
                innerProducts(omega) = 0;
                % Find the highest inner product
                [~, index] = max(innerProducts);
                % Add this index to support
                omega = [omega, index];


                % Pick the new atom from the dictionary
                new_atom = flat_dict(:, index);
                % Orthogonalize the new atom
                %Compute projections to previously selected vectors in Q
                projections = QLast'* new_atom;
                % Remove the projection
                new_q = new_atom - QLast * projections;
                % Normalize
                norm_q = norm(new_q);
                new_q = new_q / norm_q;
                % Place it 
                Q_factor(:, iter) = new_q;
                % Update R
                R_factor(1:iter-1, iter) = projections;
                R_factor(iter, iter) = norm_q;


                % Compute the projection of y on new q.
                ZR(iter, :) = new_q' * Y;
                % Let us update the residual.
                R = R - new_q * ZR(iter, : );

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
            % Estimate
            Z = zeros(d, s);
            % We need to use back-substitution  with R to get z from zr.
            opts.UT = true;
            tmp = linsolve(R_factor(1:iter,1:iter), ZR(1:iter, :), opts);
            Z(omega, :) = tmp;
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

