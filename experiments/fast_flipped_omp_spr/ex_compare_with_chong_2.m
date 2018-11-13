% dimension of ambient space
n = 100;
% number of subspaces = number of clusters
ns = 2;
% dimensions of individual subspaces 1 and 2
d1  = 10;
d2 = 10;
% number of signals in individual subspaces
s1 = 100;
s2 = 100;
% total number of signals
s = s1 + s2;
% A random basis for first subspace;
basis1 = randn(n,d1);
% coefficients for s1 vectors chosen randomly in subspace 1
coeffs1 = randn(d1,s1);
% Random signals from first subspace
X1 = basis1 * coeffs1;
% A random basis for second subspace
basis2 = randn(n,d2);
% coefficients for s2 vectors chosen randomly in subspace 2
coeffs2 = randn(d2,s2);
% Random signals from first subspace
X2 = basis2 * coeffs2;
% Prepare the overall set of signals
X = [X1 X2];
X = spx.norm.normalize_l2(X);
% the largest dimension amongst all subspaces
K = max(d1, d2);

fprintf('Computing OMP SPR\n');
C1 = spx.fast.omp_spr(X, K, 0);
max(max(abs(X - X * C1)))

fprintf('Computing using OMP function in SSCOMP toolbox');
C2 = OMP_mat_func(X, K, 0);
max(max(abs(X - X * C2)))
fprintf('Comparing C1 & C2: %e\n', full(max(max(abs(C1 - C2)))));

fprintf('Computing using Flipped OMP function in sparse-plex');
C3 = spx.fast.batch_flipped_omp_spr(X, K, 0);
max(max(abs(X - X * C3)))
fprintf('Comparing C2 & C3: %e\n', full(max(max(abs(C2 - C3)))));
