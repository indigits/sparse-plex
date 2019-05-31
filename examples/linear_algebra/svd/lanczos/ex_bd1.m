clc;
close all;
clearvars;

A = mat_simple_1();


s = svd(A);
fprintf('True singular values: ');
spx.io.print.vector(s(1:20));

for k=2:2:20
    [U, B, V, p, details] = spx.la.svd.lanczos.bd(A, k);
    e = spx.vector.unit_vector(k, k);
    residual = A * V - U * B - p * e';     
    fprintf('Factorization residual: %e\n', max(max(abs(residual))));
    fprintf('U non-orthogonality: %e\n', spx.la.nonorthogonality(U));
    fprintf('V non-orthogonality: %e\n', spx.la.nonorthogonality(V));
    B2 = full(B);
    B2 = B2(1:end-1, :);
    fprintf('Measured singular values: ');
    spx.io.print.vector(svd(B2));
end

fprintf('True singular values: ');
spx.io.print.vector(s(1:30));

for k=2:2:24
    [U, B, V, p, details] = spx.la.svd.lanczos.bdfro(A, k);
    e = spx.vector.unit_vector(k, k);
    residual = A * V - U * B - p * e';     
    fprintf('Factorization residual: %e\n', max(max(abs(residual))));
    fprintf('U non-orthogonality: %e\n', spx.la.nonorthogonality(U));
    fprintf('V non-orthogonality: %e\n', spx.la.nonorthogonality(V));
    B2 = full(B);
    B2 = B2(1:end-1, :);
    fprintf('Measured singular values: ');
    spx.io.print.vector(svd(B2));
end
