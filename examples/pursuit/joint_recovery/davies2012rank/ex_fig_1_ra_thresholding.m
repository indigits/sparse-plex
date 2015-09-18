% Studies the recovery probability of rank aware thresholding
% with sparsity level and number of channels in joint recovery.

close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');
% Signal space 
N = 256;
% Number of measurements
M = 32;
% Number of signals
Ss = [1, 2, 4, 8, 16, 32];
% Sparsity levels
Ks = 2:30;
num_trials = 200;
num_ks = length(Ks);
num_ss = length(Ss);
success_with_k = zeros(num_ss, num_ks);


snr_threshold = 100;

for ns=1:num_ss
    % Current sparsity level
    S = Ss(ns);
    for nk=1:num_ks
        K = Ks(nk);
        num_successes = 0;
        for nt=1:num_trials
            % Sensing matrix
            Phi = SPX_SimpleDicts.gaussian_dict(M, N);
            % Sparse signal generator
            gen  = SPX_SparseSignalGenerator(N, K, S);
            % Gaussian distributed non-zero samples
            X = gen.gaussian;
            % Measurement vectors
            Y = Phi * X;
            % Create the solver for rank aware thresholding
            solver = SPX_RankAwareThresholding(Phi, K);
            result = solver.solve(Y);
            % Solution vectors
            X_Rec = result.Z;
            % Comparison
            cs = SPX_SparseSignalsComparison(X, X_Rec, K);
            % Reconstruction SNR
            snr = cs.cum_signal_to_noise_ratio;
            success = snr > snr_threshold;
            num_successes = num_successes + success;
            fprintf('S: %d, K=%d, trial=%d, residual: %e, SNR: %f dB\n'...
                , S, K, nt, cs.cum_difference_norm, snr);
        end
        success_with_k(ns, nk) = num_successes / num_trials;
    end
end


save ('bin/figure_1_ra_thresholding_success_with_K_S.mat');

