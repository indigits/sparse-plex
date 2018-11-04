clearvars;
close all;
clc;
rng default;
e1 = [1 0 0]';
e2 = [0 1 0]';
e3 = [0 0 1]';

basis1 = [e1 e2];
basis2 = [e2 e3];

bases = {basis1, basis2};
cluster_sizes = [5 5];
points = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
X = points.X

S = size(X, 2);

C = zeros(S, S);
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
    C(:, s)  = z;
end
elapsed_time  = toc(start_time);
fprintf('\n');
spr_stats = spx.cluster.subspace.subspace_preservation_stats(C, cluster_sizes);

labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes)

spr_flags = zeros(1, S);
spr_errors = zeros(1, S);

C = abs(C);

c1 = C(:, 1);

k = labels(1);

non_zero_indices = (c1 >= 1e-3);

non_zero_labels = labels(non_zero_indices);

spr_flags(1) = all(non_zero_labels == k)

w = labels == k;

c1k = c1(w);

spr_errors(1) = 1 - sum(c1k) / sum (c1);

