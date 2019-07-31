clc;
clearvars;
rng default;
A = magic(6);

[n1, n2] = size(A);

sz = n1 * n2;

m = round(.2 * sz);

Omega = spx.stats.rand_subset(sz, m);

[U, S, V] = svd(A);

A
y = spx.fast.partial_svd_compose(U, diag(S), V, Omega)

A2 = spx.sparse.join_data_indices(y, Omega, n1, n2);
full(A2)
