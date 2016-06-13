% In this example, we consider three disjoint subspaces.
% Any two of them span the third one.
% We take random points from each subspace
% We apply sparse subspace clustering algorithm
% to cluster them.
% We finally verify the labels assigned by the clustering
% algorithm with the true labels and measure the 
% quality of clustering using f-score.
clear all; close all; clc; rng('default');

shuffle_indices = false;
perform_sparse_subspace_clustering = true;

% Ambient space dimensions
D = 50;
% number of subspaces = number of clusters
ns = 3;
% subspace dimension
d = 4;
% Angle between subspaces A-B and B-C.
theta = 30; % in degree
% Let us form the subspaces
[A, B, C] = SPX_Spaces.three_disjoint_spaces_at_angle(deg2rad(theta), d); 
% Put them together
X = [A B C];
% Put them to bigger dimension
X = SPX_Spaces.k_dim_to_n_dim(X, D);
% Perform a random orthonormal transformation
O = orth(randn(D));
X = O * X;
% Split them again
A = X(:, 1:d);
B = X(:, d + (1:d));
C = X(:, 2*d + (1:d));
fprintf('Spaces after moving to n dimensions and an orthonormal transformation.\n');
% SPX_Spaces.describe_three_spaces(A, B, C);
% Number of points per subspace
Ng = 16*d;
% coefficients for Ng vectors chosen randomly in subspace A
coeffs_a = randn(d,Ng);
% avoid small values
coeffs_a = 2*sign(coeffs_a) + coeffs_a;
% coefficients for Ng vectors chosen randomly in subspace B
coeffs_b = randn(d,Ng);
% avoid small values
coeffs_b = 2*sign(coeffs_b) + coeffs_b;
% coefficients for Ng vectors chosen randomly in subspace C
coeffs_c = randn(d,Ng);
% avoid small values
coeffs_c = 2*sign(coeffs_c) + coeffs_c;
% Actual vectors from the three subspaces
XA = A * coeffs_a;
XB = B * coeffs_b;
XC = C * coeffs_c;
% Prepare the overall set of signals
X = [XA XB XC];
% ground through clustering data
true_labels = [1*ones(Ng,1) ; 2*ones(Ng,1) ; 3*ones(Ng,1)];
% All signals are expected to  have a K-sparse representation
if shuffle_indices
    % We also shuffle the signals
    shuffled_indices = randperm(3*Ng);
    X = X(:, shuffled_indices);
    true_labels = true_labels(shuffled_indices);
end
fprintf('Number of signals: %d\n', size(X, 2));

mf = spx.graphics.Figures();

if perform_sparse_subspace_clustering 
    tstart = tic; 
    % Application of Sparse subspace clustering
    ssc = SPX_SparseSubspaceClustering(X, d, ns);
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



