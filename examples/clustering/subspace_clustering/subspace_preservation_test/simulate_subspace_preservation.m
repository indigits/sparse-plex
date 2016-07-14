function simulate_subspace_preservation(solver, solver_name, solver_params)
if nargin < 3
    solver_params = struct;
end

% We will carry out one experiment for each signal density level
rhos = round(5.^[1:.4:5]);
rhos = round(5.^[1:.4:3.5]);
% Number of experiments
R= numel(rhos);
estimated_num_subspaces = zeros(1, R);
estimated_coefficients = cell(1, R);
estimated_labels = cell(1, R);
true_labels = cell(1, R);
comparsion_results = cell(1, R);
connectivity = zeros(1, R);

% Create the directory for storing data
[status_code,message,message_id] = mkdir('bin');


for r=1:R
    rho = rhos(r);
    % Ambient space dimension
    M = 9;
    % Number of subspaces
    K = 5;
    % common dimension for each subspace
    D = 6;
    % dimensions of each subspace
    Ds = D * ones(1, K);
    bases = spx.data.synthetic.subspaces.random_subspaces(M, K, Ds);
    % Number of points on each subspace
    Sk = rho * D;
    Ss = Sk * ones(1, K);
    % total number of points
    S = sum(Ss);
    fprintf('Points per subspace: %d, Total points: %d\n', Sk, S);
    % Let us generate uniformly distributed points in each subspace
    points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, Ss);
    X = points_result.X;
    start_indices = points_result.start_indices;
    end_indices = points_result.end_indices;
    % Solve the sparse subspace clustering problem
    clustering_result = solver(X, D, K, solver_params);
    cluster_labels = clustering_result.labels;
    estimated_labels{r} = cluster_labels;
    % estimated_coefficients{r} = clustering_result.Z;
    estimated_num_subspaces(r) = clustering_result.num_clusters;
    cur_true_labels = spx.cluster.labels_from_cluster_sizes(Ss);
    true_labels{r} = cur_true_labels;
    % Time to compare the clustering
    comparer = spx.cluster.ClusterComparison(cur_true_labels, cluster_labels);
    comparsion_result = comparer.fMeasure();
    comparsion_results{r} = comparsion_result;
    connectivity(r) = spx.cluster.spectral.simple.connectivity(clustering_result.W, cur_true_labels);
    fprintf('\nPoint density: %0.2f: , fMeasure: %0.2f, connectivity: %0.2f  ', rho, comparsion_result.fMeasure, connectivity(r));
    if clustering_result.num_clusters == K
        fprintf('K: Success');
    else
        fprintf('K: Failure');
    end
    fprintf('\n\n');
end

filepath = sprintf('bin/subspace_preservation_test_%s.mat', solver_name);
save(filepath);

end
