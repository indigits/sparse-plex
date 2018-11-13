clc;
close all;
% initialize the random number generator for repeatability
rng('default');
digit_set = 0:9;
fprintf('Digit set: ');
spx.io.print.vector(digit_set, 0);
num_samples_per_digit = 200;
K = length(digit_set);
fprintf('Selecting data subset\n');
cluster_sizes = num_samples_per_digit*ones(1, K);
D = 10;
fprintf('Number of digits / clusters: %d\n', K);
fprintf('Dimension for the subspace spanned by features for each digit: %d\n', D);
fprintf('Number of samples per digit/cluster: %d\n', num_samples_per_digit);
sample_list = [];
for k=1:K
    digit = digit_set(k);
    digit_indices = md.digit_indices(digit);
    num_digit_samples = length(digit_indices);
    choices = randperm(num_digit_samples, cluster_sizes(k));
    selected_indices = digit_indices(choices);
    sample_list = [sample_list selected_indices];
end
[Y, true_labels] = md.selected_samples(sample_list);
% Perform PCA to reduce dimensionality
fprintf('Performing PCA\n');
tstart = tic;
Y = spx.la.pca.low_rank_approx(Y, 500);
elapsed_time = toc (tstart);
fprintf('Time taken in PCA %.2f seconds\n', elapsed_time);
[M, S] = size(Y);
rng('default');
tstart = tic;
fprintf('Performing SSC OMP\n');
import spx.cluster.ssc.OMP_REPR_METHOD;
solver = spx.cluster.ssc.SSC_OMP(Y, D, K, 1e-3, OMP_REPR_METHOD.BATCH_FLIPPED_OMP_C);
solver.Quiet = true;
clustering_result = solver.solve();
elapsed_time = toc (tstart);
fprintf('Time taken in SSC-OMP %.2f seconds\n', elapsed_time);
% graph connectivity
connectivity = clustering_result.connectivity;
% estimated number of clusters
estimated_num_subspaces = clustering_result.num_clusters;
% Time to compare the clustering
cluster_labels = clustering_result.labels;
fprintf('Measuring clustering error and accuracy\n');
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;
spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;
fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.4f preserving : %0.2f %%\n, connectivity: %0.2f, elapsed time: %0.2f sec',...
    clustering_error_perc, clustering_acc_perc,...
    spr_stats.spr_error, spr_stats.spr_perc,...
    connectivity, elapsed_time);
fprintf('\n\n');
