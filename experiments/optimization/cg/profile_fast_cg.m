clc;
clearvars;
close all;
%rng default;

N = 5000;
A = spx.dict.simple.gaussian_mtx(N, N);
A = A' * A;
x = randn(N, 1);
b  = A * x;
options.tolerance = 1e-2;
options.max_iterations = N*5;

fprintf('Trying cgsolve.m\n');
tic;
[x, res, iter ] = cgsolve(A, b, 1e-2, N*5, 0);
time_spent = toc;
fprintf('Time spent: %.4f\n', time_spent);

fprintf('\nTrying fast solver: \n\n')
tic;
result = spx.fast.cg(A, b, options);
time_spent = toc;
fprintf('Outside time spent: %.4f\n', time_spent);