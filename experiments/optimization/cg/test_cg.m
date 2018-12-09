clc;
clearvars;
close all;
%rng default;

N = 1000;
A = spx.dict.simple.gaussian_mtx(N, N);
A = A' * A;
x = randn(N, 1);
b  = A * x;

[x, res, iter ] = cgsolve(A, b, 1e-2, N*5, 0);
spx.io.print.vector(x, 3);

options.tolerance = 1e-2;
options.max_iterations = N*5;
fprintf('\nTrying fast solver: \n\n')
result = spx.fast.cg(A, b, options);
x = result.x;
spx.io.print.vector(x, 3);
