function [X, K, cluster_sizes, true_labels] = prepare_data(noise)
    if nargin < 1
        noise = false;
    end
% Ambient space dimension
M = 4000;
% Number of subspaces
K = 4;
% common dimension for each subspace
D = 10;
% dimensions of each subspace
Ds = D * ones(1, K);
% Noise level
sigma = 0.8;
fprintf('Generating synthetic data.\n');
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, Ds);
% Number of points on each subspace
Sk = 16 * D;
cluster_sizes = Sk * ones(1, K);
% total number of points
S = sum(cluster_sizes);
% Let us generate uniformly distributed points in each subspace
points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
X0 = points_result.X;
start_indices = points_result.start_indices;
end_indices = points_result.end_indices;
if noise
    Noise = sigma * spx.data.synthetic.uniform(M, S);
    % Add noise to signal
    X = X0 + Noise;
else
    X = X0;
end
% Normalize noisy signals.
X = spx.norm.normalize_l2(X); 
% true labels for each of the data samples
true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
fprintf('Size of the data matrix: %d x %d\n', M, S);
end