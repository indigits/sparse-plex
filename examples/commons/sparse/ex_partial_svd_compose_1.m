clc;
clearvars;
rng default;
A = magic(6);

[n1, n2] = size(A);

sz = n1 * n2;

factors = [0.05 0.1 0.2 0.3];
A
for f=factors
    m = round(f * sz);
    fprintf('Trying for factor=%f, m=%d\n', f, m);
    Omega = spx.stats.rand_subset(sz, m);
    [U, S, V] = svd(A);
    y = spx.fast.partial_svd_compose(U, diag(S), V, Omega);
    spx.io.print.vector(y);
    A2 = spx.sparse.join_data_indices(y, Omega, n1, n2);
    full(A2)
end
A
