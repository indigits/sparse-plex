% Demonstrates spectral clustering on data-sets from 
% self-tuning clustering paper.
clear all; close all; clc; 
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');
export = 1;

data = load('self_tuning_paper_clustering_data.mat');
datasets = data.XX;
num_data_sets = length(datasets);
%% Scale to use for standard spectral clustering
scale = 0.04;
spectral_clustering_results = {};
format long;              
for nd=1:num_data_sets
    dataset = datasets{nd};
    %% centralize and scale the data
    dataset = dataset - repmat(mean(dataset),size(dataset,1),1);
    dataset = dataset/max(max(abs(dataset)));
    num_clusters = data.group_num(nd);
    % every data set is a set of points
    % one point per row. 
    % number of rows = number of points.
    % points are in 2-dimensions
    fprintf('Number of points: %d\n', size(dataset, 1));
    fprintf('Expected number of groups: %d\n', num_clusters);
    % prepare the distance matrix
    sqrt_dist_mat = spx.commons.distance.sqrd_l2_distances_rw(dataset);
    sim_mat = SPX_Similarity.gauss_sim_from_sqrd_dist_mat(sqrt_dist_mat, scale);
    % Run clustering on the dataset
    clusterer = spx.cluster.spectral.Clustering(sim_mat);
    clusterer.NumClusters = num_clusters;
    %cluster_labels = clusterer.cluster_symmetric();
    cluster_labels = clusterer.cluster_random_walk();
    % Keep the labels for later use
    spectral_clustering_results{nd} = cluster_labels;
end

spx.graphics.Figures.full_screen_figure;

plots_per_set = 2;
colors = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0];

% For each dataset, there are two plots.
% First we show the original unclustered points all in blue color.
% Then in the second plot, we show the points in different colors
% based on the clusters to which they are assigned.
for nd=1:num_data_sets
    dataset = datasets{nd};
    num_points = size(dataset, 1);
    %%%%%%%%%%%% display results

    % Left plot
    subplot(num_data_sets, plots_per_set,1+(nd-1)*plots_per_set);
    % Display all points in the dataset in unclustered form.
    hold on;
    X = dataset(:, 1);
    Y = dataset(:, 2);
    plot(X, Y, '.', 'MarkerSize',16);
    axis equal;
    title('Unclustered');
    hold off;
    drawnow;

    % Right plot
    subplot(num_data_sets, plots_per_set,2+(nd-1)*plots_per_set);
    % Spectral clustering results
    % Number of clusters
    num_clusters = data.group_num(nd);
    hold on;
    % Clusters will be plotted one by one.
    cluster_labels = spectral_clustering_results{nd};
    for c=1:num_clusters
        % Identify points in this cluster
        points = dataset(cluster_labels == c, :);
        X = points(:, 1);
        Y = points(:, 2);
        plot(X, Y, '.','Color',colors(c,:), 'MarkerSize',16);
    end
    axis equal;
    title('Spectral clustering');
    hold off;
    drawnow;
end
format short;

if export
    export_fig bin/self_tuning_paper_data_spectral_clustering.png -r120 -nocrop;
    export_fig bin/self_tuning_paper_data_spectral_clustering.pdf;
end

