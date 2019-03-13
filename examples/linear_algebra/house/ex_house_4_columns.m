% We take an array and compute its householder reflections
% based factors for first 4 columns
clc;
close all;
clearvars;
rng('default');

n = 8;
A1 = gallery('binomial',n);
A2 = A1;

r = 4;
Q_factors = zeros(n, r);
Q1 = eye(n);
Q2 = eye(n);
for i=1:r
    [v, beta] = spx.la.house.gen(A2(i:n, i));
    Q_factors(i+1:n, i) = v(2:n-i+1);
    A2(i:n, i:n) = spx.la.house.premul(A2(i:n, i:n), v, beta)
    v_full = [zeros(i-1, 1); v];
    Q1 = spx.la.house.premul(Q1, v_full, beta);
    Q2 = spx.la.house.postmul(Q2, v_full, beta);
end
A3 = Q1' * A2;
A4 = Q2 * A2;

A1
A3
A4
max(max(abs(A1 - A3)))
max(max(abs(A3 - A4)))
