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
Ks = 4:120;

% Number of dictionaries to be created
num_dict_trials = 100;
% Number of signals to be created for each dictionary
num_signal_trials = 5;

% Number of trials for each K
num_trials = num_dict_trials * num_signal_trials;

omp_success_rates_with_k = zeros(numel(Ks), 1);
omp_average_iterations_with_k = zeros(numel(Ks), 1);
omp_maximum_iterations_with_k = zeros(numel(Ks), 1);


mcomp_success_rates_with_k = zeros(numel(Ks), 1);
mcomp_average_iterations_with_k = zeros(numel(Ks), 1);
mcomp_maximum_iterations_with_k = zeros(numel(Ks), 1);

for K=Ks
    % Trial number
    nt = 0;
    omp_num_successes = 0;
    omp_num_iterations = 0;
    omp_max_iterations = 0;

    mcomp_num_successes = 0;
    mcomp_num_iterations = 0;
    mcomp_max_iterations = 0;

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


            % OMP solver instance
            solver = spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K);
            % Solve the sparse recovery problem
            omp_result = solver.solve(y);
            % Solution vector
            z = omp_result.z;
            omp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
            omp_num_iterations = omp_num_iterations + omp_result.iterations;
            if omp_max_iterations < omp_result.iterations
                omp_max_iterations = omp_result.iterations;
            end
            omp_num_successes = omp_num_successes + omp_stats.success;


            % MC-OMP solver instance
            solver = spx.pursuit.single.MC_OMP(Phi, K);
            % Solve the sparse recovery problem
            mcomp_result = solver.solve(y);
            % Solution vector
            z = mcomp_result.z;
            mcomp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
            mcomp_num_iterations = mcomp_num_iterations + mcomp_result.iterations;
            if mcomp_max_iterations < mcomp_result.iterations
                mcomp_max_iterations = mcomp_result.iterations;
            end
            mcomp_num_successes = mcomp_num_successes + mcomp_stats.success;


            fprintf('K=%d, Trial: %d, OMP: %s, MC-OMP: %s\n', ...
                K, nt, spx.io.true_false_short(omp_stats.success), ...
                spx.io.true_false_short(mcomp_stats.success));
        end
    end
    omp_success_rate = omp_num_successes / num_trials;
    omp_average_iterations = omp_num_iterations / num_trials;
    omp_success_rates_with_k(K) = omp_success_rate;
    omp_average_iterations_with_k (K) = omp_average_iterations;
    omp_maximum_iterations_with_k(K) = omp_max_iterations;

    mcomp_success_rate = mcomp_num_successes / num_trials;
    mcomp_average_iterations = mcomp_num_iterations / num_trials;
    mcomp_success_rates_with_k(K) = mcomp_success_rate;
    mcomp_average_iterations_with_k (K) = mcomp_average_iterations;
    mcomp_maximum_iterations_with_k(K) = mcomp_max_iterations;
end

save('bin/omp_vs_mc_omp_comparison.mat');
