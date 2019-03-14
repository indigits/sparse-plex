clc;
close all;
clearvars;

n = 10;
A = gallery('binomial',n);
% drop the last two columns
A = A(:, 1:n-2);
% Let's add a column in between which is a linear combination
% of first three columns.
a = A(:, 1:3) * [1 1 1]';
b = A(:, 1:3) * [1 -1 1]';
A = [A(:, 1:3) a b A(:, 4:end)];


[QF, R, P] = spx.la.house.qr_pivot(A);
QF
Q = spx.la.house.q_back_accum_thin(QF)
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

