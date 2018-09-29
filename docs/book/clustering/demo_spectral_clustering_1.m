close all;
clearvars;
clc;
dataset_file = fullfile(spx.data_dir, 'clustering', ...
    'self_tuning_paper_clustering_data');
data = load(dataset_file);
datasets = data.XX;
raw_data = datasets{1};
num_clusters = data.group_num(1);
X = raw_data(:, 1);
Y = raw_data(:, 2);
figure;
axis equal;
plot(X, Y, '.', 'MarkerSize',16);
export_fig images/demo_sc_1_unscaled.png -r120 -nocrop;
% Scale the raw_data
raw_data = raw_data - repmat(mean(raw_data),size(raw_data,1),1);
raw_data = raw_data/max(max(abs(raw_data)));
X = raw_data(:, 1);
Y = raw_data(:, 2);
figure;
axis equal;
plot(X, Y, '.', 'MarkerSize',16);
export_fig images/demo_sc_1_scaled.png -r120 -nocrop;

% Compute the distance matrix
sqrt_dist_mat = spx.commons.distance.sqrd_l2_distances_rw(raw_data);
%% Scale to use for standard spectral clustering
scale = 0.04;
% Compute the similarity matrix
sim_mat = spx.cluster.similarity.gauss_sim_from_sqrd_dist_mat(sqrt_dist_mat, scale);
% Run clustering on the dataset
clusterer = spx.cluster.spectral.Clustering(sim_mat);
clusterer.NumClusters = num_clusters;
%cluster_labels = clusterer.cluster_symmetric();
cluster_labels = clusterer.cluster_random_walk();
figure;
colors = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0];
hold on;
axis equal;
for c=1:num_clusters
    % Identify points in this cluster
    points = raw_data(cluster_labels == c, :);
    X = points(:, 1);
    Y = points(:, 2);
    plot(X, Y, '.','Color',colors(c,:), 'MarkerSize',16);
end
export_fig images/demo_sc_1_clustered.png -r120 -nocrop;
