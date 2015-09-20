classdef SPX_HardThresholdingPursuit < handle
    % Implements Hard Thresholding Pursuit algorithm for sparse approximation
    
    properties
        % Maximum residual norm
        MaxResNorm = 1e-4
        % Indicates if we should stop on exceeding residual norm
        StopOnResidualNorm = true
        % Indicates if we should stop when residual norm stops improving
        StopOnResNormStable = true
        % Printing additional debugging information
        Verbose = false
    end
    
    properties(SetAccess=private)
        % The dictionary
        Dict
        % Ambient signal dimensions
        N
        % Number of atoms in dictionary
        D
        % Sparsity level of representations (must be specified)
        K
        % Result of a solver
        result
    end
    
    methods
        function self  = SPX_HardThresholdingPursuit(Dict, K)
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
                error('Sparsity level must be pre-specified');
            end
            self.K = K;
        end
        

        function result  = solve(self,y)
            % Initialization
            d = self.D;
            n = self.N;
            r = y;
            k = self.K;
            dict = self.Dict;
            % Active indices 
            omega = [];
            omega_prev = [];
            % Estimate
            z = zeros(d, 1);
            if self.StopOnResNormStable
                prev_residual_norm = norm(r);
            end
            y_hat = zeros(n, 1);
            max_iterations = d;
            for iterations=1:max_iterations
                % Find the proxy of the residual
                residual_proxy = apply_ctranspose(dict, r);
                % Find a new estimate by adding the residual proxy to old estimate
                estimate = z + residual_proxy;
                % Apply hard thresholding to pick K largest entries in the new estimate
                omega = sort(SPX_Signals.largest_indices(estimate, k));
                % If support hasn't changed, then there is no need to proceed further
                if ~isempty(omega_prev) && all(omega == omega_prev)
                    if self.Verbose fprintf('Breaking on support stability\n'); end
                    break;
                end
                % Identify corresponding columns in dictionary
                subdict = columns(dict, omega);
                % Solve the least squares problem
                z_omega = linsolve(subdict, y);
                % Compute the new measurement vector estimate
                y_hat = subdict * z_omega;
                % Compute the new representation vector estimate
                z = zeros(d, 1);
                z(omega) = z_omega; 
                % Compute the new measurement residual
                r = y - y_hat;
                % Track the current index set for next step.
                omega_prev = omega;
                % Check if residual has stopped changing.
                if self.StopOnResidualNorm || self.StopOnResNormStable
                    residual_norm = norm(r);
                    if residual_norm < self.MaxResNorm
                    if self.Verbose fprintf('Breaking on norm limit\n'); end
                        break;
                    end
                    if self.StopOnResNormStable
                        change = abs(prev_residual_norm  - residual_norm);
                        if change/prev_residual_norm < .01
                            % No improvement
                            if self.Verbose fprintf('Breaking on norm stability\n'); end
                            break;
                        end
                    end
                end
            end
            % Solution vector
            result.z = z;
            % Residual obtained
            result.r = r;
            % residual norm
            result.rnorm = residual_norm;
            % Number of iterations
            result.iterations = iterations;
            % Solution support
            result.support = omega;
            self.result = result;
        end
        
    end

end

