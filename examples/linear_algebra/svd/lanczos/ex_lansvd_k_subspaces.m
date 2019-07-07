clc;
clearvars;
close all;
rng default;
% Ambient space dimension
M = 4000;
% Number of subspaces
K = 10;
% common dimension for each subspace
D = 20;
% dimensions of each subspace
Ds = D * ones(1, K);
fprintf('Generating synthetic data.\n');
bases = spx.data.synthetic.subspaces.random_subspaces(M, K, Ds);
% Number of points on each subspace
Sk = 8 * D;
cluster_sizes = Sk * ones(1, K);
% total number of points
S = sum(cluster_sizes);
% Let us generate uniformly distributed points in each subspace
points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
X = points_result.X;
% Normalize noisy signals.
A = spx.norm.normalize_l2(X); 
tau = 100/norm(A)^2;
threshold = 1/sqrt(tau);
k = 4;

% options.k = 200;
tstart = tic;
s = svds(A, k);
svds_time = toc(tstart);
fprintf('svds singular values: ');
spx.io.print.vector(s(1:k));


if 1
options = struct;
options.lambda = threshold;
options.verbosity = 0;
options.tolerance =  16*eps;
% options.k = k;
options.p0 = ones(M, 1);
tstart = tic;
[~, S, V, details] = spx.fast.lansvd(A, options);
spx_lansvd_time = toc(tstart);
fprintf('lansvd singular values (%d): \n', numel(S));
spx.io.print.vector(S);
fprintf('SVDS time: %.4f sec, SPX LANSVD time: %.4f sec', svds_time, spx_lansvd_time);
fprintf('  GAIN : %.2f X\n', svds_time / spx_lansvd_time);
end

if 0
fprintf('Original LANSVD\n')
tstart = tic;
options = struct;
options.p0 = ones(M, 1);
S = lansvd(A, k, 'L', options);
orig_lansvd_time = toc(tstart);
fprintf('lansvd singular values: ');
spx.io.print.vector(S);
fprintf('SVDS time: %.4f sec, LANSVD time: %.4f sec', svds_time, orig_lansvd_time);
fprintf('  GAIN : %.2f X\n', svds_time / orig_lansvd_time);
end
