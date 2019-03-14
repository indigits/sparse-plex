% Demo of Hessenberg QR
clc;
close all;
clearvars;
n = 8;
A = gallery('binomial',n);
H = hess(A);
[Q1, R1] = spx.la.givens.hess_qr(H);
H1 = Q1 * R1;
H
H1
fprintf('::: %f\n', max(max(abs(H-H1))));

[Q2, R2] = qr(H);
R1
R2
R3 = abs(R1) - abs(R2)

Q1
Q2
Q3 = abs(abs(Q1) - abs(Q2))

HDIFF  = Q1 * R1  - Q2 * R2

