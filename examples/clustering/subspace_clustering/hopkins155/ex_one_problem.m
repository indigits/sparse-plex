close all;
clear all;
clc;

% Create the directory for storing results
spx.fs.ensure_dir('bin');

% set number
r = 1;
h = spx.data.motion.Hopkins155;
% pre-load all examples
h.load_all_examples();
examples = h.get_2_3_motions();
example = examples{r};
solver = @ssc_mc_omp;

Y = example.X;
% homogenize
Y = spx.la.affine.homogenize(Y);
Y = spx.commons.norm.normalize_l2(Y);
Y = Y;

if true 
    fprintf('\n\n\n Statistics for the pair of motions:\n\n');
    [M, S]  = size(Y);
    sizes = example.counts;
    angle_result = spx.cluster.subspace.nearest_same_subspace_neighbors_by_inner_product(Y, sizes);
    spx.cluster.subspace.print_nearest_neighbor_result(angle_result);

end

mf = spx.graphics.Figures;
if true
    % Ambient space dimension and number of data points
    [trial.M, trial.S] = size(Y);
    % Number of subspaces
    trial.K = example.num_motions;
    % maximum dimension for each subspace
    trial.D = 3;
    trial.cluster_sizes = example.counts;
    % Solve the sparse subspace clustering problem
    tstart = tic;
    try
        clustering_result = solver(Y, trial.D, trial.K);
    catch ME
        % we will move on to next one
        fprintf('Problem in processing this example. %s: %s\n', ME.identifier, ME.message);
        % move on to next example
        error('cannot continue.');
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
    fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%,\n mean spr error: %0.2f preserving : %0.2f %%,\n connectivity: %0.2f, elapsed time: %0.2f sec', trial.clustering_error_perc, trial.clustering_acc_perc, spr_stats.spr_error, spr_stats.spr_perc, trial.connectivity, trial.elapsed_time);
    fprintf('\n\n');
    Z = abs(clustering_result.Z);
    s = spx.stats.format_descriptive_statistics(Z(:));
    fprintf(s);
    fprintf('\n');
    mf.new_figure('Representations');
    imshow(Z);
end