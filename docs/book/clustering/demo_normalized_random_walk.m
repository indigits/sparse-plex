close all;
clearvars;
clc;
rng default;
dataset_file = fullfile(spx.data_dir, 'clustering', ...
    'self_tuning_paper_clustering_data');
data = load(dataset_file);
datasets = data.XX;
raw_data = datasets{3};
% Scale the raw_data
raw_data = raw_data - repmat(mean(raw_data),size(raw_data,1),1);
raw_data = raw_data/max(max(abs(raw_data)));
num_clusters = data.group_num(1);
X = raw_data(:, 1);
Y = raw_data(:, 2);

spx.graphics.figure.full_screen;
axis equal;
plot(X, Y, '.', 'MarkerSize',16);
saveas(gcf, 'images/st3_nrw_raw_data.png');

% Compute the distance matrix
sqrt_dist_mat = spx.commons.distance.sqrd_l2_distances_rw(raw_data);
spx.graphics.figure.full_screen;
imagesc(sqrt_dist_mat);
title('Distance Matrix');
colorbar;
saveas(gcf, 'images/st3_nrw_distances.png');

%% Scale to use for standard spectral clustering
scale = 0.04;
% Compute the similarity matrix
W = spx.cluster.similarity.gauss_sim_from_sqrd_dist_mat(sqrt_dist_mat, scale);


spx.graphics.figure.full_screen;
imagesc(W);
title('Similarity Matrix');
colorbar;
saveas(gcf, 'images/st3_nrw_similarity.png');

[num_nodes, ~] = size(W);
Degree = diag(sum(W));
DegreeInv = Degree^(-1);
Laplacian = speye(num_nodes) - DegreeInv * W;

spx.graphics.figure.full_screen;
imagesc(Laplacian);
title('Normalized Random Walk Laplacian');
colorbar;
saveas(gcf, 'images/st3_nrw_laplacian.png');


[~, S, V] = svd(Laplacian);
singular_values = diag(S);


spx.graphics.figure.full_screen;
plot(singular_values, 'b.-');
grid on;
title('Singular values of the Laplacian');
saveas(gcf, 'images/st3_nrw_singular_values.png');


sv_changes = diff( singular_values(1:end-1) );
spx.graphics.figure.full_screen;
plot(sv_changes, 'b.-');
grid on;
title('Changes in singular values');
% saveas(gcf, 'images/st3_nrw_singular_values.png');
saveas(gcf, 'images/st3_nrw_sv_changes.png');


[min_val , ind_min ] = min(sv_changes);
num_clusters = num_nodes - ind_min;
num_clusters = sum(singular_values < 1e-6);

% Choose the last num_clusters eigen vectors
Kernel = V(:,num_nodes-num_clusters+1:num_nodes);

% Maximum iteration for KMeans Algorithm
max_iterations = 1000; 
% Replication for KMeans Algorithm
replicates = 100;
cluster_labels = kmeans(Kernel, num_clusters, ...
    'start','plus', ...
    'maxiter',max_iterations,...
    'replicates',replicates, ...
    'EmptyAction','singleton'...
    );

% Display final results
spx.graphics.figure.full_screen;
hold on;
axis equal;
for c=1:num_clusters
    % Identify points in this cluster
    points = raw_data(cluster_labels == c, :);
    X = points(:, 1);
    Y = points(:, 2);
    plot(X, Y, '.', 'MarkerSize',16);
end
saveas(gcf, 'images/st3_nrw_clustered_data.png');
