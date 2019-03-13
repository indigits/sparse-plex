clc;
close all;
clearvars;
rng('default');
n = 10;
% Let's get a symmetric positive definite matrix
A = gallery('gcdmat', n);
% Compute its Cholesky decomposition
U = chol(A);
b = randn(n, 1);
% solve the problem
x = U \b
x = spx.la.tris.back_col(U, b)
