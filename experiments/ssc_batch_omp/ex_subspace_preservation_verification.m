clearvars;
clc;
close all;
setup.num_points_per_cluster_list = [30 55 98 177 320 577 1041 1880 3396];
setup.num_points_per_cluster_list = [30 55 98 177 320 577 1041];
setup.rhos = setup.num_points_per_cluster_list / 6;
%disp(setup.rhos);
% Number of experiments
R= numel(setup.rhos);
setup.num_trials = 2;
% ambient space dimension
M = 10;
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
        trial.M = M;
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
        fprintf('\nTrial %d, Points per subspace: %d, Total points: %d\n', tt, trial.Sk, trial.S);
        % Let us generate uniformly distributed points in each subspace
        points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
        X = points_result.X;
        start_indices = points_result.start_indices;
        end_indices = points_result.end_indices;

        % Application of Sparse subspace clustering
        tstart = tic; 
        omp_solver = spx.cluster.ssc.SSC_OMP(X, trial.D, trial.K);
        result_omp = omp_solver.solve();
        trial.omp.elapsed_time = toc(tstart);
        trial.omp.repr_time = result_omp.representation_time;
        cluster_labels = result_omp.labels;
        % estimated number of clusters
        trial.omp.estimated_num_subspaces = result_omp.num_clusters;
        % true labels
        true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
        % graph connectivity
        trial.omp.connectivity = spx.cluster.spectral.simple.connectivity(result_omp.W, true_labels);
        % Time to compare the clustering
        comparsion_result = spx.cluster.clustering_error(cluster_labels, true_labels, trial.K);
        trial.omp.clustering_error_perc = comparsion_result.error_perc;
        trial.omp.clustering_acc_perc = 100 - comparsion_result.error_perc;
        % Compute the statistics related to subspace preservation
        spr_stats = spx.cluster.subspace.subspace_preservation_stats(result_omp.Z, cluster_sizes);
        trial.omp.spr_error = spr_stats.spr_error;
        trial.omp.spr_flag = spr_stats.spr_flag;
        trial.omp.spr_perc = spr_stats.spr_perc;
        %fprintf('\nPoint density: %0.2f: , clustering error: %0.2f %% , clustering accuracy: %0.2f %%, \n mean spr error: %0.2f preserving : %0.2f %%, connectivity: %0.2f, elapsed time: %0.2f sec\n', ...
        %    trial.rho, trial.omp.clustering_error_perc, trial.omp.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.omp.connectivity, trial.omp.elapsed_time);
        clear omp_solver;


        tstart = tic; 
        % Application of Sparse subspace clustering
        batch_omp_solver = spx.cluster.ssc.SSC_BATCH_OMP(X, trial.D, trial.K);
        result_batch_omp = batch_omp_solver.solve();
        trial.batch.elapsed_time = toc(tstart);
        trial.batch.repr_time = result_batch_omp.representation_time;
        cluster_labels = result_batch_omp.labels;
        % estimated number of clusters
        trial.batch.estimated_num_subspaces = result_batch_omp.num_clusters;
        % true labels
        true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
        % graph connectivity
        trial.batch.connectivity = spx.cluster.spectral.simple.connectivity(result_batch_omp.W, true_labels);
        % Time to compare the clustering
        comparsion_result = spx.cluster.clustering_error(cluster_labels, true_labels, trial.K);
        trial.batch.clustering_error_perc = comparsion_result.error_perc;
        trial.batch.clustering_acc_perc = 100 - comparsion_result.error_perc;
        % Compute the statistics related to subspace preservation
        spr_stats = spx.cluster.subspace.subspace_preservation_stats(result_batch_omp.Z, cluster_sizes);
        trial.batch.spr_error = spr_stats.spr_error;
        trial.batch.spr_flag = spr_stats.spr_flag;
        trial.batch.spr_perc = spr_stats.spr_perc;
        %fprintf('\nPoint density: %0.2f: , clustering error: %0.2f %% , clustering accuracy: %0.2f %%, \n mean spr error: %0.2f preserving : %0.2f %%, connectivity: %0.2f, elapsed time: %0.2f sec\n', ...
        %    trial.rho, trial.batch.clustering_error_perc, trial.batch.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.batch.connectivity, trial.batch.elapsed_time);
        clear batch_omp_solver;

        % C1 = full(omp_solver.Representation);
        % C2 = full(batch_omp_solver.Representation);
        % fprintf('Difference between representations: ');
        % max(max(abs(C1 - C2)))
        % D1 = full(omp_solver.Adjacency);
        % D2 = full(batch_omp_solver.Adjacency);
        % fprintf('Difference between adjacency matrices: %e\n', max(max(abs(D1 - D2))));
        fprintf('Clustering error: OMP: %0.3f %%, Batch OMP: %0.3f %%\n', ...
            trial.omp.clustering_error_perc, trial.batch.clustering_error_perc);
        t1 = trial.omp.elapsed_time;
        t2 = trial.batch.elapsed_time;
        fprintf('Total time: OMP: %0.3f s, Batch OMP: %0.3f s, Gain: %.2f\n', ...
            t1, t2, t1/t2);
        t1 = trial.omp.repr_time;
        t2 = trial.batch.repr_time;
        fprintf('Repr time: OMP: %0.3f s, Batch OMP: %0.3f s, Gain: %.2f\n', ...
            t1, t2, t1/t2);


    end
end

