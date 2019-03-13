clc;
close all;
clearvars;
rng('default');

n = 8;
A1 = gallery('binomial',n);
A2 = A1;

r = 4;
Q_factors = zeros(n, r);
for i=1:r
    [v, beta] = spx.la.house.gen(A2(i:n, i));
    Q_factors(i+1:n, i) = v(2:n-i+1);
    A2(i:n, i:n) = spx.la.house.premul(A2(i:n, i:n), v, beta)
    v_full = [zeros(i-1, 1); v];
end
% We compute the factors W and Y for Q = Q_1 * Q_2 * .. * Q_r
% such that Q = I - WY'
[W, Y] = spx.la.house.wy(Q_factors);
% We pre-multiply with I - WY'
A3 = spx.la.house.wy_premul(A2, W, Y);
A1
A3
max(max(abs(A1 - A3)))
