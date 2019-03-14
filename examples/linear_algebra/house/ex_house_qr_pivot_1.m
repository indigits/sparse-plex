clc;
close all;
clearvars;
rng('default');

n = 8;
A = gallery('binomial',n);
[QF, R, P] = spx.la.house.qr_pivot(A);
Q = spx.la.house.q_back_accum_thin(QF);
A1 = Q * R;
A1(:, P) = A1;
A
A1
fprintf('::: %f\n', max(max(abs(A-A1))));

[Q2, R2] = qr(A);
A2 = Q2 * R2;
R
R2
R3 = abs(R) - abs(R2)

Q
Q2
Q3 = abs(abs(Q) - abs(Q2))


ADIFF  = A1  - A2

