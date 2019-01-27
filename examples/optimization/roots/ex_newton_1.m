close all;
clearvars;
clc;

f = @(x) exp(x)+x;
df = @(x) exp(x)+1; 
x0  = 0;
tol = 1e-6;

[x, change, iterations] = spx.opt.roots.newton(f, df, x0, tol);

