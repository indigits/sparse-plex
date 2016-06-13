classdef SignalsComparison < handle
    % Compares a signal and its approximation over some dictionary
    % The comparison happens in signal space not in measurement space.

    properties(SetAccess=private)
        % Signal set A of reference signals
        References
        % Signal set B of estimated signals
        Estimates
        % Difference
        Differences
        % Number of signals
        S
    end

    properties(Access=private)
        % Sparse references
        SparseReferences = []
        % Indices where the reference vectors had K-largest entries 
        ReferenceLargestIndices = []
        %  Sparse estimates
        SparseEstimates = []
        % Indices where the estimate vectors had K-largest entries 
        EstimateLargestIndices = []
    end

    methods
        function self = SignalsComparison(References, Estimates)
            self.References = References;
            self.Estimates = Estimates;
            assert(all(size(References) == size(Estimates)));
            self.S = size(References, 2);
            self.Differences = References - Estimates;
        end

        function result = difference_norms(self)
            result = spx.commons.norm.norms_l2_cw(self.Differences);
        end

        function result = reference_norms(self)
            result = spx.commons.norm.norms_l2_cw(self.References);
        end

        function result = estimate_norms(self)
            result = spx.commons.norm.norms_l2_cw(self.Estimates);
        end

        function result = error_to_signal_norms(self)
            a_norms = self.reference_norms();
            err_norms = self.difference_norms();
            result = err_norms./a_norms;
        end

        function result = signal_to_noise_ratios(self)
            a_norms = self.reference_norms();
            err_norms = self.difference_norms();
            result = a_norms ./ err_norms;
            result = 20 * log10(result);
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


        function summarize(self)
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
            for s=1:S
                fprintf('\nSignal: %d\n', s);
                fprintf('  Reference norm: %.8f\n', rnorms(s));
                fprintf('  Estimate norm: %.8f\n', enorms(s));
                fprintf('  Error norm: %.8f\n', dnorms(s));
                fprintf('  SNR: %.4f dB\n', snrs(s));
            end
            fprintf('\n');
        end
    end
end
