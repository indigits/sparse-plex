function propack_lanbdpro(A, k)
fprintf('Running PROPACK LANBPRO with k=%d\n', k);
s = svds(A, k);
fprintf('True singular values: ');
spx.io.print.vector(s(1:k));
k2 = k + 20;
[U, B, V, p, ierr, work] = lanbpro(A, k2);
e = spx.vector.unit_vector(k2, k2);
residual = A * V - U * B - p * e'; 
fprintf('Factorization residual: %e\n', max(max(abs(residual))));
fprintf('U non-orthogonality: %e\n', spx.la.nonorthogonality(U));
fprintf('V non-orthogonality: %e\n', spx.la.nonorthogonality(V));
B2 = full(B);
B2 = B2(1:end-1, :);
fprintf('Measured singular values: ');
spx.io.print.vector(svd(B2));

fprintf('Number of U reorthogonalizations: %d\n', work(1,1));
fprintf('Number of V reorthogonalizations: %d\n', work(2,1));
fprintf('Number of U inner products: %d\n', work(1,2));
fprintf('Number of V inner products: %d\n', work(2,2));

end