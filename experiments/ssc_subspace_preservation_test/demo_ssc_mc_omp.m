close all; clear all; clc;

rng default;
rho = 1880/6;
%rho = 320/6;
% Ambient space dimension
M = 9;
% Number of subspaces
K = 5;
% common dimension for each subspace
D = 6;
% dimensions of each subspace
Ds = D * ones(1, K);
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, Ds);
% Number of points on each subspace
Sk = rho * D;
cluster_sizes = Sk * ones(1, K);
% total number of points
S = sum(cluster_sizes);
fprintf('Points per subspace: %d, Total points: %d\n', Sk, S);
% Let us generate uniformly distributed points in each subspace
points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
X = points_result.X;
tic;
solver = spx.cluster.ssc.SSC_MC_OMP(X, D, K);
clustering_result = solver.solve();
elapsed_time = toc;
cluster_labels = clustering_result.labels;
true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
% Time to compare the clustering
comparsion_result = spx.cluster.clustering_error(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;
% Compute the statistics related to subspace preservation
spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;
fprintf('\nPoint density: %0.2f: , clustering error: %0.2f %% \n, clustering accuracy: %0.2f %%, mean spr error: %0.2f \npreserving : %0.2f %%, connectivity: %0.2f, \n elapsed time: %0.2f sec', rho, clustering_error_perc, clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, clustering_result.connectivity, elapsed_time);
fprintf('\n\n');
