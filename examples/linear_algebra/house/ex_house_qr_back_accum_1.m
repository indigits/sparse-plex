% This script demonstrates incremental building
% of Q matrix through back accumulation
clc;
close all;
clearvars;
rng('default');

n = 5;
A = gallery('binomial',n)
[Q_factors, R] = spx.la.house.qr(A);

for i=1:n
    Q = spx.la.house.q_back_accum_thin(Q_factors(:, 1:i))
end
A2 = Q*R
for i=1:n
    Q = spx.la.house.q_back_accum_full(Q_factors(:, 1:i))
end
A3 = Q*R
