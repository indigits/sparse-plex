close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');
% Number of measurements
M = 64;
% Signal space 
N = 2 * M;
% Dirac-Fourier Dictionary
Phi = spx.dict.simple.dirac_fourier_dict(M);

% Number of signals
Ss = [1, 2, 4, 8, 16, 32];
% Sparsity levels
Ks = 2:2:50;
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
            X = model_3_data(N, K, S);
            % Measurement vectors
            Y = Phi * X;

            % Thresholding MMV solver instance
            thresholding_solver = spx.pursuit.joint.Thresholding(Phi, K, 2);
            % Solve the sparse recovery problem
            result = thresholding_solver.solve(Y);
            % Solution vectors
            X_THR = result.Z;
            % Comparison
            cs = spx.commons.SparseSignalsComparison(X, X_THR, K);
            snr = cs.cum_signal_to_noise_ratio;
            thr_success = snr > snr_threshold;
            num_thr_successes = num_thr_successes + thr_success;
            fprintf('S: %d, K=%d, trial=%d, residual thr: %e, SNR: %f dB\n'...
                , S, K, nt, cs.cum_difference_norm, snr);
        end
        thr_success_with_k(ns, nk) = num_thr_successes / num_trials;
    end
end


save ('bin/figure_2_dirac_fourier_dict_model_3_thr_success_with_k.mat');

