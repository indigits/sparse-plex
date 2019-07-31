clc;
clearvars;
rng default;
A = magic(6);

[n1, n2] = size(A);

sz = n1 * n2;

m = round(.2 * sz);

Omega = spx.stats.rand_subset(sz, m);

data = A(Omega);

A2 = spx.sparse.join_data_indices(data, Omega, n1, n2);
[data2, Omega2, m1, m2] = spx.sparse.split_data_indices(A2);

data2 = 2*data2;
full(A2)
spx.fast.update_sparse_data(A2, data2);
full(A2)