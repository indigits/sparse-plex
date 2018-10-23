close all;
clearvars;
clc;
rng default;
points_per_set = 100;
num_clusters = 8;
true_labels = zeros(points_per_set*num_clusters, 1);
gap = 1;
% points 
points = [];
for c=1:num_clusters
    mean_val = c * gap;
    % values random between 0 and 1
    point_set = rand(1, points_per_set);
    % shift between -gap / 4 and  gap / 4
    %point_set = point_set * gap / 2 - gap/4;
    % then move to mean
    point_set = point_set + mean_val;
    % add to the list of all points
    points = [points point_set];
    true_labels((c - 1)*points_per_set + (1:points_per_set)) = c;
end
figure;
hold on;
for c=1:num_clusters
    point_set = points((c - 1)*points_per_set + (1:points_per_set));
    plot(point_set, zeros(1, points_per_set) , '.' );
end