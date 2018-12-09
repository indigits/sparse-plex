import spx.cluster.ssc.OMP_REPR_METHOD;
import spx.cluster.ssc.SSC_OMP;

% dimension of ambient space
n = 500;
% number of subspaces = number of clusters
ns = 2;
% dimensions of individual subspaces 1 and 2
d1  = 20;
d2 = 20;
% number of signals in individual subspaces
s1 = 500;
s2 = 500;
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
rnorm_thr = 1e-4;
% All signals are expected to  have a K-sparse representation
rng('default');
ssc_batch_omp = spx.cluster.ssc.SSC_OMP(X, K, ns, rnorm_thr, OMP_REPR_METHOD.BATCH_OMP_C);
result_batch_omp = ssc_batch_omp.solve();
rng('default');
ssc_omp = spx.cluster.ssc.SSC_OMP(X, K, ns, rnorm_thr, OMP_REPR_METHOD.FLIPPED_OMP_MATLAB);
result_omp = ssc_omp.solve();
combined_labels = [result_omp.Labels result_batch_omp.Labels]';
%combined_labels = [result_omp.Labels true_labels]'

% Time to compare the clustering
comparer = spx.cluster.ClusterComparison(result_omp.Labels, true_labels);
result = comparer.fMeasure();
fprintf('fMeasure (omp vs. true): %.4f\n', result.fMeasure);
comparer = spx.cluster.ClusterComparison(result_batch_omp.Labels, true_labels);
result = comparer.fMeasure();
fprintf('fMeasure (batch omp vs. true): %.4f\n', result.fMeasure);
comparer = spx.cluster.ClusterComparison(result_omp.Labels, result_batch_omp.Labels);
result = comparer.fMeasure();
fprintf('fMeasure (omp vs batch omp: %.4f\n', result.fMeasure);

C1 = full(ssc_omp.Representation);
C2 = full(ssc_batch_omp.Representation);
fprintf('Difference between representations: ');
max(max(abs(C1 - C2)))

D1 = full(ssc_omp.Adjacency);
D2 = full(ssc_batch_omp.Adjacency);
fprintf('Difference between adjacency matrices: ');
max(max(abs(D1 - D2)))
rptime1 = result_omp.representation_time;
rptime2 = result_batch_omp.representation_time;
fprintf('Representation time, SSC_OMP: %.4f, SSC_BATCH_OMP: %.4f\n', rptime1, rptime2);
fprintf('Gain: %.2f x\n', rptime1 / rptime2);
