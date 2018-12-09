clear all;
close all;
clc;
rng default;

% Ambient space dimension
M = 50;
% Number of subspaces
K = 10;
% common dimension for each subspace
D = 10;

% Construct bases for random subspaces
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, D);

% Number of points on each subspace
Sk = 4 * D;

cluster_sizes = Sk * ones(1, K);
% total number of points
S = sum(cluster_sizes);

points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
X0 = points_result.X;

% noise level
sigma = 0.5;
% Generate noise
Noise = sigma * spx.data.synthetic.uniform(M, S);
% Add noise to signal
X = X0 + Noise;
% Normalize noisy signals.
X = spx.norm.normalize_l2(X); 
% labels assigned to the data points
true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);

rng('default');
tstart = tic;
fprintf('Performing SSC OMP\n');
import spx.cluster.ssc.OMP_REPR_METHOD;
solver = spx.cluster.ssc.SSC_OMP(X, D, K, 1e-3, OMP_REPR_METHOD.FLIPPED_OMP_MATLAB);
solver.Quiet = true;
clustering_result = solver.solve();
elapsed_time = toc (tstart);
fprintf('Time taken in SSC-OMP %.2f seconds\n', elapsed_time);

% Time to compare the clustering
cluster_labels = clustering_result.labels;
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;

spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;
fprintf('\nclustering error: %0.2f %%, clustering accuracy: %0.2f %% \n'...
    , clustering_error_perc, clustering_acc_perc);
fprintf('mean spr error: %0.2f, preserving : %0.2f %%\n', spr_stats.spr_error, spr_stats.spr_perc);
fprintf('elapsed time: %0.2f sec', elapsed_time);
fprintf('\n\n');
