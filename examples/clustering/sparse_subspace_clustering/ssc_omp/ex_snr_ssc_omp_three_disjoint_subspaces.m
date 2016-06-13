% In this example, we consider three disjoint subspaces.
% Any two of them span the third one.
% We take random points from each subspace
% We apply sparse subspace clustering 
% via orthogonal matching pursuit algorithm
% to cluster them.
% We finally verify the labels assigned by the clustering
% algorithm with the true labels and measure the 
% quality of clustering using f-score.

clear all; close all; clc; rng('default');

shuffle_indices = false;
perform_ssc_omp = true;
perform_ssc_nn_omp= true;
SNR = 8;
% Ambient space dimensions
D = 50;
% number of subspaces = number of clusters
ns = 3;
% subspace dimension
K = 4;
% Angle between subspaces A-B and B-C.
theta = 30; % in degree
% Let us form the subspaces
[A, B, C] = spx.la.spaces.three_disjoint_spaces_at_angle(K, deg2rad(theta)); 
% Put them together
X = [A B C];
% Put them to bigger dimension
X = spx.la.spaces.k_dim_to_n_dim(X, D);
% Perform a random orthonormal transformation
O = orth(randn(D));
X = O * X;
% Split them again
A = X(:, 1:K);
B = X(:, K + (1:K));
C = X(:, 2*K + (1:K));
fprintf('Spaces after moving to n dimensions and an orthonormal transformation');
spx.la.spaces.describe_three_spaces(A, B, C);
% Number of points per subspace
Ng = 16*K;
% coefficients for Ng vectors chosen randomly in subspace A
coeffs_a = randn(K,Ng);
% avoid small values
coeffs_a = 2*sign(coeffs_a) + coeffs_a;
% coefficients for Ng vectors chosen randomly in subspace B
coeffs_b = randn(K,Ng);
% avoid small values
coeffs_b = 2*sign(coeffs_b) + coeffs_b;
% coefficients for Ng vectors chosen randomly in subspace C
coeffs_c = randn(K,Ng);
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
% We need to add some noise in the signals.
noises = spx.data.noise.Basic.createNoise(X, SNR);
% Preserve original data
X0 = X;
% Add noise
X = X0 + noises;

mf = spx.graphics.Figures();


if perform_ssc_omp 
    tstart = tic; 
    % Application of Sparse subspace clustering
    solver = SPX_SSC_OMP(X, K, ns);
    result = solver.solve();
    elapsed_time = toc(tstart);
    fprintf('SSC OMPtime spent: %.2f seconds\n', elapsed_time);

    cluster_labels = result.Labels;
    combined_labels = [true_labels cluster_labels]';
    %disp(combined_labels);

    % Time to compare the clustering
    comparer = spx.cluster.ClusterComparison(true_labels, cluster_labels);
    result = comparer.fMeasure();
    fprintf('Sparse subspace clustering results:\n');
    comparer.printF1MeasureResult(result);

    mf.new_figure('SSC-OMP Coefficients');
    colormap gray;
    imagesc(abs(solver.Representation));
end


if perform_ssc_nn_omp 
    tstart = tic; 
    % Application of Sparse subspace clustering
    solver = SPX_SSC_NN_OMP(X, K, ns);
    result = solver.solve();
    elapsed_time = toc(tstart);
    fprintf('SSC NN OMP time spent: %.2f seconds\n', elapsed_time);

    cluster_labels = result.Labels;
    combined_labels = [true_labels cluster_labels]';
    %disp(combined_labels);

    % Time to compare the clustering
    comparer = spx.cluster.ClusterComparison(true_labels, cluster_labels);
    result = comparer.fMeasure();
    fprintf('Sparse subspace clustering results:\n');
    comparer.printF1MeasureResult(result);

    mf.new_figure('SSC-OMP Coefficients');
    colormap gray;
    imagesc(abs(solver.Representation));
end


