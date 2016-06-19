clear all;
close all;
clc;

% Ambient space dimension
M = 50;
% Number of subspaces
K = 10;
% common dimension for each subspace
D = 20;
% dimensions of each subspace
Ds = D * ones(1, K);
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, Ds);
angles = spx.la.spaces.smallest_angles_deg(bases);
fprintf('Angles between subspaces:\n');
disp(angles);
% Number of points on each subspace
Sk = 2 * D;
% Sk = 5;
Ss = Sk * ones(1, K);
% total number of points
S = sum(Ss);
% Let us generate uniformly distributed points in each subspace
points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, Ss);
X = points_result.X;
point_angles_result = spx.cluster.subspace.min_angles_within_between(X, Ss);
fprintf('Within minimum angles: \n');
spx.io.print.vector(point_angles_result.within_angles, 0);
fprintf('Between minimum angles: \n');
spx.io.print.vector(point_angles_result.between_angles, 0);
fprintf('Difference: \n');
spx.io.print.vector(point_angles_result.difference, 0);
bad_count = sum(point_angles_result.difference < 0);
fprintf('Misaligned points: %d, %.0f %%\n', bad_count, bad_count * 100/ S);
fprintf('\n');
start_indices = points_result.start_indices;
end_indices = points_result.end_indices;
% Solve the sparse subspace clustering problem
solver = spx.cluster.ssc.SSC_NN_OMP(X, D, K);
clustering_result = solver.solve();
cluster_labels = clustering_result.labels;
true_labels = spx.cluster.labels_from_cluster_sizes(Ss);
% Time to compare the clustering
comparer = spx.cluster.ClusterComparison(true_labels, cluster_labels);
comparsion_result = comparer.fMeasure();
fprintf('\nPoint per subspace: %d: , fMeasure: %0.2f  ', Sk, comparsion_result.fMeasure);
if clustering_result.num_clusters == K
    fprintf('Success\n');
else
    fprintf('Failure\n');
end
