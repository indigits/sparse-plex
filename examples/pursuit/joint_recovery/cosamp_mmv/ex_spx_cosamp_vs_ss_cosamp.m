% This script compares the performance of CoSaMP implementation in sparse-plex
% library with the cosamp implementation in SSCOSAMP package.

close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

% Signal space 
N = 500;
% Number of measurements
M = 100;
% Sparsity levels
% Ks = 1:60;
Ks = 1:35;

% Number of dictionaries to be created
num_dict_trials = 5;
% Number of signals to be created for each dictionary
num_signal_trials = 5;

% Number of trials for each K
num_trials = num_dict_trials * num_signal_trials;

sscosamp_success_rates_with_k = zeros(numel(Ks), 1);
sscosamp_average_iterations_with_k = zeros(numel(Ks), 1);
sscosamp_maximum_iterations_with_k = zeros(numel(Ks), 1);


csmp_success_rates_with_k = zeros(numel(Ks), 1);
csmp_average_iterations_with_k = zeros(numel(Ks), 1);
csmp_maximum_iterations_with_k = zeros(numel(Ks), 1);

for K=Ks
    % Trial number
    nt = 0;
    sscosamp_num_successes = 0;
    sscosamp_num_iterations = 0;
    sscosamp_max_iterations = 0;

    csmp_num_successes = 0;
    csmp_num_iterations = 0;
    csmp_max_iterations = 0;

    for ndt=1:num_dict_trials
        % Sensing matrix
        Phi = spx.dict.simple.gaussian_dict(M, N);
        for nst=1:num_signal_trials
            nt = nt + 1;
            % Construct the signal generator.
            gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
            % Generate bi-uniform signals
            x = gen.gaussian;
            % Measurement vectors
            y = Phi.apply(x);


            % sscosamp solver
            singleMatrixOpts = struct;
            [z supp iters] = singleMatrixCoSaMP(y, Phi.A, K, singleMatrixOpts);
            sscosamp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
            sscosamp_num_iterations = sscosamp_num_iterations + iters;
            if sscosamp_max_iterations < iters
                sscosamp_max_iterations = iters;
            end
            sscosamp_num_successes = sscosamp_num_successes + sscosamp_stats.success;


            % CoSaMP solver instance
            solver = spx.pursuit.single.CoSaMP_MMV(Phi, K);
            % Solve the sparse recovery problem
            csmp_result = solver.solve(y);
            % Solution vector
            z = csmp_result.Z;
            csmp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
            csmp_num_iterations = csmp_num_iterations + csmp_result.iterations;
            if csmp_max_iterations < csmp_result.iterations
                csmp_max_iterations = csmp_result.iterations;
            end
            csmp_num_successes = csmp_num_successes + csmp_stats.success;


            fprintf('K=%d, Trial: %d, SSCOSAMP: %s, CSMP: %s\n', ...
                K, nt, SPX.true_false_short(sscosamp_stats.success), ...
                SPX.true_false_short(csmp_stats.success));
        end
    end
    sscosamp_success_rate = sscosamp_num_successes / num_trials;
    sscosamp_average_iterations = sscosamp_num_iterations / num_trials;
    sscosamp_success_rates_with_k(K) = sscosamp_success_rate;
    sscosamp_average_iterations_with_k (K) = sscosamp_average_iterations;
    sscosamp_maximum_iterations_with_k(K) = sscosamp_max_iterations;

    csmp_success_rate = csmp_num_successes / num_trials;
    csmp_average_iterations = csmp_num_iterations / num_trials;
    csmp_success_rates_with_k(K) = csmp_success_rate;
    csmp_average_iterations_with_k (K) = csmp_average_iterations;
    csmp_maximum_iterations_with_k(K) = csmp_max_iterations;
end

save('bin/sscosamp_vs_spx_cosamp.mat');
