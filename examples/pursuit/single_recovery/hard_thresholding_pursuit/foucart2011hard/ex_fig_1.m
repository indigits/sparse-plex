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
Ks = 1:120;

% Number of dictionaries to be created
num_dict_trials = 100;
% Number of signals to be created for each dictionary
num_signal_trials = 5;

% Number of trials for each K
num_trials = num_dict_trials * num_signal_trials;

nhtp_success_rates_with_k = zeros(numel(Ks), 1);
nhtp_average_iterations_with_k = zeros(numel(Ks), 1);
nhtp_maximum_iterations_with_k = zeros(numel(Ks), 1);


csmp_success_rates_with_k = zeros(numel(Ks), 1);
csmp_average_iterations_with_k = zeros(numel(Ks), 1);
csmp_maximum_iterations_with_k = zeros(numel(Ks), 1);

for K=Ks
    % Trial number
    nt = 0;
    nhtp_num_successes = 0;
    nhtp_num_iterations = 0;
    nhtp_max_iterations = 0;

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


            % Hard thresholding pursuit solver instance
            solver = spx.pursuit.single.HardThresholdingPursuit(Phi, K);
            solver.NormalizedMode = true;
            % Solve the sparse recovery problem
            nhtp_result = solver.solve(y);
            % Solution vector
            z = nhtp_result.z;
            nhtp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
            nhtp_num_iterations = nhtp_num_iterations + nhtp_result.iterations;
            if nhtp_max_iterations < nhtp_result.iterations
                nhtp_max_iterations = nhtp_result.iterations;
            end
            nhtp_num_successes = nhtp_num_successes + nhtp_stats.success;


            % CoSaMP solver instance
            solver = spx.pursuit.single.CoSaMP(Phi, K);
            % Solve the sparse recovery problem
            csmp_result = solver.solve(y);
            % Solution vector
            z = csmp_result.z;
            csmp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
            csmp_num_iterations = csmp_num_iterations + csmp_result.iterations;
            if csmp_max_iterations < csmp_result.iterations
                csmp_max_iterations = csmp_result.iterations;
            end
            csmp_num_successes = csmp_num_successes + csmp_stats.success;


            fprintf('K=%d, Trial: %d, NHTP: %s, CSMP: %s\n', ...
                K, nt, spx.io.true_false_short(nhtp_stats.success), ...
                spx.io.true_false_short(csmp_stats.success));
        end
    end
    nhtp_success_rate = nhtp_num_successes / num_trials;
    nhtp_average_iterations = nhtp_num_iterations / num_trials;
    nhtp_success_rates_with_k(K) = nhtp_success_rate;
    nhtp_average_iterations_with_k (K) = nhtp_average_iterations;
    nhtp_maximum_iterations_with_k(K) = nhtp_max_iterations;

    csmp_success_rate = csmp_num_successes / num_trials;
    csmp_average_iterations = csmp_num_iterations / num_trials;
    csmp_success_rates_with_k(K) = csmp_success_rate;
    csmp_average_iterations_with_k (K) = csmp_average_iterations;
    csmp_maximum_iterations_with_k(K) = csmp_max_iterations;
end

save('bin/fig_1.mat');
