classdef GOMP < handle
    %GOMP Implements the Generalized OMP-MMV algorithm for sparse approximation

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
        % The norm to be chosen for rows
        P
    end
    
    methods
        function self  = GOMP(Dict, K, P)
            if nargin < 3
                % By default we apply l_1 norm on rows
                P = 1;
            end
            if P ~= 1 &&  P ~= 2
                error('Only l_1 and l_2 norms are supported.');
            end
            self.P = P;
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

        function result  = solve(self, Y)
            % Solves approximation problem using Generalized OMP

            % Initialization

            % number of atoms
            d = self.D;
            % signal dimension
            n = self.N;
            % The number of signals being approximated.
            s = size(Y, 2);
            % dictionary
            dict = self.Dict;
            % sparsity level
            nk = self.K;
            % norm for residual rows
            P = self.P;
            % the number of atoms to be selected in each iteration
            l = self.L;
            % Active indices 
            lambdas = [];
            % Initialize residual 
            R = Y;
            if self.StopOnResNormStable
                old_residual_norm = norm(R, 'fro');
            end
            max_iter = self.MaxIters;
            for iter=1:max_iter
                % Compute inner products
                inner_products = apply_ctranspose(dict, R);
                % Mark the inner products of already selected atoms as 0.
                inner_products(lambdas, :) = 0;
                % take the absolute values
                inner_products = abs(inner_products);
                if P == 1
                    % Compute sum of inner products over each row
                    inner_products = sum(inner_products, 2);
                elseif P == 2
                    % Compute l2 norm inner products over each row
                    inner_products = spx.norm.norms_l2_rw(inner_products);
                else
                    error('Impossible');
                end
                % Find the highest inner products
                [~, indices] = sort(inner_products, 'descend');
                % Add l indices to the support
                lambdas = [lambdas, indices(1:l)];
                % Solve least squares problem
                subdict = columns(dict, lambdas);
                tmp = linsolve(subdict, Y);
                % Let us update the residual.
                R = Y - subdict * tmp;
                if self.StopOnResidualNorm || self.StopOnResNormStable
                    residual_norm = norm(R, 'fro');
                    if residual_norm / s < self.ResidualNormThreshold
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
            Z = zeros(d, s);
            Z(lambdas, :) = tmp;
            % Solution vector
            result.Z = Z;
            % Residual obtained
            result.R = R;
            % Number of iterations
            result.iterations = iter;
            % Solution support
            result.support = lambdas;
            self.result = result;
        end


    end
end

