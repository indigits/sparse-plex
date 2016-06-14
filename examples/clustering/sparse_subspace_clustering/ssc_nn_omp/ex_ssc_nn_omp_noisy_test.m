clear all;
close all;
clc;

% We will carry out one experiment for each sigma level
noise_sigma_levels = [ 0:0.05:0.8] ;
% Number of experiments
R= numel(noise_sigma_levels);
estimated_num_subspaces = zeros(1, R);
estimated_coefficients = cell(1, R);
estimated_singular_values = cell(1, R);
estimated_labels = cell(1, R);

% Create the directory for storing data
[status_code,message,message_id] = mkdir('bin');


for r=1:R
    sigma = noise_sigma_levels(r);
    % Ambient space dimension
    M = 50;
    % Number of subspaces
    K = 10;
    % common dimension for each subspace
    D = 20;
    % dimensions of each subspace
    Ds = D * ones(1, K);
    bases = spx.data.synthetic.subspaces.random_subspaces(M, K, Ds);
    % Number of points on each subspace
    Sk = 4 * D;
    Ss = Sk * ones(1, K);
    % total number of points
    S = sum(Ss);
    % Let us generate uniformly distributed points in each subspace
    points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, Ss);
    X0 = points_result.X;
    start_indices = points_result.start_indices;
    end_indices = points_result.end_indices;
    Noise = sigma * spx.data.signals.simple.uniform(M, S);
    % Add noise to signal
    X = X0 + Noise;
    % Normalize noisy signals.
    X = spx.commons.norm.normalize_l2(X); 
    % Solve the sparse subspace clustering problem
    solver = spx.cluster.ssc.SSC_NN_OMP(X, D, K);
    clustering_result = solver.solve();
    cluster_labels = clustering_result.labels;
    estimated_labels{r} = cluster_labels;
    estimated_singular_values{r} = clustering_result.singular_values;
    estimated_coefficients{r} = clustering_result.Z;
    estimated_num_subspaces(r) = clustering_result.num_clusters;
    fprintf('Noise level: %0.2f: ', sigma);
    if clustering_result.num_clusters == K
        fprintf('Success\n');
    else
        fprintf('Failure\n');
    end
end

save(sprintf('bin/ssc_mahdi_noise_test.mat'));
