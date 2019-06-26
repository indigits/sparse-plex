clc;
close all;
clearvars;

a = [1 2 3 3 2 1]'; b = [1 2 -1 -2 1]';

% a = [1 2 3 4 5 6]'; b = [1 2 -1 -2 1]';

% a = [1/2 1/4 1/8 1/16 1/32 1/64]'; b = [1 2 -1 -2 1]';

% a = [1/64 1/32 1/16 1/8 1/4 1/2]'; b = [1 2 -1 -2 1]';


% a = ones(6, 1); b = zeros(5, 1);
% a = [1 1 1/100]'; b = [0  1]';
% a = [-1 1 1/100]'; b = [0  -1]';

% a = [-1 1/10 1/100]'; b = [.1 -.1]';
% a = [1/100 -1/10 1]'; b = [-.1 .1]';

n = numel(a);

A = full(spdiags([a [0; b]], [0 1], n, n));

[UU, SS, VV] = svd(A);

make mex_svd_bd_hizqr.cpp; 
[U, S, VT] = mex_svd_bd_hizqr(a,b);
fprintf('Original singular values: ');
spx.io.print.vector(diag(SS), 'e');
fprintf('SPX singular values: ');
spx.io.print.vector(S, 'e');
fprintf('U nonorthogonality: %.2f\n', spx.la.nonorthogonality(U));
fprintf('V nonorthogonality: %.2f\n', spx.la.nonorthogonality(VT));

A2 = U*diag(S)*VT;
spx.matrix.compare(A, A2);

if 1
UU
U
end

