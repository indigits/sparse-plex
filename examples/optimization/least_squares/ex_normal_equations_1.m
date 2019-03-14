clc;
close all;
clearvars;
m = 8;
n = 4;
A = gallery('binomial',m);
A = A(:, 1:n)
x0 = (1:n)'
b = A * x0

x = spx.opt.ls.normal_eq(A, b)

