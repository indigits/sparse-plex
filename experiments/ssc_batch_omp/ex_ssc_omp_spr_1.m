% dimension of ambient space
n = 100;
% number of subspaces = number of clusters
ns = 2;
% dimensions of individual subspaces 1 and 2
d1  = 2;
d2 = 2;
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
% ground through clustering data
true_labels = [1*ones(s1,1) ; 2*ones(s2,1)];
% the largest dimension amongst all subspaces
K = max(d1, d2);
% All signals are expected to  have a K-sparse representation
rng('default');
ssc_fast_omp = spx.cluster.ssc.SSC_FAST_OMP(X, K, ns);
result_fast_omp = ssc_fast_omp.solve();
rng('default');
ssc_omp = spx.cluster.ssc.SSC_OMP(X, K, ns);
result_omp = ssc_omp.solve();
combined_labels = [result_omp.Labels result_fast_omp.Labels]';
%combined_labels = [result_omp.Labels true_labels]'

% Time to compare the clustering
comparer = spx.cluster.ClusterComparison(result_omp.Labels, true_labels);
result = comparer.fMeasure();
fprintf('fMeasure (omp vs. true): %.4f\n', result.fMeasure);
comparer = spx.cluster.ClusterComparison(result_fast_omp.Labels, true_labels);
result = comparer.fMeasure();
fprintf('fMeasure (fast omp vs. true): %.4f\n', result.fMeasure);
comparer = spx.cluster.ClusterComparison(result_omp.Labels, result_fast_omp.Labels);
result = comparer.fMeasure();
fprintf('fMeasure (omp vs fast omp: %.4f\n', result.fMeasure);

C1 = full(ssc_omp.Representation);
C2 = full(ssc_fast_omp.Representation);
fprintf('Difference between representations: ');
max(max(abs(C1 - C2)))

D1 = full(ssc_omp.Adjacency);
D2 = full(ssc_fast_omp.Adjacency);
fprintf('Difference between adjacency matrices: ');
max(max(abs(D1 - D2)))
rptime1 = result_omp.representation_time;
rptime2 = result_fast_omp.representation_time;
fprintf('Representation time, SSC-OMP: %.4f, SSC_FAST_OMP: %.4f\n', rptime1, rptime2);