%Y = spx.norm.normalize_l2(Y);
% Ambient space dimension and number of data points
[M, S] = size(Y);
% Solve the sparse subspace clustering problem
rng('default');
tstart = tic;
rnorm_thr = 1e-3;
method = spx.cluster.ssc.OMP_REPR_METHOD.CLASSIC_OMP_C;
method = spx.cluster.ssc.OMP_REPR_METHOD.BATCH_OMP_C;
method = spx.cluster.ssc.OMP_REPR_METHOD.FLIPPED_OMP_MATLAB;
solver = spx.cluster.ssc.SSC_OMP(Y, D, K, rnorm_thr, method);
clustering_result = solver.solve();
elapsed_time = toc (tstart);
% Time to compare the clustering
cluster_labels = clustering_result.labels;
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;
% Compute the statistics related to subspace preservation
spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;
fprintf('\nClustering time: %.2f, Representation time: %.2f\n', clustering_result.clustering_time, clustering_result.representation_time);
fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.4f preserving : %0.2f %%, elapsed time: %0.2f sec',...
    clustering_error_perc, clustering_acc_perc,...
    spr_stats.spr_error, spr_stats.spr_perc,...
    elapsed_time);
fprintf('\n\n');

Y2 = Y * solver.Representation;
fprintf('Max reconstruction error %.3f\n', max(spx.norm.norms_l2_cw(Y - Y2)));

if 1
fprintf('Running Chong You Implementation\n');
rng('default');
tstart = tic;
% representation     
buildRepresentation = @(data) OMP_mat_func(data, D, rnorm_thr^2); % second parameter is sparsity
% spectral clustering       
genLabel = @(affinity, nCluster) SpectralClustering(affinity, nCluster, 'Eig_Solver', 'eigs');
R = buildRepresentation(Y);
R(1:S+1:end) = 0;
Y3 = Y * R;
fprintf('Max reconstruction error %.3f\n', max(spx.norm.norms_l2_cw(Y - Y3)));

R2 = cnormalize(R, Inf);
A = abs(R2) + abs(R2)';
% generate label
%     fprintf('Generate label...\n')
cluster_labels = genLabel(A, K);       
elapsed_time = toc (tstart);   
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;
spr_stats = spx.cluster.subspace.subspace_preservation_stats(R, cluster_sizes);
spr_error = spr_stats.spr_error;
spr_flag = spr_stats.spr_flag;
spr_perc = spr_stats.spr_perc;
fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.4f preserving : %0.2f %%, elapsed time: %0.2f sec\n',...
    clustering_error_perc, clustering_acc_perc,...
    spr_stats.spr_error, spr_stats.spr_perc, elapsed_time);
fprintf('\n\n');
end

n = sum(sum(abs(solver.Representation - R) > .1));
fprintf('Representation mismatches: %d\n', full(n));
n = sum(sum(abs(solver.Adjacency - A) > .1));
fprintf('Adjacency mismatches: %d\n', full(n));
