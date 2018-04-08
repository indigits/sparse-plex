clc;
close all;
% initialize the random number generator for repeatability
rng('shuffle');
digit_set = 0:9;
num_samples_per_digit = 400;
K = length(digit_set);
% Number of subspaces
K = K;
cluster_sizes = num_samples_per_digit*ones(1, K);
cluster_sizes = cluster_sizes;
% maximum dimension for each subspace
D = 10;
S = sum(cluster_sizes);
% identify sample indices for each digit
sample_list = [];
for k=1:K
    digit = digit_set(k);
    digit_indices = md.digit_indices(digit);
    num_digit_samples = length(digit_indices);
    choices = randperm(num_digit_samples, cluster_sizes(k));
    selected_indices = digit_indices(choices);
    % fprintf('%d ', selected_indices);
    % fprintf('\n');
    sample_list = [sample_list selected_indices];
end
[Y, true_labels] = md.selected_samples(sample_list);
% disp(Y(1:10, 1)');
% Perform PCA to reduce dimensionality
Y = spx.la.pca.low_rank_approx(Y, 500);
% Ambient space dimension and number of data points
[M, S] = size(Y);
Y = spx.norm.normalize_l2(Y);
% Solve the sparse subspace clustering problem
rng('default');
tstart = tic;
solver = spx.cluster.ssc.SSC_OMP(Y, D, K);
solver.Quiet = true;
clustering_result = solver.solve();
elapsed_time = toc (tstart);
% graph connectivity
connectivity = clustering_result.connectivity;
% estimated number of clusters
estimated_num_subspaces = clustering_result.num_clusters;
% Time to compare the clustering
cluster_labels = clustering_result.labels;
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;
% Compute the statistics related to subspace preservation
spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;
fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.4f preserving : %0.2f %%\n, connectivity: %0.2f, elapsed time: %0.2f sec',...
    clustering_error_perc, clustering_acc_perc,...
    spr_stats.spr_error, spr_stats.spr_perc,...
    connectivity, elapsed_time);
fprintf('\n\n');

Y2 = Y * solver.Representation;
max(spx.norm.norms_l2_cw(Y - Y2))


rng('default');
tstart = tic;
solver = spx.cluster.ssc.SSC_BATCH_OMP(Y, D, K);
solver.Quiet = true;
clustering_result = solver.solve();
elapsed_time = toc (tstart);
% graph connectivity
connectivity = clustering_result.connectivity;
% estimated number of clusters
estimated_num_subspaces = clustering_result.num_clusters;
% Time to compare the clustering
cluster_labels = clustering_result.labels;
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;
% Compute the statistics related to subspace preservation
spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;
fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.4f preserving : %0.2f %%\n, connectivity: %0.2f, elapsed time: %0.2f sec',...
    clustering_error_perc, clustering_acc_perc,...
    spr_stats.spr_error, spr_stats.spr_perc,...
    connectivity, elapsed_time);
fprintf('\n\n');

Y2 = Y * solver.Representation;
max(spx.norm.norms_l2_cw(Y - Y2))

