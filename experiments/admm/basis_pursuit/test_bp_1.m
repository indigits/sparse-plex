clc;
close all;
clearvars;
rand('seed', 0);
randn('seed', 0);

m = 100; % number of measurements
n = 1000; % signal space dimension
k = 10; % sparsity
A = randn(m,n) / sqrt(m);

x0 = sprandn(n, 1, .02);
b = A*x0;

% Perform Least absolute deviation optimization
tstart = tic;
options.verbose  = 1;
options.relative_tolerance = 1e-2;
x = spx.opt.admm.bp(A, b, options);
toc(tstart)
% measure the maximum difference
recovery_error = x - x0;
max_diff = max(abs(x - x0));
fprintf('Maximum difference: %e\n', max_diff);
fprintf('Recovery error norm: %e\n', norm(recovery_error));

subplot(211); stem(x0, '.'); subplot(212); stem(x, '.');
