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
omp_success_with_k = zeros(num_ss, num_ks);


snr_threshold = 100;

for ns=1:num_ss
    % Current sparsity level
    S = Ss(ns);
    for nk=1:num_ks
        K = Ks(nk);
        num_omp_successes = 0;
        for nt=1:num_trials
            X = model_3_data(N, K, S);
            % Measurement vectors
            Y = Phi * X;

            % OMP MMV solver instance (using P = 2 for P-SOMP)
            omp_solver = spx.pursuit.joint.OrthogonalMatchingPursuit(Phi, K, 2);
            % Solve the sparse recovery problem
            result = omp_solver.solve(Y);
            % Solution vectors
            X_OMP = result.Z;
            % Comparison
            cs = spx.commons.SparseSignalsComparison(X, X_OMP, K);
            snr = cs.cum_signal_to_noise_ratio;
            omp_success = snr > snr_threshold;
            num_omp_successes = num_omp_successes + omp_success;
            fprintf('S: %d, K=%d, trial=%d, residual omp: %e, SNR: %f dB\n'...
                , S, K, nt, cs.cum_difference_norm, snr);
        end
        omp_success_with_k(ns, nk) = num_omp_successes / num_trials;
    end
end


save ('bin/figure_2_dirac_fourier_dict_model_3_somp_success_with_k.mat');

