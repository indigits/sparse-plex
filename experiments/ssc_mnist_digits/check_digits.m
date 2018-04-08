function final_result = check_digits(md, num_samples_per_digit, solver, solver_name, solver_params)

if nargin < 5
    solver_params = struct;
end

% Create the directory for storing results
spx.fs.ensure_dir('bin');

R = 20;
fprintf('Number of trials: %d\n', R);

% We will carry out one experiment for each signal density level
test_result.failed_examples = [];
trials = cell(1, R);

for r=1:R
    trial = struct();

    digit_set = 0:9;
    K = length(digit_set);
    % Number of subspaces
    trial.K = K;
    cluster_sizes = num_samples_per_digit*ones(1, K);
    trial.cluster_sizes = cluster_sizes;
    % maximum dimension for each subspace
    D = 10;
    trial.D = D;
    S = sum(cluster_sizes);
    trial.S = S;
    % identify sample indices for each digit
    sample_list = [];
    for k=1:K
        digit = digit_set(k);
        digit_indices = md.digit_indices(digit);
        num_digit_samples = length(digit_indices);
        % initialize the random number generator for repeatability
        rng( (r-1) * K + k);
        choices = randperm(num_digit_samples, cluster_sizes(k));
        selected_indices = digit_indices(choices);
        % fprintf('%d ', selected_indices);
        % fprintf('\n');
        sample_list = [sample_list selected_indices];
    end
    [Y, true_labels] = md.selected_samples(sample_list);
    % disp(Y(1:10, 1)');
    % Perform PCA to reduce dimensionality
    Y = spx.la.pca.low_rank_approx(Y, 100);
    %spx.norm.norms_l2_cw(Y)
    % disp(Y(1:10, 1)');
    % Ambient space dimension and number of data points
    [trial.M, trial.S] = size(Y);
    % Solve the sparse subspace clustering problem
    tstart = tic;
    try
        clustering_result = solver(Y, trial.D, trial.K, solver_params);
        % disp(clustering_result.Z(:, 1));
    catch ME
        % we will move on to next one
        fprintf('Problem in processing this example. %s: %s\n', ME.identifier, ME.message);
        % add to the list of failed examples
        test_result.failed_examples = [test_result.failed_examples r];
        % move on to next example
        continue;
    end
    trial.elapsed_time = toc (tstart);
    % graph connectivity
    trial.connectivity = clustering_result.connectivity;
    % estimated number of clusters
    trial.estimated_num_subspaces = clustering_result.num_clusters;
    % Time to compare the clustering
    cluster_labels = clustering_result.labels;
    comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, trial.K);
    trial.clustering_error_perc = comparsion_result.error_perc;
    trial.clustering_acc_perc = 100 - comparsion_result.error_perc;
    % Compute the statistics related to subspace preservation
    spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, trial.cluster_sizes);
    trial.spr_error = spr_stats.spr_error;
    trial.spr_flag = spr_stats.spr_flag;
    trial.spr_perc = spr_stats.spr_perc;
    fprintf('\ntrial: %d, clustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.4f preserving : %0.2f %%\n, connectivity: %0.2f, elapsed time: %0.2f sec', r,trial.clustering_error_perc, trial.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.connectivity, trial.elapsed_time);
    fprintf('\n\n');
    trials{r} = trial;
end
% clear some variables no more required.
clear trial;
clear clustering_result;
clear comparison_result;
%  save rest of variables in file.
filepath = sprintf('bin/mnist_%d_points_test_%s.mat', num_samples_per_digit, solver_name);
save(filepath, 'trials');
final_result = merge_results(num_samples_per_digit, solver_name);
end
