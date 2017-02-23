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
Ks = 4:2:80;
num_ks = numel(Ks);

% Number of dictionaries to be created
num_dict_trials = 50;
% Number of signals to be created for each dictionary
num_signal_trials = 5;

% Number of trials for each K
num_trials = num_dict_trials * num_signal_trials;

omp_success_rates_with_k = zeros(num_ks, 1);



omp_ar_success_rates_with_k = zeros(num_ks, 1);
omp_ar_average_matches_with_k = zeros(num_ks, 1);

sample_no = 1;

for nk=1:num_ks
    K = Ks(nk);
    % Trial number
    nt = 0;
    omp_num_successes = 0;

    omp_ar_num_successes = 0;
    omp_ar_average_matches = 0;

    for ndt=1:num_dict_trials
        % Sensing matrix
        Phi = spx.dict.simple.gaussian_dict(M, N);
        for nst=1:num_signal_trials
            nt = nt + 1;
            % Construct the signal generator.
            gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
            % Generate bi-uniform signals
            x = gen.biGaussian;
            % Measurement vectors
            y = Phi.apply(x);


            % OMP solver instance
            solver = spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K);
            % Solve the sparse recovery problem
            omp_result = solver.solve(y);
            % Solution vector
            z = omp_result.z;
            omp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
            omp_num_successes = omp_num_successes + omp_stats.success;


            % OMP-AR solver instance
            % Solve the sparse recovery problem
            matching_mode = 4;
            options.norm_factor = 2;
            options.reset_interval = 4;
            PhiMtx = double(Phi);
            omp_ar_result = ar_omp(PhiMtx, K, y, matching_mode, options);
            % Solution vector
            z = omp_ar_result.z;
            omp_ar_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
            omp_ar_average_matches = omp_ar_average_matches + omp_ar_result.avg_matched_atoms_count;
            omp_ar_num_successes = omp_ar_num_successes + omp_ar_stats.success;


            fprintf('K=%d, Trial: %d, OMP: %s, OMP-AR: %s, Combined: %s\n', ...
                K, nt, spx.io.true_false_short(omp_stats.success), ...
                spx.io.true_false_short(omp_ar_stats.success), ...
                spx.io.tf_pair(omp_stats.success, omp_ar_stats.success));
            if omp_stats.success && ~omp_ar_stats.success 
                if 1 
                    fname  = sprintf('sample_%d.mat', sample_no);
                    sample_no = sample_no + 1;
                    save(fname, 'PhiMtx', 'N', 'M', 'K', 'x', 'y', 'z');
                    pause;
                end
            end
        end
    end
    omp_success_rate = omp_num_successes / num_trials;
    omp_success_rates_with_k(nk) = omp_success_rate;

    omp_ar_success_rate = omp_ar_num_successes / num_trials;
    omp_ar_average_matches = omp_ar_average_matches / num_trials;
    omp_ar_success_rates_with_k(nk) = omp_ar_success_rate;
    omp_ar_average_matches_with_k(nk) = omp_ar_average_matches;
end

save('bin/omp_vs_omp_ar_comparison.mat');
