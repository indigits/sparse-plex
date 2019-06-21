clc;
close all;
clearvars;
rng default;

n = 50;
A = mat_simple_1(n);

true_singular_values = svd(A);
fprintf('True singular values: ');
spx.io.print.vector(true_singular_values(1:min(n, 20)));
k = 2;
options.verbosity = 1;
options.p0 = ones(size(A, 1), 1);
fprintf('Running spx.la.svd.lanczos.bdpro for k=%d\n', k);
[U, B, V, p, details] = spx.la.svd.lanczos.bdpro(A, k, options);
e = spx.vector.unit_vector(k, k);
residual = A * V - U * B - p * e';     
fprintf('Factorization residual: %e\n', max(max(abs(residual))));
fprintf('U non-orthogonality: %e\n', spx.la.nonorthogonality(U));
fprintf('V non-orthogonality: %e\n', spx.la.nonorthogonality(V));
B2 = full(B);
fprintf('Measured singular values: ');
spx.io.print.vector(svd(B2));

fprintf('Running spx.fast.lansvd\n')
options.verbosity = 1;
[U, S, V, details] = spx.fast.lansvd(A, k, options);
rem_norm = norm(A - U * diag(S) * V');
fprintf('Norm of remainder: %f, corresponding singular value: %f\n', rem_norm, true_singular_values(k+1));
fprintf('Estimated singular values: ');
spx.io.print.vector(S);
fprintf('Algorithm details: \n');
disp(details)

