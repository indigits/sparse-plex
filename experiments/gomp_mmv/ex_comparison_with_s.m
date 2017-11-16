% Studies the recovery probability of different algorithms
% at a fixed sparsity level and varying number of signals.

close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');
% Signal space 
N = 256;
% Number of measurements
M = 48;
% Number of signals
Ss = 1:32;
% Sparsity level
K = 16;
num_trials = 100;
num_ss = length(Ss);
success_with_s.somp = zeros(num_ss, 1);
success_with_s.ra_omp = zeros(num_ss, 1);
success_with_s.ra_ormp = zeros(num_ss, 1);
success_with_s.gomp_2_mmv = zeros(num_ss, 1);
success_with_s.gomp_4_mmv = zeros(num_ss, 1);


snr_threshold = 100;

for ns=1:num_ss
    % Current number of signals
    S = Ss(ns);
    num_successes.somp = 0;
    num_successes.ra_omp = 0;
    num_successes.ra_ormp = 0;
    num_successes.gomp_2_mmv = 0;
    num_successes.gomp_4_mmv = 0;
    for nt=1:num_trials
        % Sensing matrix
        Phi = spx.dict.simple.gaussian_dict(M, N);
        % Sparse signal generator
        gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
        % Gaussian distributed non-zero samples
        X = gen.gaussian;
        % Measurement vectors
        Y = Phi * X;
        

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
        num_successes.somp = num_successes.somp + success;

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

        fprintf('S: %d, K=%d, trial=%d\n', S, K, nt);
    end
    success_with_s.somp(ns) = num_successes.somp / num_trials;
    success_with_s.ra_omp(ns) = num_successes.ra_omp / num_trials;
    success_with_s.ra_ormp(ns) = num_successes.ra_ormp / num_trials;
    success_with_s.gomp_2_mmv(ns) = num_successes.gomp_2_mmv / num_trials;
    success_with_s.gomp_4_mmv(ns) = num_successes.gomp_4_mmv / num_trials;
end


save ('bin/success_with_s_comparison.mat');

