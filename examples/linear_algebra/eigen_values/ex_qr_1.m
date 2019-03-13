clc;
close all;
clearvars;
% A = [1     1     1
%      1     2     3
%      1     3     6];
% A = hadamard(20);
% gaussian matrix would have complex eigen values.
% A = randn(20);

% D = diag([10:-1:1]);
D = diag([4 2 2  2]);
n = length(D);
rng('default');
S = rand(n);
S = (S - 0.5)*2;
A = S * D / S;

[T, U, details] = spx.la.eig.qr_simple(A);

fprintf('Number of iterations: %d\n', details.iterations);
T
U
A
B = U * T * U';
C  = B - A
eig(A)
eig(T)
