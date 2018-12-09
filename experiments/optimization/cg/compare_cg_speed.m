% Compares the speed of CG implementations
clc;
clearvars;
close all;
%rng default;

N = 32;

T = 1000;
t1 = 0;
t2 = 0;
for i=1:T
    if mod(i, 10) == 0
        fprintf('.');
    end
    A = spx.dict.simple.gaussian_mtx(N, N);
    A = A' * A;
    x = randn(N, 1);
    b  = A * x;
    tolerance = 1e-2;
    max_iterations = N * 5;

    tic;
    [x, res, iter ] = cgsolve(A, b, tolerance, max_iterations, 0);
    t1 = t1 + toc;

    options.tolerance = tolerance;
    options.max_iterations = max_iterations;
    tic;
    result = spx.fast.cg(A, b, options);
    t2 = t2 + toc;
end

fprintf('\n');
fprintf('Time taken by MATLAB implementation: %0.3f\n', t1);
fprintf('Time taken by C++ implementation: %0.3f\n', t2);
fprintf('Gain: %0.2f\n', t1/t2);