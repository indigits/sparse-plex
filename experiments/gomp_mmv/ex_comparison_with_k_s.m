close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

% Signal space 
N = 1000;
% Number of measurements
M = 200;
% Sparsity levels
Ks =2:4:100;
% Number of signals
Ss = [1 4 6 8];
% Number of dictionaries to be created
num_dict_trials = 100;
% Number of signals to be created for each dictionary
num_signal_trials = 5;

% Number of trials for each K
num_trials = num_dict_trials * num_signal_trials;


num_ks = numel(Ks);
num_ss = length(Ss);

% statistics for OMP-MMV
success_rates.omp_mmv = zeros(num_ks, num_ss);
average_iterations.omp_mmv = zeros(num_ks, num_ss);
% statistics for Rank Aware OMP
success_rates.ra_omp = zeros(num_ks, num_ss);
average_iterations.ra_omp = zeros(num_ks, num_ss);
% statistics for Rank Aware ORMP
success_rates.ra_ormp = zeros(num_ks, num_ss);
average_iterations.ra_ormp = zeros(num_ks, num_ss);
% statistics for GOMP with L=2
success_rates.gomp_2_mmv = zeros(num_ks, num_ss);
average_iterations.gomp_2_mmv = zeros(num_ks, num_ss);
% statistics for GOMP with L=4
success_rates.gomp_4_mmv = zeros(num_ks, num_ss);
average_iterations.gomp_4_mmv = zeros(num_ks, num_ss);

Ls = [2, 4];
num_ls = numel(Ls);


snr_threshold = 100;

for ns=1:num_ss
    % Current number of signals
    S = Ss(ns);

    for nk=1:num_ks
        K = Ks(nk);
        % Trial number
        nt = 0;

        num_successes.omp_mmv = 0;
        num_successes.ra_omp = 0;
        num_successes.ra_ormp = 0;
        num_successes.gomp_2_mmv = 0;
        num_successes.gomp_4_mmv = 0;

        num_iterations.omp_mmv = 0;
        num_iterations.ra_omp = 0;
        num_iterations.ra_ormp = 0;
        num_iterations.gomp_2_mmv = 0;
        num_iterations.gomp_4_mmv = 0;

        for ndt=1:num_dict_trials
            % Sensing matrix
            Phi = spx.dict.simple.gaussian_dict(M, N);
            for nst=1:num_signal_trials
                nt = nt + 1;
                % Construct the signal generator.
                gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
                % Gaussian distributed non-zero samples
                X = gen.gaussian;
                % Measurement vectors
                Y = Phi.apply(X);


                % Create the solver for simultaneous orthogonal matching pursuit
                solver = spx.pursuit.joint.OrthogonalMatchingPursuit(Phi, K, 2);
                result = solver.solve(Y);
                % Solution vectors
                X_Rec = result.Z;
                % Comparison
                cs = spx.commons.SparseSignalsComparison(X, X_Rec, K);
                % Reconstruction SNR
                snr = cs.cum_signal_to_noise_ratio;
                success = snr > snr_threshold;
                num_successes.omp_mmv = num_successes.omp_mmv + success;
                num_iterations.omp_mmv = num_iterations.omp_mmv + result.iterations;


                % Create the solver for rank aware orthogonal matching pursuit
                solver = spx.pursuit.joint.RankAwareOMP(Phi, K);
                result = solver.solve(Y);
                % Solution vectors
                X_Rec = result.Z;
                % Comparison
                cs = spx.commons.SparseSignalsComparison(X, X_Rec, K);
                % Reconstruction SNR
                snr = cs.cum_signal_to_noise_ratio;
                success = snr > snr_threshold;
                num_successes.ra_omp = num_successes.ra_omp + success;
                num_iterations.ra_omp = num_iterations.ra_omp + result.iterations;

                % Create the solver for rank aware order recursive matching pursuit
                solver = spx.pursuit.joint.RankAwareORMP(Phi, K);
                result = solver.solve(Y);
                % Solution vectors
                X_Rec = result.Z;
                % Comparison
                cs = spx.commons.SparseSignalsComparison(X, X_Rec, K);
                % Reconstruction SNR
                snr = cs.cum_signal_to_noise_ratio;
                success = snr > snr_threshold;
                num_successes.ra_ormp = num_successes.ra_ormp + success;
                num_iterations.ra_ormp = num_iterations.ra_ormp + result.iterations;

                % Create the solver for Generalized OMP MMV with L=2
                solver = spx.pursuit.joint.GOMP(Phi, K, 2);
                solver.L = 2;
                result = solver.solve(Y);
                % Solution vectors
                X_Rec = result.Z;
                % Comparison
                cs = spx.commons.SparseSignalsComparison(X, X_Rec, K);
                % Reconstruction SNR
                snr = cs.cum_signal_to_noise_ratio;
                success = snr > snr_threshold;
                num_successes.gomp_2_mmv = num_successes.gomp_2_mmv + success;
                num_iterations.gomp_2_mmv = num_iterations.gomp_2_mmv + result.iterations;

                % Create the solver for Generalized OMP MMV with L=4
                solver = spx.pursuit.joint.GOMP(Phi, K, 2);
                solver.L = 4;
                result = solver.solve(Y);
                % Solution vectors
                X_Rec = result.Z;
                % Comparison
                cs = spx.commons.SparseSignalsComparison(X, X_Rec, K);
                % Reconstruction SNR
                snr = cs.cum_signal_to_noise_ratio;
                success = snr > snr_threshold;
                num_successes.gomp_4_mmv = num_successes.gomp_4_mmv + success;
                num_iterations.gomp_4_mmv = num_iterations.gomp_4_mmv + result.iterations;


                fprintf('S: %d, K=%d, trial=%d\n', S, K, nt);
            end
        end
        success_rates.omp_mmv(nk, ns) = num_successes.omp_mmv / num_trials;
        success_rates.ra_omp(nk, ns) = num_successes.ra_omp / num_trials;
        success_rates.ra_ormp(nk, ns) = num_successes.ra_ormp / num_trials;
        success_rates.gomp_2_mmv(nk, ns) = num_successes.gomp_2_mmv / num_trials;
        success_rates.gomp_4_mmv(nk, ns) = num_successes.gomp_4_mmv / num_trials;


        average_iterations.omp_mmv(nk, ns) = num_iterations.omp_mmv / num_trials;
        average_iterations.ra_omp(nk, ns) = num_iterations.ra_omp / num_trials;
        average_iterations.ra_ormp(nk, ns) = num_iterations.ra_ormp / num_trials;
        average_iterations.gomp_2_mmv(nk, ns) = num_iterations.gomp_2_mmv / num_trials;
        average_iterations.gomp_4_mmv(nk, ns) = num_iterations.gomp_4_mmv / num_trials;
    end
end
filename  = sprintf('bin/comparison_with_k_s_with_N=%d_M=%d.mat', N, M);
save(filename);

