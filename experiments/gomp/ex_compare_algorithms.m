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
num_signal_trials = 20;

% Number of trials for each K
num_trials = num_dict_trials * num_signal_trials;

omp_success_rates_with_k = zeros(numel(Ks), 1);
omp_average_iterations_with_k = zeros(numel(Ks), 1);
omp_maximum_iterations_with_k = zeros(numel(Ks), 1);

Ls = [2, 4, 6, 8]
num_ls = numel(Ls)
gomp_success_rates_with_k = zeros(numel(Ks), num_ls);
gomp_average_iterations_with_k = zeros(numel(Ks), num_ls);
gomp_maximum_iterations_with_k = zeros(numel(Ks), num_ls);

for K=Ks
    % Trial number
    nt = 0;
    omp_num_successes = 0;
    omp_num_iterations = 0;
    omp_max_iterations = 0;

    gomp_num_successes = zeros(num_ls, 1);
    gomp_num_iterations = zeros(num_ls, 1);
    gomp_max_iterations = zeros(num_ls, 1);

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
            fprintf('K=%d, Trial: %d, OMP: %s, ', ...
                K, nt, spx.io.true_false_short(omp_stats.success));
            for nl=1:num_ls
                L = Ls(nl);
                % GOMP solver instance
                solver = spx.pursuit.single.GOMP(Phi, K);
                % Set the number of atoms to be selected in each iteration
                solver.L = L;
                % Solve the sparse recovery problem
                gomp_result = solver.solve(y);
                % Solution vector
                z = gomp_result.z;
                gomp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
                gomp_num_iterations(nl) = gomp_num_iterations(nl) + gomp_result.iterations;
                if gomp_max_iterations(nl) < gomp_result.iterations
                    gomp_max_iterations(nl) = gomp_result.iterations;
                end
                gomp_num_successes(nl) = gomp_num_successes(nl) + gomp_stats.success;
                fprintf(' GOMP-%d:%s', ...
                    L, spx.io.true_false_short(gomp_stats.success));
            end
            fprintf('\n')
        end
    end
    omp_success_rate = omp_num_successes / num_trials;
    omp_average_iterations = omp_num_iterations / num_trials;
    omp_success_rates_with_k(K) = omp_success_rate;
    omp_average_iterations_with_k (K) = omp_average_iterations;
    omp_maximum_iterations_with_k(K) = omp_max_iterations;

    for nl=1:num_ls
        gomp_success_rate = gomp_num_successes(nl) / num_trials;
        gomp_average_iterations = gomp_num_iterations(nl) / num_trials;
        gomp_success_rates_with_k(K, nl) = gomp_success_rate;
        gomp_average_iterations_with_k (K, nl) = gomp_average_iterations;
        gomp_maximum_iterations_with_k(K, nl) = gomp_max_iterations(nl);
    end
end

save('bin/omp_vs_gomp_comparison.mat');
