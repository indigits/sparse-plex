function check_hopkins(solver, solver_name)


% Create the directory for storing results
spx.fs.ensure_dir('bin');
h = spx.data.motion.Hopkins155;
% pre-load all examples
h.load_all_examples();
examples = h.get_2_3_motions();
R = length(examples);
fprintf('Number of sequences: %d\n', R);


% We will carry out one experiment for each signal density level
test_result.failed_examples = [];
trials = cell(1, R);

for r=1:R
    trial = struct();
    fprintf('Example (%d): ', r);
    example = examples{r};
    fprintf('%s, %d motions, %d points, %d frames\n', example.name, example.num_motions, example.num_points, example.num_frames);
    % Ambient space dimension
    trial.M = example.M;
    % Number of subspaces
    trial.K = example.num_motions;
    % maximum dimension for each subspace
    trial.D = 5;
    trial.cluster_sizes = example.counts;
    % total number of points
    S = sum(trial.cluster_sizes);
    X = example.X;
    % homogenize
    X = spx.la.affine.homogenize(X);
    % Solve the sparse subspace clustering problem
    tstart = tic;
    try
        clustering_result = solver(X, trial.D, trial.K);
    catch ME
        % we will move on to next one
        fprintf('Problem in processing this example. %s: %s\n', ME.identifier, ME.message);
        % add to the list of failed examples
        test_result.failed_examples = [test_result.failed_examples r];
        % move on to next example
        continue;
    end
    trial.elapsed_time = toc (tstart);
    trial.singular_values = clustering_result.singular_values;
    % graph connectivity
    trial.connectivity = clustering_result.connectivity;
    % estimated number of clusters
    trial.estimated_num_subspaces = clustering_result.num_clusters;
    % Time to compare the clustering
    cluster_labels = clustering_result.labels;
    true_labels = example.labels;
    comparsion_result = spx.cluster.clustering_error(cluster_labels, true_labels, trial.K);
    trial.clustering_error_perc = comparsion_result.error_perc;
    trial.clustering_acc_perc = 100 - comparsion_result.error_perc;
    % Compute the statistics related to subspace preservation
    spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, trial.cluster_sizes);
    trial.spr_error = spr_stats.spr_error;
    trial.spr_flag = spr_stats.spr_flag;
    trial.spr_perc = spr_stats.spr_perc;
    fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.2f preserving : %0.2f %%\n, connectivity: %0.2f, elapsed time: %0.2f sec', trial.clustering_error_perc, trial.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.connectivity, trial.elapsed_time);
    fprintf('\n\n');
    trials{r} = trial;
end
% clear some variables no more required.
clear trial;
clear h;
clear clustering_result;
clear comparison_result;
%  save rest of variables in file.
filepath = sprintf('bin/hopkins155_test_%s.mat', solver_name);
save(filepath);

end
