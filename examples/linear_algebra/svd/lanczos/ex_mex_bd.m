clc;
close all;
clearvars;

n = 10;
A = mat_simple_1(n);

s = svd(A);
fprintf('True singular values: ');
spx.io.print.vector(s(1:min(n, 20)));
k = 6;
options.verbosity = 5;
options.p0 = ones(size(A, 1), 1);
[U, B, V, p, details] = spx.la.svd.lanczos.bd(A, k, options);
e = spx.vector.unit_vector(k, k);
residual = A * V - U * B - p * e';     
fprintf('Factorization residual: %e\n', max(max(abs(residual))));
fprintf('U non-orthogonality: %e\n', spx.la.nonorthogonality(U));
fprintf('V non-orthogonality: %e\n', spx.la.nonorthogonality(V));
B2 = full(B);
fprintf('Measured singular values: ');
spx.io.print.vector(svd(B2));
