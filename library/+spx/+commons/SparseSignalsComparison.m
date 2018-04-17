classdef SparseSignalsComparison < handle

    properties(SetAccess=private)
        % Signal set A of reference signals
        References
        % Signal set B of estimated signals
        Estimates
        % Difference
        Differences
        % Sparsity level
        K
        % Number of signals
        S
    end

    properties(Access=private)
        % Sparse references (K largest entries)
        SparseReferences = []
        % Indices where the reference vectors had K-largest entries 
        ReferenceLargestIndices = []
        %  Sparse estimates (K largest entries)
        SparseEstimates = []
        % Indices where the estimate vectors had K-largest entries 
        EstimateLargestIndices = []
    end

    methods
        % Constructor
        function self = SparseSignalsComparison(References, Estimates, K)
            self.References = full(References);
            self.Estimates = full(Estimates);
            % Sizes must be same
            assert(all(size(References) == size(Estimates)));
            % Number of vectors
            self.S = size(References, 2);
            % Compute difference between reference and estimate
            self.Differences = References - Estimates;
            % See if sparsity level has been specified or not
            if nargin < 3
                K = -1;
            end
            self.K  = K;
        end

        function result = difference_norms(self)
            % Returns the norms of difference vectors
            result = spx.norm.norms_l2_cw(self.Differences);
        end

        function result = reference_norms(self)
            % Returns the norms of reference vectors
            result = spx.norm.norms_l2_cw(self.References);
        end

        function result = estimate_norms(self)
            % Returns the norms of estimate vectors
            result = spx.norm.norms_l2_cw(self.Estimates);
        end

        function result = error_to_signal_norms(self)
            % Returns the ratios between error norm and signal norm
            a_norms = self.reference_norms();
            err_norms = self.difference_norms();
            result = err_norms./a_norms;
        end

        function result = signal_to_noise_ratios(self)
            % Returns SNR for each vector
            a_norms = self.reference_norms();
            err_norms = self.difference_norms();
            result = a_norms ./ err_norms;
            result = 20 * log10(result);
        end

        function result = sparse_references(self)
            % K largest entries from each reference vector
            if self.K <= 0
                error('No sparsity specified');
            end
            if isempty(self.SparseReferences)
                [self.SparseReferences, self.ReferenceLargestIndices] = spx.commons.SparseSignalsComparison.sparse_approximation(self.References, self.K);
            end
            result  = self.SparseReferences;
        end

        function sparse_estimates(self)
            if self.K <= 0
                error('No sparsity specified');
            end
            if isempty(self.SparseEstimates)
                [self.SparseEstimates, self.EstimateLargestIndices] = spx.commons.SparseSignalsComparison.sparse_approximation(self.Estimates, self.K);
            end
            result  = self.SparseEstimates;
        end

        function result = cum_difference_norm(self)
            result = norm(self.Differences, 'fro');
        end

        function result = cum_reference_norm(self)
            result = norm(self.References, 'fro');
        end

        function result = cum_estimate_norm(self)
            result = norm(self.Estimates, 'fro');
        end

        function result = cum_error_to_signal_norm(self)
            % Returns the ratios between error norm and signal norm
            a_norm = self.cum_reference_norm();
            err_norm = self.cum_difference_norm();
            result = err_norm./a_norm;
        end

        function result = cum_signal_to_noise_ratio(self)
            % Returns SNR for each vector
            a_norm = self.cum_reference_norm();
            err_norm = self.cum_difference_norm();
            result = a_norm ./ err_norm;
            result = 20 * log10(result);
        end


        function result = reference_sparse_supports(self)
            % The indices of K largest entries in reference vectors
            self.sparse_references();
            result = self.ReferenceLargestIndices;
        end

        function result = estimate_sparse_supports(self)
            % The indices of K largest entries in estimate vectors
            self.sparse_estimates();
            result = self.EstimateLargestIndices;
        end

        function result = support_similarity_ratios(self)
            % support similarity ratio for each vector
            k = self.K;
            if k <= 0
                error('No sparsity specified');
            end
            % Get the supports of K largest entries in reference and estimates
            a = self.reference_sparse_supports();
            b = self.estimate_sparse_supports();

            result = zeros(1, self.S);
            % Iterate over vectors
            for s=1:self.S
                % Identify common indices
                common = intersect(a(:, s), b(:, s));
                % compute support similarity ratio
                result(s) = length(common) / k;
            end
        end

        function result = has_matching_supports(self, threshold)
            % Returns the vectors for which support similarity crosses a threshold.
            % Typical value of threshold 1.0 or .75.
            if nargin < 2
                threshold = 1.0;
            end
            similarity_ratios = self.support_similarity_ratios();
            result = similarity_ratios >= threshold;
        end

        function result = all_have_matching_supports(self, threshold)
            if nargin < 2
                threshold = 1.0;
            end
            % Returns true if all signals have same K-sparse support
            result = self.has_matching_supports(threshold);
            result = all(result);
        end

        function summarize(self)
            % Summarizes comparison results
            [N, S] = size(self.References);
            fprintf('\nSignal dimension: %d\n', N);
            fprintf('Number of signals: %d\n', S);
            fprintf('Combined reference norm: %.8f\n', self.cum_reference_norm());
            fprintf('Combined estimate norm: %.8f\n', self.cum_estimate_norm());
            fprintf('Combined difference norm: %.8f\n', self.cum_difference_norm());
            fprintf('Combined SNR: %.4f dB\n', self.cum_signal_to_noise_ratio());
            if S > 10
                return;
            end
            rnorms = self.reference_norms();
            enorms = self.estimate_norms();
            dnorms = self.difference_norms();
            snrs = self.signal_to_noise_ratios();
            k = self.K;
            if k > 0 
                fprintf('Specified sparsity level: %d\n', k);
                ss_ratios = self.support_similarity_ratios();
            end
            for s=1:S
                fprintf('\nSignal: %d\n', s);
                fprintf('  Reference norm: %.8f\n', rnorms(s));
                fprintf('  Estimate norm: %.8f\n', enorms(s));
                fprintf('  Error norm: %.8f\n', dnorms(s));
                fprintf('  SNR: %.4f dB\n', snrs(s));
                if k > 0
                    ratio = ss_ratios(s);
                    fprintf('  Support similarity ratio: %.2f\n', ratio);
                    if ratio < 1
                        % we should show the indices too
                        a_indices = self.ReferenceLargestIndices(:, s);
                        b_indices = self.EstimateLargestIndices(:, s);
                        disp(a_indices');
                        disp(b_indices');
                    end
                end
            end
            fprintf('\n');
        end
    end

    methods(Static)
        function [approximations, indices] = sparse_approximation(X, K)
            % Creates sparse approximations of all columns in X
            [N, S] = size(X);
            approximations = zeros(N, S);
            indices = zeros(K, S);
            for s=1:S
                % s-th signal
                x  = X(:, s);
                % sort x by magnitude
                [sorted, idx] = sort(abs(x), 'descend');
                % Pick the first K indices
                first_k  = idx(1:K);
                % Save the indices
                indices(:, s) = first_k;
                % Copy the largest entries
                approximations(first_k, s) = x(first_k);
            end
        end
    end

end
