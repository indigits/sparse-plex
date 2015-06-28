clear all; close all; clc;
rng('default');

% Some flags to control the demo
perform_sparse_representation_clustering  = true;
perform_sparse_subspace_clustering = true;
% recovery algorithm for sparse representation clustering
src_recovery_algo = 'omp'; % 'omp' or 'l1'
shuffle_indices = false;


% dimension of ambient space
n = 40;
% dictionary size
d = 100;

% Construct a Gaussian dictionary
Dict = SPX_SimpleDicts.gaussian_mtx(n, d);
% number of subspaces = number of clusters
ns = 2;
% dimensions of individual subspaces 1 and 2
d1  = 4;
d2 = 4;
% Total dimensions
d_sum = d1 + d2;
% Choose specific atoms from the dictionary for constructing the bases
indices = randperm(d, d_sum);
% number of signals in individual subspaces
s1 = 20;
s2 = 20;
% total number of signals
s = s1 + s2;
% A random basis for first subspace;
indices1 = indices(1:d1);
basis1 = Dict(:, indices1);
% A random basis for second subspace
indices2 = indices(d1+1:end);
basis2 =  Dict(:, indices2);
% coefficients for s1 vectors chosen randomly in subspace 1
coeffs1 = randn(d1,s1);
% avoid small values
coeffs1 = 2*sign(coeffs1) + coeffs1;
% Random signals from first subspace
X1 = basis1 * coeffs1;
% coefficients for s2 vectors chosen randomly in subspace 2
coeffs2 = randn(d2,s2);
% avoid small values
coeffs2 = 2*sign(coeffs2) + coeffs2;
% Random signals from first subspace
X2 = basis2 * coeffs2;
% Prepare the overall set of signals
X = [X1 X2];
% ground through clustering data
true_labels = [1*ones(s1,1) ; 2*ones(s2,1)];
% the largest dimension amongst all subspaces
K = max(d1, d2);

% Capture coefficient data into true representation vectors
true_reps  = zeros(d, s1 + s2);
true_reps(indices1, 1:s1) = coeffs1;
true_reps(indices2, s1 + 1:end) = coeffs2;

% All signals are expected to  have a K-sparse representation
if shuffle_indices
    % We also shuffle the signals
    shuffled_indices = randperm(s);
    X = X(:, shuffled_indices);
    true_labels = true_labels(shuffled_indices);
end

mf = SPX_Figures();

if perform_sparse_representation_clustering
    tstart = tic; 
    % We will now go for sparse representation clustering
    if strcmp(src_recovery_algo, 'omp')
        omp_solver = SPX_OrthogonalMatchingPursuit(Dict, K);
        solutions = omp_solver.solve_all_linsolve(X);
        representations = solutions.Z;
    elseif strcmp(src_recovery_algo ,'l1')
        l1_solver = SPX_L1SparseRecovery(Dict, X);
        representations = l1_solver.solve_l1_noise();
        % We will threshold out unnecessary stuff
        % representations = SPX_SparseSignalsComparison.sparse_approximation(representations, K);
    else
        error('Unknown recovery algorithm specified.');
    end
    comparer = SPX_SparseSignalsComparison(true_reps, representations, K);
    ss_ratios = comparer.support_similarity_ratios();
    fprintf('Support similarity ratios: ');
    disp(ss_ratios);
    failures = sum(ss_ratios < 1);
    fprintf('Recovery failures: %d (%.2f)\n', failures, failures/s);

    src = SPX_SparseRepClustering(representations, K, ns);
    result = src.solve();
    elapsed_time = toc(tstart);
    fprintf('Sparse representation clustering time spent: %.2f seconds\n', elapsed_time);

    src_cluster_labels = result.Labels;
    src_combined_labels = [true_labels src_cluster_labels]';
    disp(src_combined_labels);

    % Time to compare the clustering
    comparer = SPX_ClusterComparison(true_labels, src_cluster_labels);
    result = comparer.fMeasure();
    fprintf('Sparse representation clustering results:\n');
    comparer.printF1MeasureResult(result);

    mf.new_figure('SRC Adjacency matrix');
    colormap gray;
    imagesc(abs(src.Adjacency));
end


if perform_sparse_subspace_clustering 
    tstart = tic; 
    % Application of Sparse subspace clustering
    ssc = SPX_SparseSubspaceClustering(X, K, ns);
    result = ssc.solve();
    elapsed_time = toc(tstart);
    fprintf('Sparse subspace clustering time spent: %.2f seconds\n', elapsed_time);

    cluster_labels = result.Labels;
    combined_labels = [true_labels cluster_labels]';
    disp(combined_labels);

    % Time to compare the clustering
    comparer = SPX_ClusterComparison(true_labels, cluster_labels);
    result = comparer.fMeasure();
    fprintf('Sparse subspace clustering results:\n');
    comparer.printF1MeasureResult(result);

    mf.new_figure('SSC Coefficients');
    colormap gray;
    imagesc(abs(ssc.Representation));
end

