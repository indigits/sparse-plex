close all;
clear all;
clc;

% set number
r = 56;
num_subjects  = 2;
solver = @ssc_mc_omp;
% Create the directory for storing results
spx.fs.ensure_dir('bin');
yf = spx.data.image.ChongYaleFaces();
num_total_subjects = yf.num_subjects;
subject_list = [24 33];
fprintf('Subject set: ');
fprintf('%d ', subject_list);
fprintf('\n');
s1 = subject_list(1);
s2 = subject_list(2);

[Y, cluster_sizes, true_labels] = yf.data_for_subjects(subject_list);
Y = spx.norm.normalize_l2(Y);
faces_normalized = Y;

if false 
    fprintf('\n\n\n Statistics for the pair of subjects:\n\n');
    [M, S]  = size(faces_normalized);
    sizes = [64 64];
    angle_result = spx.cluster.subspace.nearest_same_subspace_neighbors_by_inner_product(faces_normalized, sizes);


    fprintf('Within Neighbor Counts:\n %s\n', spx.stats.format_descriptive_statistics(angle_result.within_neighbor_counts));
    fprintf('Nearest Within Neighbor Indices:\n %s\n', spx.stats.format_descriptive_statistics(angle_result.nearst_within_neighbor_indices));
    nearst_within_neighbor_indices = angle_result.nearst_within_neighbor_indices;
    % club all those cases where nearest within neighbor is far away.
    nearst_within_neighbor_indices(nearst_within_neighbor_indices > 5) = -1;
    tabulate(nearst_within_neighbor_indices);
    fprintf('First In Out Angle Spreads:\n %s\n', spx.stats.format_descriptive_statistics(angle_result.first_in_out_angle_spreads));
    fioas = angle_result.first_in_out_angle_spreads;
    %fioas = round(fioas * 10) / 10;
    fioas = round(fioas/4)*4;
    fioas(fioas > 8) = 100;
    fioas(fioas < -8) = 100;
    angle_gt_zero_flags = angle_result.first_in_out_angle_spreads >= 0;
    angle_gte_zero = angle_result.first_in_out_angle_spreads(angle_gt_zero_flags);
    angle_lte_two_flags =  angle_gte_zero <= 2;
    angle_lte_four_flags =  angle_gte_zero <= 4;
    angle_lte_eight_flags =  angle_gte_zero <= 8;
    angle_lt_zero_flags = angle_result.first_in_out_angle_spreads < 0;
    angle_lt_zero =  angle_result.first_in_out_angle_spreads(angle_lt_zero_flags);
    angle_gte_minus_two_flags =  angle_lt_zero >= -2;
    angle_gte_minus_four_flags =  angle_lt_zero >= -4;
    abs_angle_lte_four_flags = abs(angle_result.first_in_out_angle_spreads) <=4;
    fprintf('angle greater than equal to 0: %.2f %%\n', sum(angle_gt_zero_flags) * 100 / S);
    fprintf('angle less than 2: %.2f %%\n', sum(angle_lte_two_flags) * 100 / S);
    fprintf('angle less than 4: %.2f %%\n', sum(angle_lte_four_flags) * 100 / S);
    fprintf('angle less than 8: %.2f %%\n', sum(angle_lte_four_flags) * 100 / S);
    fprintf('angle less than 0: %.2f %%\n', sum(angle_lt_zero_flags) * 100 / S);
    fprintf('angle greater than -2: %.2f %%\n', sum(angle_gte_minus_two_flags) * 100 / S);
    fprintf('angle greater than -4: %.2f %%\n', sum(angle_gte_minus_four_flags) * 100 / S);
    fprintf('abs angle less than 4: %.2f %%\n', sum(abs_angle_lte_four_flags) * 100 / S);
end

mf = spx.graphics.Figures;
if true
    % Ambient space dimension and number of data points
    [trial.M, trial.S] = size(Y);
    % Number of subspaces
    trial.K = num_subjects;
    % maximum dimension for each subspace
    trial.D = 5;
    trial.cluster_sizes = cluster_sizes;
    % Solve the sparse subspace clustering problem
    tstart = tic;
    params.BranchingFactor = [.98 .95 .95 .95 .95];
    params.BranchingFactor = .98;
    params.BranchingFactor = [.98 .95 1 1 1];
    params.BranchingFactor = .998;
    %params.BranchingFactor = 1;
    params.MaxCandidatesToRetain = 4;
    try
        clustering_result = solver(Y, trial.D, trial.K, params);
    catch ME
        % we will move on to next one
        fprintf('Problem in processing this example. %s: %s\n', ME.identifier, ME.message);
        % move on to next example
        rethrow(ME);
        error('cannot continue.');
    end
    trial.elapsed_time = toc (tstart);
    % graph connectivity
    trial.connectivity = clustering_result.connectivity;
    % estimated number of clusters
    trial.estimated_num_subspaces = clustering_result.num_clusters;
    % Time to compare the clustering
    cluster_labels = clustering_result.labels;
    comparison_result = spx.cluster.clustering_error(cluster_labels, true_labels, trial.K);
    trial.clustering_error_perc = comparison_result.error_perc;
    trial.clustering_acc_perc = 100 - comparison_result.error_perc;
    % Compute the statistics related to subspace preservation
    spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, trial.cluster_sizes);
    trial.spr_error = spr_stats.spr_error;
    trial.spr_flag = spr_stats.spr_flag;
    trial.spr_perc = spr_stats.spr_perc;
    fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%, mean spr error: %0.2f preserving : %0.2f %%, connectivity: %0.2f, elapsed time: %0.2f sec', trial.clustering_error_perc, trial.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.connectivity, trial.elapsed_time);
    fprintf('\n\n');
    Z = full(abs(clustering_result.Z));
    s = spx.stats.format_descriptive_statistics(Z(:));
    fprintf(s);
    fprintf('\n');
    fprintf('Missed points: \n');
    fprintf('%d ', find(comparison_result.misses));
    fprintf('\n');
    mf.new_figure('Representations');
    imshow(Z);
end