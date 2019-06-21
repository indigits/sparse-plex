clc;
a = [1 2 3 3 2 1]';
b = [1 2 -1 -2 1]';

a = [1 2 3 4 5 6]';

a = [1/2 1/4 1/8 1/16 1/32 1/64]';

a = [1/64 1/32 1/16 1/8 1/4 1/2]';

n = numel(a);

A = full(spdiags([a [0; b]], [0 1], n, n));

[UU, SS, VV] = svd(A);

make mex_svd_bd_hizqr.cpp; 
[U, S, V] = mex_svd_bd_hizqr(a,b);
fprintf('Original singular values: ');
spx.io.print.vector(diag(SS), 'e');
fprintf('SPX singular values: ');
spx.io.print.vector(S, 'e');
