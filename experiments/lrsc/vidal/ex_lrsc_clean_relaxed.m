clc;
clearvars;
close all;
rng default;

% Ambient space dimension
M = 4000;
% Number of subspaces
K = 4;
% common dimension for each subspace
D = 10;
% dimensions of each subspace
Ds = D * ones(1, K);
fprintf('Generating synthetic data.\n');
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, Ds);
% Number of points on each subspace
Sk = 16 * D;
cluster_sizes = Sk * ones(1, K);
% total number of points
S = sum(cluster_sizes);
% Let us generate uniformly distributed points in each subspace
points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
X = points_result.X;
start_indices = points_result.start_indices;
end_indices = points_result.end_indices;
% Normalize noisy signals.
X = spx.norm.normalize_l2(X); 
% true labels for each of the data samples
true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
fprintf('Size of the data matrix: %d x %d\n', M, S);
fprintf('Computing Low Rank Subspace Clustering\n');
tstart = tic;
% Apply low rank subspace clustering
C = lrsc_noiseless(X);
elapsed_time = toc(tstart);
t1 = elapsed_time;
fprintf('Vidal version Time taken: %.2f seconds\n', elapsed_time);

tstart = tic;
% Apply low rank subspace clustering
C2 = spx.cluster.lrsc.clean_relaxed(X);
elapsed_time = toc(tstart);
t2  = elapsed_time;
fprintf('SPX Version Time taken: %.2f seconds\n', elapsed_time);

fprintf('Gain %.2f x\n', t1/t2);

fprintf('Max diff between two versions: %.4f\n', ...
    max(max(abs(C - C2))));

fprintf('Performing clustering: \n');
tstart = tic;
% Adjacency matrix
W = abs(C2);
clustering_result = spx.cluster.spectral.simple.normalized_symmetric_sparse(W, K);
%clustering_result = spx.cluster.spectral.simple.normalized_symmetric_fast(W, K);
cluster_labels = clustering_result.labels;
elapsed_time = toc(tstart);
fprintf('Time taken: %.2f seconds \n', elapsed_time);
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;

fprintf('\nclustering error: %0.2f %%, clustering accuracy: %0.2f %% \n'...
    , clustering_error_perc, clustering_acc_perc);

spr_stats = spx.cluster.subspace.subspace_preservation_stats(abs(C), cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;

fprintf('mean spr error: %0.2f, preserving : %0.2f %%\n', spr_stats.spr_error, spr_stats.spr_perc);

