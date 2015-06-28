% Tests sparse subspace clustering algorithm
function test_suite = test_ssc
  initTestSuite;
end


function test_1
    % dimension of ambient space
    n = 30;
    % number of subspaces = number of clusters
    ns = 2;
    % dimensions of individual subspaces 1 and 2
    d1  = 1;
    d2 = 1;
    % number of signals in individual subspaces
    s1 = 20;
    s2 = 20;
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
    % ground through clustering data
    true_labels = [1*ones(s1,1) ; 2*ones(s2,1)];
    % the largest dimension amongst all subspaces
    K = max(d1, d2);
    % All signals are expected to  have a K-sparse representation
    ssc = SPX_SparseSubspaceClustering(X, K, ns);
    result = ssc.solve();
    cluster_labels = result.Labels;
    combined_labels = [true_labels cluster_labels]';

    % Time to compare the clustering
    comparer = SPX_ClusterComparison(true_labels, cluster_labels);
    result = comparer.fMeasure();
    assertElementsAlmostEqual(result.fMeasure, 1.0);
end
