close all;
clearvars;
clc;
rng default;

% Ambient space dimension
M = 10;
% Number of subspaces
K = 4;
% common dimension for each subspace
D = 5;

% Construct bases for random subspaces
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, D);
cluster_sizes = [10 4 4 8];
data_points = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
