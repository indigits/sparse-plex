
close all; clear all; clc;


rho = 5;
% Ambient space dimension
M = 9;
% Number of subspaces
K = 5;
% common dimension for each subspace
D = 6;
rng default;
% dimensions of each subspace
Ds = D * ones(1, K);
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, Ds);
% Number of points on each subspace
Sk = rho * D
cluster_sizes = Sk * ones(1, K);
% total number of points
S = sum(cluster_sizes);
fprintf('Points per subspace: %d, Total points: %d\n', Sk, S);
% Let us generate uniformly distributed points in each subspace
points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
X = points_result.X;
start_indices = points_result.start_indices;
end_indices = points_result.end_indices;




angle_result = spx.cluster.subspace.nearest_same_subspace_neighbors_by_inner_product(X, cluster_sizes);

spx.cluster.subspace.print_nearest_neighbor_result(angle_result);


mf  = spx.graphics.Figures;
mf.new_figure;
subplot(331);
hist(angle_result.within_neighbor_counts);
title('Within Neighbors');
subplot(332);
hist(angle_result.within_minimum_angles);
title('Within Minimum Angles');
subplot(333);
hist(angle_result.within_maximum_angles);
title('Within Maximum Angles');
subplot(334);
hist(angle_result.nearst_within_neighbor_indices);
title('Within Nearest Indices');
subplot(335);
hist(angle_result.nearst_outside_neighbor_indices);
title('Outside Nearest Indices');
subplot(336);
hist(angle_result.outside_nearest_neighbor_angles);
title('Outside Nearest Angles');
subplot(337);
hist(angle_result.first_in_out_angle_spreads);
title('First In/Out angle spreads');
subplot(338);
subplot(339);

mf.new_figure;
hold on;
for s=1:S
    g = angle_result.SORTED_G(: , s);
    plot(g);
end