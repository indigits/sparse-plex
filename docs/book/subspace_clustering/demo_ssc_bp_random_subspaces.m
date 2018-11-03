clear all;
close all;
clc;
rng default;

% Ambient space dimension
M = 50;
% Number of subspaces
K = 10;
% common dimension for each subspace
D = 20;

% Construct bases for random subspaces
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, D);
% samples angles between subspaces
angles_matrix = spx.la.spaces.smallest_angles_deg(bases)
angles = spx.matrix.off_diag_upper_tri_elements(angles_matrix)';
min(angles)

% Number of points on each subspace
Sk = 4 * D;

cluster_sizes = Sk * ones(1, K);
% total number of points
S = sum(cluster_sizes);

points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
X0 = points_result.X;

% noise level
sigma = 0.5;
% Generate noise
Noise = sigma * spx.data.synthetic.uniform(M, S);
% Add noise to signal
X = X0 + Noise;
% Normalize noisy signals.
X = spx.norm.normalize_l2(X); 
% labels assigned to the data points
true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
cvx_solver sdpt3
cvx_quiet(true);

% storage for coefficients
Z = zeros(S, S);
start_time = tic;
fprintf('Processing %d signals\n', S);
for s=1:S
    fprintf('.');
    if (mod(s, 50) == 0)
        fprintf('\n');
    end
    x = X(:, s);
    cvx_begin
    % storage for  l1 solver
    variable z(S, 1);
    minimize norm(z, 1)
    subject to
    x == X*z;
    z(s) == 0;
    cvx_end
    Z(:, s)  = z;
end
elapsed_time  = toc(start_time);
fprintf('\n Time spent: %.2f seconds\n', elapsed_time);
W = abs(Z) + abs(Z).';
clustering_result = spx.cluster.spectral.simple.normalized_symmetric(W);
cluster_labels = clustering_result.labels;
% Time to compare the clustering
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;

spr_stats = spx.cluster.subspace.subspace_preservation_stats(Z, cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;
elapsed_time  = toc(start_time);
fprintf('\nclustering error: %0.2f %%, clustering accuracy: %0.2f %% \n'...
    , clustering_error_perc, clustering_acc_perc);
fprintf('mean spr error: %0.2f, preserving : %0.2f %%\n', spr_stats.spr_error, spr_stats.spr_perc);
fprintf('elapsed time: %0.2f sec', elapsed_time);
fprintf('\n\n');
