% dimension of ambient space
n = 6;
% number of subspaces = number of clusters
ns = 2;
% dimensions of individual subspaces 1 and 2
d1  = 2;
d2 = 2;
% number of signals in individual subspaces
s1 = 10;
s2 = 10;
% total number of signals
S = s1 + s2;
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
% ground through clustering data
true_labels = [1*ones(s1,1) ; 2*ones(s2,1)];
% the largest dimension amongst all subspaces
K = max(d1, d2);
X = spx.norm.normalize_l2(X);
C = spx.fast.omp_spr(X, K, 0);

solver = spx.pursuit.single.OrthogonalMatchingPursuit(X, K);
C2 = zeros(S, S);
for s=1:S
    solver.IgnoredAtom = s;
    result = solver.solve(X(:, s));
    C2(:, s) = result.z;
end
max(C2 - C)
max(abs(X - X * C))
