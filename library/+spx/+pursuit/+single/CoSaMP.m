classdef CoSaMP < handle
    %CoSaMP Implements CoSaMP algorithm for sparse approximation

    properties
        % These properties can be configured before running cosamp
        % Default threshold
        errorNormThreshold = 1e-8;
        % Indicates if we should stop on exceeding residual norm
        StopOnResidualNorm = true
        % Indicates if we should stop when residual norm stops improving
        StopOnResNormStable = true
        % Maximum number of iterations for approximation
        MaxIters
        Verbose = false
        ExtraIndicesFactor = 2
        % Indicates if matching pursuit should be used for identification
        UseMPIdentification = false
        % Indicates if least squares should be run on final support
        LSOnFinalSupport = false
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
        function self  = CoSaMP(Dict, K)
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
            maxIter = self.N;
            if K > 0
                % We have to consider pre-specified sparsity level
                maxIter = K;
            end
            self.MaxIters = maxIter;
        end

        function result  = solve(self,y)
            n = self.N;
            d = self.D;
            k = self.K;
            extra_indices = round(self.ExtraIndicesFactor * k);
            dict = self.Dict;
            % Current estimate
            z = zeros(k,1);
            % Current residual
            r = y;
            % Number of iterations
            iterations = 0;
            oldResidualNorm = norm(r);
            minResidualNorm = oldResidualNorm;
            errorNormThreshold = self.errorNormThreshold;
            maxIterations = self.MaxIters;
            result.halted_on_max_iter = false;
            result.halted_on_residual_norm = false;
            result.halted_on_norm_change = false;
            result.halted_on_support_change = false;
            % K indices for current support
            current_support = [];
            while true
                iterations  = iterations+1;
                % We identify the support for largest 2K entries
                extra = extra_indices;
                if isempty(current_support)
                    extra = k + extra;
                end
                if self.UseMPIdentification
                    largest2K  = spx.pursuit.single.CoSaMP.largest_mp(dict, r, extra);
                else
                    largest2K  = spx.pursuit.single.CoSaMP.largest_thresholding(dict, r, extra);
                end
                % We now compute our support
                % build an array holding up to 3 K largest indices
                support_3k = false(d, 1);
                % the older K columns
                support_3k(current_support) = true;
                % New 2K columns
                support_3k(largest2K) = true; % T <= 3K
                % We pickup corresponding columns from Phi
                subdict = dict.columns(support_3k); % MxT
                % We compute signal estimate over these columns
                b_subdict =  linsolve(subdict, y); % TxM * Mx1 
                b = zeros(d,1); % Dx1
                b(support_3k) = b_subdict; % Dx1 with T non-zero
                % We now find the top K coefficients of b
                tmp2 = abs(b);
                [~, indices] = sort(tmp2, 'descend');
                % update current support by choosing largest k indices
                old_support = current_support;
                current_support = indices(1:k)';
                % reset the estimate
                z = zeros(d,1);
                z = b(current_support);
                % We keep the top K coefficients in x
                r = y - dict.apply_columns(z, current_support);
                residualNorm = norm(r);
                if residualNorm > 1.2*minResidualNorm
                    % We are diverging
                    break;
                end
                if residualNorm < oldResidualNorm
                    improvement = (oldResidualNorm - residualNorm) / oldResidualNorm;
                    if improvement < 1e-8
                        % No improvement in this iteration
                        result.halted_on_norm_change = true;
                        break;
                    end
                end
                if(residualNorm < errorNormThreshold)
                    result.halted_on_residual_norm = true;
                    break;
                end
                if iterations >= maxIterations
                    % Too many iterations we are going nowhere
                    result.halted_on_max_iter = true;
                    break;
                end
                if ~isempty(old_support) && all (old_support == current_support)
                    result.halted_on_support_change = true;
                    break;
                end
                % TODO add support for detection of no change 
                % in support
                oldResidualNorm = residualNorm;
                minResidualNorm = min(residualNorm, minResidualNorm);
            end
            % CoSaMP is done
            result.z = zeros(d, 1);
            if self.UseMPIdentification || self.LSOnFinalSupport
                % This is used only in high coherence situations.
                % The least squares estimate is not good enough
                % as it allows more distribution of energy on to other 2K indices
                % solve another least squares problem.
                subdict = dict.columns(current_support);
                z = linsolve(subdict, y);
            end
            result.z(current_support) = z;
            result.r = r;
            result.iterations = iterations;
            result.support = current_support;
        end

        function result  = solve_all(self,Y)
            % Initialization
            % Solves approximation problem using CoSaMP
            d = self.D;
            % Residuals at each stage
            R = Y;
            % Number of signals
            ns = size(Y,2);
            % Active indices 
            omegas = zeros(d, ns);
            % Estimate
            Z = zeros(d, ns);
            iterations = zeros(1, ns);

            for s=1:ns
                if self.Verbose
                    fprintf('.');
                end
                y = Y(:, s);
                result = self.solve(y);
                Z(:, s) = result.z;
                R(:, s) = result.r;
                omegas(result.support, s) = true;
                iterations(s) = result.iterations;
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
            result.Iterations = iterations;
            self.result = result;
            if self.Verbose
                fprintf('\n');
            end
        end
    end

    methods(Static)
        function largest_indices  = largest_thresholding(dict, r, count)
            % We create the proxy of current residual
            e = dict.apply_ctranspose(r);
            tmp = abs(e);
            [~, indices] = sort(tmp, 'descend');
            % We identify the support for largest 2K entries
            largest_indices  = indices(1:count);
        end
        function largest_indices  = largest_mp(dict, r, count)
            % Uses matching pursuit to identify largest indices.
            % We create the proxy of current residual
            d = size(dict,2);
            indices = false(1, d);
            k = 0;
            while k < count
                products = dict.apply_ctranspose(r);
                abs_products = abs(products);
                % Find the highest inner product
                [~, index] = max(abs_products);
                % Add this index to support
                if ~indices(index)
                    % we have discovered a new atom.
                    k = k + 1;
                    indices(index) = true;
                end
                % pick up the coefficient of this inner product
                coeff = products(index);
                % update residual
                r = r - coeff * dict.column(index);
            end
            % We identify the support for largest 2K entries
            largest_indices  = find(indices);
        end
    end

end
