clc;
close all;
clearvars;
rng('default');
n = 10;
% Let's get a symmetric positive definite matrix
A = gallery('gcdmat', n);
% Compute its Cholesky decomposition
L = chol(A, 'lower')
b = randn(n, 1);
% solve the problem
x = L \b
x = spx.la.tris.forward_col(L, b)
