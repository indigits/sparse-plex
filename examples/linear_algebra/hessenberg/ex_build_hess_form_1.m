% Builds the Hessenberg form of a matrix 
clc;
close all;
clearvars;
n = 4;
A = gallery('binomial',n)

[H1, Q1] = spx.la.hessenberg.hess(A)
A1 = Q1 * H1 * Q1'
[Q2, H2] = hess(A)
A2 = Q2 * H2 * Q2'

fprintf('max diff ::: %f\n', max(max(abs(abs(A1)-abs(A2)))));
