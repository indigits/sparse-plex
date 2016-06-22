function simulate_subspace_preservation(solver, solver_name)


% Create the directory for storing results
spx.fs.ensure_dir('bin');
h = spx.data.motion.Hopkins155;
% pre-load all examples
h.load_all_examples();
examples = h.get_2_3_motions();
R = length(examples);
fprintf('Number of sequences: %d\n', R);


% We will carry out one experiment for each signal density level
estimated_singular_values = cell(1, R);
estimated_labels = cell(1, R);
true_labels = cell(1, R);
comparison_results = cell(1, R);
failed_examples = [];

for r=1:R
    tic;
    fprintf('Example (%d): ', r);
    example = examples{r};
    fprintf('%s, %d motions, %d points, %d frames\n', example.name, example.num_motions, example.num_points, example.num_frames);
    % Ambient space dimension
    M = example.M;
    % Number of subspaces
    K = example.num_motions;
    % maximum dimension for each subspace
    D = 4;
    Ss = example.counts;
    % total number of points
    S = sum(Ss);
    X = example.X;
    % homogenize
    % X = spx.la.affine.homogenize(X);
    % Solve the sparse subspace clustering problem
    try
        clustering_result = solver(X, D, K);
    catch ME
        % we will move on to next one
        fprintf('Problem in processing this example. %s: %s\n', ME.identifier, ME.message);
        % add to the list of failed examples
        failed_examples = [failed_examples r];
        % move on to next example
        continue;
    end
    cluster_labels = clustering_result.labels;
    estimated_labels{r} = cluster_labels;
    estimated_singular_values{r} = clustering_result.singular_values;
    cur_true_labels = example.labels;
    true_labels{r} = cur_true_labels;
    % Time to compare the clustering
    comparison_result = spx.cluster.clustering_error(cluster_labels, cur_true_labels, example.num_motions);
    comparison_results{r} = comparison_result;
    elapsed = toc;
    fprintf('\n error: %0.2f  %%, time taken: %0.2f seconds\n', comparison_result.error_perc, elapsed);
end
% clear some variables no more required.
clear example;
clear examples;
clear clustering_result;
clear comparison_result;
%  save rest of variables in file.
filepath = sprintf('bin/hopkins155_test_%s.mat', solver_name);
save(filepath);

end
