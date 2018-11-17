function final_result = check_yale_faces(num_subjects, solver, solver_name, solver_params)
if nargin < 4
    solver_params = struct;
end


% Create the directory for storing results
spx.fs.ensure_dir('bin');
yf = spx.data.image.ChongYaleFaces();
num_total_subjects = yf.num_subjects;

% R = yf.num_experiments_of_n_subjects(num_subjects);
if num_subjects == 38
    R = 1;
else
    R = 20;
end
fprintf('Number of subject sets: %d\n', R);


% We will carry out one experiment for each signal density level
test_result.failed_examples = [];
trials = cell(1, R);

for r=1:R
    trial = struct();
    rng(r * 38 + num_subjects);
    subject_list = randperm(num_total_subjects, num_subjects) % select #nCluster subjects
    fprintf('Subject set (%d): ', r);
    fprintf('%d ', subject_list);
    fprintf('\n');
    % [Y, cluster_sizes, true_labels] = yf.experiment_data(num_subjects, r);
    [Y, cluster_sizes, true_labels] = yf.data_for_subjects(subject_list);
    % Normalize the columns
    Y = spx.norm.normalize_l2(Y);
    % Ambient space dimension and number of data points
    [trial.M, trial.S] = size(Y);
    % Number of subspaces
    trial.K = num_subjects;
    % maximum dimension for each subspace
    trial.D = 5;
    trial.cluster_sizes = cluster_sizes;
    % Solve the sparse subspace clustering problem
    tstart = tic;
    try
        clustering_result = solver(Y, trial.D, trial.K, solver_params);
    catch ME
        % we will move on to next one
        fprintf('Problem in processing this example. %s: %s\n', ME.identifier, ME.message);
        % add to the list of failed examples
        test_result.failed_examples = [test_result.failed_examples r];
        % move on to next example
        continue;
    end
    trial.elapsed_time = toc (tstart);
    % graph connectivity
    trial.connectivity = clustering_result.connectivity;
    % estimated number of clusters
    trial.estimated_num_subspaces = clustering_result.num_clusters;
    % Time to compare the clustering
    cluster_labels = clustering_result.labels;
    comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, trial.K);
    trial.clustering_error_perc = comparsion_result.error_perc;
    trial.clustering_acc_perc = 100 - comparsion_result.error_perc;
    % Compute the statistics related to subspace preservation
    spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, trial.cluster_sizes);
    trial.spr_error = spr_stats.spr_error;
    trial.spr_flag = spr_stats.spr_flag;
    trial.spr_perc = spr_stats.spr_perc;
    fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.4f preserving : %0.2f %%\n, connectivity: %0.2f, elapsed time: %0.2f sec', trial.clustering_error_perc, trial.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.connectivity, trial.elapsed_time);
    fprintf('\n\n');
    trials{r} = trial;
end
% clear some variables no more required.
clear trial;
clear yf;
clear clustering_result;
clear comparison_result;
%  save rest of variables in file.
filepath = sprintf('bin/yale_faces_%d_subjects_test_%s.mat', num_subjects, solver_name);
save(filepath);
final_result = merge_results(num_subjects, solver_name);
end
