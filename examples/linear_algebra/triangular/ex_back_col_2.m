clc;
close all;
clearvars;
rng('default');
n = 10;
% Let's get an upper triangular matrix by Wilkinson
alpha = 2;
k = 5;
U = gallery('triw',n,alpha,k)
b = randn(n, 1);
% solve the problem
x = U \b
x = spx.la.tris.back_col(U, b)
