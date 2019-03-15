clc;
close all;
clearvars;

n = 10;
k = 4;
A = gallery('lotkin',n)
eigen_values = eig(A)';
options.capture_lambdas = true;
[Q, lambdas, details] = spx.la.eig.orth_iters(A, eye(n, k), options);
Q
iterations = details.iterations
Lambdas = details.lambdas
lambdas
eigen_values
fprintf('Computing Q^T * A * Q\n' );
diag(Q' * A * Q)'
