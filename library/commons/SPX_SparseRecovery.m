classdef SPX_SparseRecovery < handle

    methods(Static)
        function [ M ] = phase_transition_estimate_m( N,K )
        %PHASE_TRANSITION_ESTIMATE_M Estimates the value of M based on
        %Phase transition analysis by Donoho
        % We estimate M based on Phase transition analysis by Donoho
        M = 2* K * log(N);
        M = (fix(M /10) + 1)*10;
        end


        function result = recovery_performance(Phi, K, y, x, x_rec)
            [M, N] = size(Phi);
            % Norms of different signals
            result.representation_norm = norm(x);
            result.measurement_norm = norm(y);
            result.reconstruction_norm = norm(x_rec);
            % recovery error vector. N length vector
            h = x - x_rec;
            result.recovery_error_vector = h;
            % l_2 norm of reconstruction error
            result.recovery_error_norm = norm(h);
            % recovery SNR
            result.recovery_snr = 20 * log10 (result.representation_norm / result.recovery_error_norm);
            % The K non-zero coefficients in x (set of indices)
            result.T0 = find (x ~= 0);
            % The portion of recovery error over T0 K length vector
            result.recovery_error_vector_T0 = h(result.T0); 
            % Positions of other places (set of indices)
            result.T0C = setdiff(1:N , result.T0);
            % Recovery error at T0C places [N - K] length vector
            hT0C = h(result.T0C);
            result.recovery_error_vector_T0C = hT0C;
            % The K largest indices after T0 in recovery error (set of indices)
            result.T1 = SPX_Signals.largest_indices(hT0C, K);
            % The recovery error component over T1. [K] length vector.
            hT1 = h(result.T1);
            result.recovery_error_vector_T1 = hT1;
            % Remaining indices [N - 2K] set of indices
            result.TRest = setdiff(result.T0C , result.T1);
            % Recovery error over remaining indices [N - 2K] length vector
            hTRest = h(result.TRest);
            result.recovery_error_vector_TRest = hTRest;
            % largest indices of the recovered vector
            result.TT0 = sort(SPX_Signals.largest_indices(x_rec, K));
            % Support Overlap
            result.support_overlap = intersect(result.T0, result.TT0);
            % Support recovery ratio
            result.support_recovery_ratio = numel(result.support_overlap) / K;
            % measurement error vector [M] length vector
            e = y - Phi * x_rec;
            result.measurement_error_vector = e;
            % Norm of measurement error.  This must be less than epsilon
            result.measurement_error_norm = norm(e);
            % Measurement SNR
            result.measurement_snr = 20 * log10(result.measurement_norm / result.measurement_error_norm);
            % Ratio between the norm of recovery error and measurement error
            result.recovery_error_to_measurement_error_norm_ratio = ...
                result.recovery_error_norm / result.measurement_error_norm;
            % whether we consider the process to be success or not.
            % We consider success only if the support has been recovered
            % completely.
            result.success = numel(result.support_overlap) == K;
        end

        function print_recovery_performance(result)
            fprintf('Recovery success: %s\n', SPX.yes_no(result.success));
            fprintf('Representation norm: %0.4f\n', result.representation_norm);
            fprintf('Measurement norm: %0.4f\n', result.measurement_norm);
            fprintf('Reconstruction norm: %0.4f\n', result.reconstruction_norm);
            fprintf('Recovery error norm: %0.2e\n', result.recovery_error_norm);
            fprintf('Measurement error norm: %0.2e\n', result.measurement_error_norm);
            fprintf('Recovery SNR: %.0f dB\n', result.recovery_snr);
            fprintf('Measurement SNR: %.0f dB\n', result.measurement_snr);
            fprintf('Support recovery ratio: %.0f%%\n', result.support_recovery_ratio * 100);
            fprintf('Ratio of recovery error and measurement error norms: %0.4f\n', result.recovery_error_to_measurement_error_norm_ratio);
            if length(result.T0) < 10
                fprintf('\n');
                fprintf('Support of representation vector:         ');
                for i=result.T0
                    fprintf('%d ', i);
                end
                fprintf('\n');
                fprintf('Largest entries of reconstruction vector: ');
                for i=result.TT0
                    fprintf('%d ', i);
                end
                fprintf('\n');
                fprintf('Support overlap:                          ');
                for i=result.support_overlap
                    fprintf('%d ', i);
                end
                fprintf('\n');
            end
        end
    end

end