classdef SPX_CoSaMP_MMV < handle
    % Implements CoSaMP-MMV algorithm for sparse recovery

    properties
        % These properties can be configured before running cosamp
        % Default threshold
        errorNormThreshold = 1e-6;
        % Maximum number of iterations for approximation
        MaxIters
        Verbose = false
        % Indicates if matching pursuit should be used for identification
        % UseMPIdentification = false
        % Indicates if least squares should be run on final support
        LSOnFinalSupport = false
        % The norm to be chosen for rows
        P
        % Indicates that residuals should be orthogonalized for rank awareness
        RankAwareResidual = false
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
        function self  = SPX_CoSaMP_MMV(Dict, K, P, options)
            if nargin < 3
                % By default we apply l_1 norm on rows
                P = 1;
            end
            if P ~= 1 &&  P ~= 2
                error('Only l_1 and l_2 norms are supported.');
            end
            self.P = P;
            % We assume that all the columns in dictionary are normalized.
            if isa(Dict, 'SPX_Operator')
                self.Dict = Dict;
            elseif ismatrix(Dict)
                self.Dict = SPX_MatrixOperator(Dict); 
            else
                error('Unsupported operator.');
            end
            [self.N, self.D] = size(Dict);
            if nargin < 2
                % No sparsity level has been pre-specified.
                % We make an estimate of sparsity level
                % based on phase transition analysis by Donoho
                K = round((self.N / 2) * log (self.D));
            end
            self.K = K;
            % Maximum number of iterations
            maxIter = 30;
            self.MaxIters = maxIter;
            if nargin >= 4
                % options have been specified 
                if isfield(options, 'RankAwareResidual')
                    self.RankAwareResidual = options.RankAwareResidual;
                end
            end
        end

        function result  = solve(self,Y)
            n = self.N;
            d = self.D;
            k = self.K;
            % The number of signals being approximated.
            s = size(Y, 2);            
            dict = self.Dict;
            % Current estimate
            solution_nz_mat = zeros(k,s);
            % Current residual
            residual_mat = Y;
            % Number of iterations
            iterations = 0;
            y_norm = norm(Y, 'fro');
            old_residual_norm = 1;
            min_residual_norm = old_residual_norm;
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
                extra = 2*k;
                % if isempty(current_support)
                %     extra = k + extra;
                % end
                if self.RankAwareResidual
                    residual_mat = orth(residual_mat);
                end
                % Compute the proxy
                proxy_mat = dict.apply_ctranspose(residual_mat);
                % identify the largest entries
                largest_2k  = SPX_CoSaMP_MMV.largest_k_l2(proxy_mat, extra);
                % We now compute our support
                % build an array holding up to 3 K largest indices
                support_3k = false(d, 1);
                % the older K columns
                support_3k(current_support) = true;
                % New 2K columns
                support_3k(largest_2k) = true; % T <= 3K
                % We pickup corresponding columns from Phi
                subdict = dict.columns(support_3k); % MxT
                % We compute signal estimate over these columns
                % B_subdict =  linsolve(subdict, Y); % TxM * MxS
                B_subdict = SPX_CoSaMP_MMV.least_squares_on_support(subdict, Y);
                % sort them in descending row norm order
                pruned_largest_k =  SPX_CoSaMP_MMV.largest_k_l2(B_subdict, k);
                % keep only first k rows as new solution
                solution_nz_mat = B_subdict(pruned_largest_k, :);
                old_support = current_support;
                % update current support by choosing largest k indices
                support_3k = find(support_3k == 1);
                current_support = support_3k(pruned_largest_k);
                % compute the measurement estimate
                y_estimate_matrix = dict.apply_columns(...
                    solution_nz_mat, current_support);
                % compute the new residual
                residual_mat = Y - y_estimate_matrix;
                % compute the residual norm
                residual_norm = norm(residual_mat, 'fro');
                residual_norm = residual_norm / y_norm;
                % how many indices have been added and/or removed
                support_change = length(union(old_support,current_support)) - length(intersect(old_support,current_support));
                % if residual_norm > 1.2*min_residual_norm
                %     % We are diverging
                %     break;
                % end
                if residual_norm < old_residual_norm
                    improvement = (old_residual_norm - residual_norm) / old_residual_norm;
                    % if improvement < 1e-8
                    %     % No improvement in this iteration
                    %     result.halted_on_norm_change = true;
                    %     break;
                    % end
                end
                if(residual_norm < errorNormThreshold)
                    result.halted_on_residual_norm = true;
                    break;
                end
                if iterations >= maxIterations
                    % Too many iterations we are going nowhere
                    result.halted_on_max_iter = true;
                    break;
                end
                if ~isempty(old_support) && support_change == 0
                    result.halted_on_support_change = true;
                    break;
                end
                % TODO add support for detection of no change 
                % in support
                old_residual_norm = residual_norm;
                min_residual_norm = min(residual_norm, min_residual_norm);
            end
            % CoSaMP is done
            if  self.LSOnFinalSupport
                % This is used only in high coherence situations.
                % The least squares estimate is not good enough
                % as it allows more distribution of energy on to other 2K indices
                % solve another least squares problem.
                subdict = dict.columns(current_support);
                solution_nz_mat = linsolve(subdict, Y);
            end
            % copy the solution
            result.Z = zeros(d, s);
            result.Z(current_support, :) = solution_nz_mat;
            % copy the measurement residual
            result.R = residual_mat;
            result.iterations = iterations;
            result.support = current_support;
        end

    end

    methods(Static)
        function largest_indices  = largest_thresholding(dict, R, count)
            % We create the proxy of current residual
            E = dict.apply_ctranspose(R);
            tmp = abs(e);
            [~, indices] = sort(tmp, 'descend');
            % We identify the support for largest count entries
            largest_indices  = indices(1:count);
        end

        function largest_indices = largest_k_l1(data_matrix, K)
            sums = SPX_Norm.norms_l1_rw(data_matrix);
            [~, indices] = sort(sums, 'descend');
            % We identify the support for largest K entries
            largest_indices  = indices(1:K);
        end

        function largest_indices = largest_k_l2(data_matrix, K)
            sums = SPX_Norm.norms_l2_rw(data_matrix);
            [~, indices] = sort(sums, 'descend');
            % We identify the support for largest K entries
            largest_indices  = indices(1:K);
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

        function X = least_squares_on_support(subdict, Y)
            [U,s,V] = csvd(subdict);
            num_signals = size(Y, 2);
            num_cols = size(subdict, 2);
            X = zeros(num_cols, num_signals);
            x = zeros(num_cols, 1);
            for ns=1:num_signals
                y = Y(:, ns);
                normBound = 2*norm(y);
                [alpha2,lambda,maxIterReached] = lsqi(U,s,V,y,normBound);
                if maxIterReached
                    % lsqi did not converge; use cvx (slower) instead
                    [aa,bb] = size(subdict);
                    cvx_begin quiet
                      variable alpha3(bb) complex;
                      minimize norm(y - subdict*alpha3)
                      subject to
                      norm(alpha3) <= normBound;
                    cvx_end
                    x = alpha3;
                else   
                    x = alpha2;
                end
                X(:, ns) = x;
            end
        end
    end
end

