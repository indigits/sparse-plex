function spx_bdpro(A, k)
fprintf('Running SPX BDPRO with k=%d\n', k);
s = svds(A, k);
fprintf('True singular values: ');
spx.io.print.vector(s(1:k));
k2 = k + 20;
[U, B, V, p, details] = spx.la.svd.lanczos.bdpro(A, k2);
e = spx.vector.unit_vector(k2, k2);
residual = A * V - U * B - p * e'; 
fprintf('Factorization residual: %e\n', max(max(abs(residual))));
fprintf('U non-orthogonality: %e\n', spx.la.nonorthogonality(U));
fprintf('V non-orthogonality: %e\n', spx.la.nonorthogonality(V));
B2 = full(B);
B2 = B2(1:end-1, :);
fprintf('Measured singular values: ');
spx.io.print.vector(svd(B2));

fprintf('Number of U reorthogonalizations: %d\n', details.nreorthu);
fprintf('Number of V reorthogonalizations: %d\n', details.nreorthv);
fprintf('Number of U inner products: %d\n', details.npu);
fprintf('Number of V inner products: %d\n', details.npv);


end
