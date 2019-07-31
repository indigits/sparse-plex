clearvars;
close all;
clc;
% Size of the matrix
n1 = 150;
n2 = 300;
% Rank of the matrix
r = 10;

rand('state',2009);

% Construct a low rank matrix
M = spx.data.synthetic.lowrank.from_randn(n1, n2, r);

% size of matrix
sz =  n1 * n2;
% Its degrees of freedom
df = spx.matrix.dof_lowrank(n1, n2, r);

% oversampling ratio
oversampling_ratio = 5;

% Number of samples to keep
m = min (oversampling_ratio * df, 0.99 * sz);

% incoherence factor
% rough ratio of the Frobenius norm of original matrix
% vs the sampled points matrix
% eq 5.2
p = m / (n1 * n2);

% Randomly choose the subset of indices to keep
Omega = spx.stats.rand_subset(sz, m);

% Sort the index set
Omega = sort(Omega);

% Select the corresponding values
data = M(Omega);

% noise parameter
sigma = 0;

% add noise if required
if sigma > 0
    data = data + sigma*randn(size(data));
end

% Summarize the problem
fprintf('Matrix completion problem: size: %d x %d, rank: %d, %.1f%% observations\n', ...
    n1, n2, r, 100*p);
fprintf('Degrees of freedom: %d, oversampling ratio: %d, noise std: %.2f\n', ...
    df, oversampling_ratio, sigma);

% parameters for the matrix completion algorithm.
options.tau = 5 * sqrt(sz);
% eq 5.1
options.delta = 1.2 / p;
% maximum number of iterations
options.max_iters = 500;
% convergence tolerance
options.tolerance = 1e-4;
options.verbosity = 1;

M2 = spx.sparse.join_data_indices(data, Omega, n1, n2);

tstart = tic;
[U,S,V, details] = spx.opt.completion.ccs_svt(M2, options);
toc(tstart);

X = U * diag(S) * V';

r = length(S);
fprintf('The recovered rank is : %d\n', r);

residual = data - X(Omega);
relative_error = norm(residual) / norm(data);
fprintf('The relative error on omega is: %.2e\n', relative_error);

mat_residual = M - X;
mat_rel_error = norm(mat_residual, 'fro') / norm(M, 'fro');

fprintf('The relative recovery error is: %.2e\n', mat_rel_error);

fprintf('Number of iterations: %d\n', details.iterations);
fprintf('Time taken in LANSVD: %.2f\n', details.svd_time);
fprintf('Time taken in x update: %.2f\n', details.x_update_time);
fprintf('Time taken in y update: %.2f\n', details.y_update_time);