clc;
a = [1 2 3 3 2 1]';
b = [1 2 -1 -2 1]';

a = [1 2 3 4 5 6]';

n = numel(a);

A = full(spdiags([a [0; b]], [0 1], n, n));

[UU, SS, VV] = svd(A);

make mex_svd_bd_hizqr.cpp; 
[U, S, V] = mex_svd_bd_hizqr(a,b);
fprintf('Original singular values: ');
spx.io.print.vector(diag(SS), 4);
fprintf('SPX singular values: ');
spx.io.print.vector(S, 4);
