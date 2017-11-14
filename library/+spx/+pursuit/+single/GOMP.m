classdef GOMP < handle
    %GOMP Implements the Generalized OMP algorithm for sparse approximation

    properties
        % These properties can be configured before running cosamp
        % Default residual norm threshold
        ResidualNormThreshold = 1e-6;
        % Indicates if we should stop on exceeding residual norm
        StopOnResidualNorm = true
        % Indicates if we should stop when residual norm stops improving
        StopOnResNormStable = true
        % Maximum number of iterations for approximation
        MaxIters
        % Indicates if extra logging should be done.
        Verbose = false
        % The number of atoms to be selected in each iteration
        L = 2
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
        function self  = GOMP(Dict, K)
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
                % We make an estimate of sparsity level
                % based on phase transition analysis by Donoho
                K = round((self.N / 2) * log (self.D));
            end
            self.K = K;
            % Maximum number of iterations
            max_iter = self.N;
            if K > 0
                % We have to consider pre-specified sparsity level
                max_iter = K;
            end
            self.MaxIters = max_iter;
        end

        function result  = solve(self,y)
            % Solves approximation problem using Generalized OMP

            % Initialization

            % number of atoms
            d = self.D;
            % signal dimension
            n = self.N;
            % dictionary
            dict = self.Dict;
            % sparsity level
            nk = self.K;
            % the number of atoms to be selected in each iteration
            l = self.L;
            % Active indices 
            lambdas = [];
            % residual 
            r = y;
            if self.StopOnResNormStable
                old_residual_norm = norm(r);
            end
            max_iter = self.MaxIters;
            for iter=1:max_iter
                % Compute inner products
                inner_products = apply_ctranspose(dict, r);
                % Mark the inner products of already selected columns as 0.
                inner_products(lambdas) = 0;
                % take the absolute values
                inner_products = abs(inner_products);
                % Find the highest inner products
                [~, indices] = sort(inner_products, 'descend');
                % Add l indices to the support
                lambdas = [lambdas, indices(1:l)];
                % Solve least squares problem
                subdict = columns(dict, lambdas);
                tmp = linsolve(subdict, y);
                % Let us update the residual.
                r = y - subdict * tmp;
                if self.StopOnResidualNorm || self.StopOnResNormStable
                    residual_norm = norm(r);
                    if residual_norm < self.ResidualNormThreshold
                        break;
                    end
                    if self.StopOnResNormStable
                        change = abs(old_residual_norm  - residual_norm);
                        if change/old_residual_norm < .01
                            % No improvement
                            break;
                        end
                    end
                end
            end
            % Estimated representation
            z = zeros(d, 1);
            z(lambdas) = tmp;
            % Solution vector
            result.z = z;
            % Residual obtained
            result.r = r;
            % Number of iterations
            result.iterations = iter;
            % Solution support
            result.support = lambdas;
            self.result = result;
        end


    end
end

