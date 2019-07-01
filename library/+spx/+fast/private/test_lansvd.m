clc;
close all;
clearvars;
make mex_lansvd.cpp; 
options.verbosity = 1;
A = spx.data.mtx_mkt.abb313;
options.k = 4;
[U, S, V, details] = spx.fast.lansvd(A, 'k', 4, 'verbosity', 0);
% [U, S, V, details] = spx.fast.lansvd(A, options);

SS = svds(A, 4);

fprintf('Singular values by SVDS: ');
spx.io.print.vector(SS);
fprintf('Singular values by LANSVD: ');
spx.io.print.vector(S);


[U, S, V, details] = spx.fast.lansvd(A, 'lambda', 7.51);
fprintf('Singular values by LANSVD: ');
spx.io.print.vector(S);
