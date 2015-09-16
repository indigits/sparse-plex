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
Ks = 1:25;
num_trials = 100;
num_ks = length(Ks);
num_ss = length(Ss);
thr_success_with_k = zeros(num_ss, num_ks);


snr_threshold = 100;

for ns=1:num_ss
    % Current sparsity level
    S = Ss(ns);
    for nk=1:num_ks
        K = Ks(nk);
        num_thr_successes = 0;
        for nt=1:num_trials
            % Sensing matrix
            Phi = SPX_SimpleDicts.gaussian_dict(M, N);
            X = model_1_data(N, K, S);
            % Measurement vectors
            Y = Phi * X;

            % Thresholding MMV solver instance
            thresholding_solver = SPX_Thresholding_MMV(Phi, K, 2);
            % Solve the sparse recovery problem
            result = thresholding_solver.solve(Y);
            % Solution vectors
            X_OMP = result.Z;
            % Comparison
            cs = SPX_SparseSignalsComparison(X, X_OMP, K);
            snr = cs.cum_signal_to_noise_ratio;
            thr_success = snr > snr_threshold;
            num_thr_successes = num_thr_successes + thr_success;
            fprintf('S: %d, K=%d, trial=%d, residual thr: %e, SNR: %f dB\n'...
                , S, K, nt, cs.cum_difference_norm, snr);
        end
        thr_success_with_k(ns, nk) = num_thr_successes / num_trials;
    end
end


save ('bin/figure_1_spherical_dict_model_1_thresholding_success_with_k.mat');

