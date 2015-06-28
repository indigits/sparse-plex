function result = SimulateSSCOMP_3Spaces(D, K, Ng, theta, SNR, shuffle)
% Simulates SSC-OMP algorithm
% D - Ambient space dimension
% K - Subspace dimension
% Ng - Number of vectors per subspace
% theta - angle between disjoint subspaces
% shuffle - whether to shuffle the vectors or not.

    if nargin < 6
        shuffle = false;
    end
    if nargin < 5
        SNR = Inf;
    end
    % number of subspaces = number of clusters
    ns = 3;
    % Let us form the subspaces
    [A, B, C] = SPX_Spaces.three_disjoint_spaces_at_angle(deg2rad(theta), K); 
    % Put them together
    X = [A B C];
    % Put them to bigger dimension
    X = SPX_Spaces.k_dim_to_n_dim(X, D);
    % Perform a random orthonormal transformation
    O = orth(randn(D));
    X = O * X;
    % Split them again
    A = X(:, 1:K);
    B = X(:, K + (1:K));
    C = X(:, 2*K + (1:K));
    % coefficients for Ng vectors chosen randomly in subspace A
    coeffs_a = randn(K,Ng);
    % avoid small values
    coeffs_a = 2*sign(coeffs_a) + coeffs_a;
    % coefficients for Ng vectors chosen randomly in subspace B
    coeffs_b = randn(K,Ng);
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
    if shuffle
        % We also shuffle the signals
        shuffled_indices = randperm(3*Ng);
        X = X(:, shuffled_indices);
        true_labels = true_labels(shuffled_indices);
    end
    if ~isinf(SNR)
        % We need to add some noise in the signals.
        noises = SPX_NoiseGen.createNoise(X, SNR);
        % Preserve original data
        X0 = X;
        % Add noise
        X = X0 + noises;
    end
    % Keep data for reference.
    result.num_subspaces = 3;
    result.theta = theta;
    result.subspace_dimension = K;
    result.ambient_dimension = D;
    result.num_signals_per_subspace = Ng;
    result.num_total_signals = size(X, 2);
    result.true_labels = true_labels;
    result.X = X;

    tstart = tic; 
    % Application of Sparse subspace clustering
    solver = SPX_SSC_OMP(X, K, ns);
    solver.Quiet = true;
    ssc_result = solver.solve();
    elapsed_time = toc(tstart);
    result.elapsed_time = elapsed_time;
    result.C = solver.Representation;
    % fprintf('Sparse subspace clustering time spent: %.2f seconds\n', elapsed_time);

    cluster_labels = ssc_result.Labels;
    %combined_labels = [true_labels cluster_labels]';
    result.cluster_labels = cluster_labels;

    % Time to compare the clustering
    comparer = SPX_ClusterComparison(true_labels, cluster_labels);
    result.comparison = comparer.fMeasure();
    % fprintf('Sparse subspace clustering results:\n');
    % comparer.printF1MeasureResult(result.comparison);
end