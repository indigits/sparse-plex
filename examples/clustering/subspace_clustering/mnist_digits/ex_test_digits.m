close all;
clc;

num_samples_per_digit = 10;
rng('default');
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
% experiment number
r = 1;
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
% Perform PCA to reduce dimensionality
Y = spx.la.pca.low_rank_approx(Y, 100);
Yn = spx.commons.norm.normalize_l2(Y);
if true 
    fprintf('\n\n\n Point Statistics:\n\n');
    [M, S]  = size(Yn);
    angle_result = spx.cluster.subspace.nearest_same_subspace_neighbors_by_inner_product(Yn, cluster_sizes);
    spx.cluster.subspace.print_nearest_neighbor_result(angle_result);
end

if false
    mf = spx.graphics.Figures;
    % Ambient space dimension and number of data points
    [trial.M, trial.S] = size(Y);
    % Number of subspaces
    trial.K = num_samples_per_digit;
    % maximum dimension for each subspace
    trial.D = 5;
    trial.cluster_sizes = cluster_sizes;
    % Solve the sparse subspace clustering problem
    tstart = tic;
    try
        clustering_result = solver(Y, trial.D, trial.K);
    catch ME
        % we will move on to next one
        fprintf('Problem in processing this example. %s: %s\n', ME.identifier, ME.message);
        % move on to next example
        rethrow(ME);
        error('cannot continue.');
    end
    trial.elapsed_time = toc (tstart);
    % graph connectivity
    trial.connectivity = clustering_result.connectivity;
    % estimated number of clusters
    trial.estimated_num_subspaces = clustering_result.num_clusters;
    % Time to compare the clustering
    cluster_labels = clustering_result.labels;
    comparison_result = spx.cluster.clustering_error(cluster_labels, true_labels, trial.K);
    trial.clustering_error_perc = comparison_result.error_perc;
    trial.clustering_acc_perc = 100 - comparison_result.error_perc;
    % Compute the statistics related to subspace preservation
    spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, trial.cluster_sizes);
    trial.spr_error = spr_stats.spr_error;
    trial.spr_flag = spr_stats.spr_flag;
    trial.spr_perc = spr_stats.spr_perc;
    fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%, mean spr error: %0.2f preserving : %0.2f %%, connectivity: %0.2f, elapsed time: %0.2f sec', trial.clustering_error_perc, trial.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.connectivity, trial.elapsed_time);
    fprintf('\n\n');
    Z = full(abs(clustering_result.Z));
    s = spx.stats.format_descriptive_statistics(Z(:));
    fprintf(s);
    fprintf('\n');
    fprintf('Missed points: \n');
    fprintf('%d ', find(comparison_result.misses));
    fprintf('\n');
    mf.new_figure('Representations');
    imshow(Z);
end