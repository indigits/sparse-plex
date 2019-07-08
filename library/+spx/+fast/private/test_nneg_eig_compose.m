clc;
close all;
clearvars;
make mex_sqrt_times.cpp; 

M = 8000;
N = 400;
V = orth(randn(M, N));
lambda = abs(randn(N,1));
tstart =  tic;
A1 = V * diag(lambda) * V';
t1 = toc(tstart);
tstart = tic;
mex_sqrt_times(lambda, V);
A2 = V * V';
t2 = toc(tstart);
fprintf('max diff: %e\n', max(max(abs(A1 - A2))));
fprintf('t1: %.4f, t2: %.4f, gain: %.2f x\n', t1, t2, t1/t2);

