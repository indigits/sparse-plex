clc;
close all;
clearvars;
rng('default');

n = 8;
A = gallery('binomial',n);
[Q_factors, R1] = spx.la.house.qr(A);
Q1 = spx.la.house.q_back_accum_thin(Q_factors);
A1 = Q1 * R1;
A
A1
fprintf('::: %f\n', max(max(abs(A-A1))));

[Q2, R2] = qr(A);
R1
R2
R3 = abs(R1) - abs(R2)

Q1
Q2
Q3 = abs(abs(Q1) - abs(Q2))

ADIFF  = Q1 * R1  - Q2 * R2

