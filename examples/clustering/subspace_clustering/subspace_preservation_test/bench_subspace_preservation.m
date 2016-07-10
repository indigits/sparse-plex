function bench_subspace_preservation(solver, solver_name)

% Create the directory for storing data
spx.fs.ensure_dir('bin');

% We will carry out one experiment for each signal density level
setup.rhos = round(5.^[1:.4:5]);
setup.rhos = round(5.^[1:.2:3.2]);

% The following numbers have been picked up from the code provided by Chong You.
setup.num_points_per_cluster_list = [30 55 98 177 320 577 1041 1880 3396 6132 11075 20000];
%setup.num_points_per_cluster_list = [30 55 98 177 320 577];
setup.num_points_per_cluster_list = [30 55 98 177 320 577 1041 1880];
%setup.num_points_per_cluster_list = [30 55];
setup.rhos = setup.num_points_per_cluster_list / 6;
disp(setup.rhos);
% Number of experiments
R= numel(setup.rhos);

% Number of times each experiment should be run.
setup.num_trials = 20;
% store the overall experiment setup in a separate file.
save(sprintf('bin/bench_subspace_preservation_%s.mat', solver_name), 'setup');

for r=1:R
    rng(r);
    for tt=1:setup.num_trials
        % all data to be saved for a trial will be stored in a structure
        trial.rho = setup.rhos(r);
        % Trial number
        trial.trial = tt;
        % rho_index
        trial.rho_id = r;
        % Ambient space dimension
        trial.M = 9;
        % Number of subspaces
        trial.K = 5;
        % common dimension for each subspace
        trial.D = 6;
        % dimensions of each subspace
        Ds = trial.D * ones(1, trial.K);
        bases = spx.data.synthetic.subspaces.random_subspaces(trial.M, trial.K, Ds);
        % Number of points on each subspace
        trial.Sk = setup.num_points_per_cluster_list(r);
        cluster_sizes = trial.Sk * ones(1, trial.K);
        % total number of points
        trial.S = sum(cluster_sizes);
        fprintf('Trial %d, Points per subspace: %d, Total points: %d\n', tt, trial.Sk, trial.S);
        % Let us generate uniformly distributed points in each subspace
        points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
        X = points_result.X;
        start_indices = points_result.start_indices;
        end_indices = points_result.end_indices;
        tstart = tic;
        % Solve the sparse subspace clustering problem
        clustering_result = solver(X, trial.D, trial.K);
        trial.elapsed_time = toc (tstart);
        cluster_labels = clustering_result.labels;
        % graph connectivity
        trial.connectivity = clustering_result.connectivity;
        % estimated number of clusters
        trial.estimated_num_subspaces = clustering_result.num_clusters;
        % true labels
        true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
        % Time to compare the clustering
        comparsion_result = spx.cluster.clustering_error(cluster_labels, true_labels, trial.K);
        trial.clustering_error_perc = comparsion_result.error_perc;
        trial.clustering_acc_perc = 100 - comparsion_result.error_perc;
        % Compute the statistics related to subspace preservation
        spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
        trial.spr_error = spr_stats.spr_error;
        trial.spr_flag = spr_stats.spr_flag;
        trial.spr_perc = spr_stats.spr_perc;
        fprintf('\nPoint density: %0.2f: , clustering error: %0.2f %% , clustering accuracy: %0.2f %%, mean spr error: %0.2f preserving : %0.2f %%, connectivity: %0.2f, elapsed time: %0.2f sec', trial.rho, trial.clustering_error_perc, trial.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.connectivity, trial.elapsed_time);
        fprintf('\n\n');
        filepath = sprintf('bin/bench_subspace_preservation_%s_points=%d_trial=%d.mat', solver_name, trial.Sk, tt);
        save(filepath, 'trial');
    end
end


end
