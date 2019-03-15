% Demo of Hessenberg QR to RQ
clc;
close all;
clearvars;
n = 4;
A = gallery('binomial',n);
H = hess(A)
H1 = spx.la.hessenberg.qr_rq(H);

[Q, R] = qr(H);
H2 = R * Q;

H1
H2
fprintf('max diff ::: %f\n', max(max(abs(abs(H1)-abs(H2)))));
