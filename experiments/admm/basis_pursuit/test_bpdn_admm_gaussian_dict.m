clearvars;
close all;
% clc;

rng default;

M = 300;
N = 1000;
K = 60;

A = randn(M, N);
x0 = zeros(N,1);

permutation = randperm(N);
indices = permutation(1:K);
% non-zero entries
x0(indices) = randn(K,1);

b0 = A * x0;
% noise variance
sigma = 0.1;
e = sigma * randn(M, 1);
% add noise
b = b0 + e;

% orthonormalize the rows of A
% perform QR decomposition of rows of A
[Q, R] = qr(A', 0);
% keep the orthogonal rows
A = Q';
% change b accordingly to the new coordinates
b = R'\b;

options.verbose = 0;
options.max_iterations = 200;
options.tolerance = 5e-3;
solver = spx.pursuit.single.L1_ADMM_YZ(A, options);
mu = sigma;
x = solver.solve_bpdn_l2(b, mu);

r = x - x0;
max_diff = max(abs(r));
rel_error = norm(x-x0) /norm(x0);
iterations = solver.details.iterations(1);
elapsed_time = solver.details.elapsed_times(1);
fprintf('Iterations: %d, Relative error: %e, max diff: %.4f, time: %.4f seconds\n', ...
    iterations, rel_error, max_diff, elapsed_time);

print = 1;
if print
    subplot(211);
    stem(x0, '.');
    subplot(212);
    stem(x, '.');
    figure;
    iterations = solver.details.iterations(1);
    iters = 1:iterations;
    primal_objectives = solver.details.primal_objectives(iters, 1);
    dual_objectives = solver.details.dual_objectives(iters, 1);
    plot(iters, primal_objectives);
    hold on;
    plot(iters, dual_objectives);
    xlabel('Iterations');
    ylabel('Objective Value');
    legend({'Primal Objective', 'Dual Objective'});
    grid on;
end

cvx = 0;
if cvx
% time to compare with a CVX implementation
cvx_solver = spx.pursuit.single.BasisPursuit(A, b);
tstart = tic;
x = cvx_solver.solve_lasso(1/(2*mu));
elapsed_time = toc(tstart);
r = x - x0;
max_diff = max(abs(r));
rel_error = norm(x-x0) /norm(x0);
fprintf('Relative error: %e, max diff: %.4f, time: %.4f seconds\n', ...
    rel_error, max_diff, elapsed_time);
end