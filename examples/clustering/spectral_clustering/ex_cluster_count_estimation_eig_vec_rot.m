% Demonstrates how number of clusters are estimated using eigen vector rotations
clear('all');
close all;
clc; 
rng('default');

points_per_set = 100;
% number of clusters
num_clusters = 5;
% points 
points = [];
gap = 2;
true_labels = zeros(points_per_set*num_clusters, 1);
fprintf('Creating data points\n');
for c=1:num_clusters
    mean_val = c * gap;
    % values random between 0 and 1
    point_set = rand(1, points_per_set);
    % shift between -gap / 4 and  gap / 4
    point_set = point_set * gap / 2 - gap/4;
    % then move to mean
    point_set = point_set + mean_val;
    % add to the list of all points
    points = [points point_set];
    true_labels((c - 1)*points_per_set + (1:points_per_set)) = c;
end
fprintf('Computing distance matrix\n');
% prepare the distance matrix
sqrt_dist_mat = spx.commons.distance.sqrd_l2_distances_cw(points);
fprintf('Computing similarity matrix\n');
% prepare the Gaussian similarity matrix
% Eigen values have a large impact based on the choice of sigma
% The lower variance, the closure first num_clusters are to zero.
% At high variance like sigma=2.5, we completely lose out on clustering accuracy 
sigma = .5;
sim_matrix = SPX_Similarity.gauss_sim_from_sqrd_dist_mat(sqrt_dist_mat, sigma);
% lets see the impact of filtering the similarity matrix
% sim_matrix = SPX_Similarity.filter_k_nearest_neighbors(sim_matrix, points_per_set*1.5);

% We can now run spectral clustering on it
clusterer = spx.cluster.spectral.Clustering(sim_matrix);
cluster_labels = clusterer.cluster_random_walk();
combined_labels = [true_labels cluster_labels]';
% We can print the singular values if required.
singular_values = clusterer.SingularValues';
% Time to compare the clustering
comparer = spx.cluster.ClusterComparison(true_labels, cluster_labels);
result = comparer.fMeasure();
fprintf('Clustering F-measure: %.2f\n', result.fMeasure);

if 0
vr = SPX_SCEigVecRot(clusterer.EigenVectors, clusterer.SingularValues);
vr.MaxClusters = num_clusters * 2;
c = 4;
K = c * (c - 1) / 2;
thetas = randsample([30, 45, 60], K, 1)
thetas2 = deg2rad(thetas);
vr.estimate_clusters();
end



