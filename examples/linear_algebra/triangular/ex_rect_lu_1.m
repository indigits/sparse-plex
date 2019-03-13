clc;
close all;
clearvars;
rng('default');
m = 10;
n = 5;
% Let's get a non-singular 
A = gallery('parter',m);
A = A(:, 1:n)
% Compute its Cholesky decomposition
[L, U] = spx.la.lu.rect(A)
max(max(abs((A - L*U))))
% Compute Cholesky decomposition using MATLAB
[L, U] = lu(A)
max(max(abs((A - L*U))))
