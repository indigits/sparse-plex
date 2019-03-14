clc;
close all;
clearvars;
n = 8;
A = gallery('binomial',n);
[Q1, R1] = spx.la.givens.qr(A);
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

