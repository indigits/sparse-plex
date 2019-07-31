clc;
clearvars;
close all;
rng default;

[X, K, cluster_sizes, true_labels] = prepare_data(true);

fprintf('Computing Low Rank Subspace Clustering\n');

tstart = tic;
% Apply low rank subspace clustering
[A2, C2] = spx.cluster.lrsc.noisy_relaxed(X);
elapsed_time = toc(tstart);
fprintf('SPX Version Time taken: %.2f seconds\n', elapsed_time);

fprintf('Performing clustering: \n');
tstart = tic;
% Adjacency matrix
W = abs(C2);
clustering_result = spx.cluster.spectral.simple.normalized_symmetric_sparse(W, K);
%clustering_result = spx.cluster.spectral.simple.normalized_symmetric_fast(W, K);
cluster_labels = clustering_result.labels;
elapsed_time = toc(tstart);
fprintf('Time taken: %.2f seconds \n', elapsed_time);
comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
clustering_error_perc = comparsion_result.error_perc;
clustering_acc_perc = 100 - comparsion_result.error_perc;

fprintf('\nclustering error: %0.2f %%, clustering accuracy: %0.2f %% \n'...
    , clustering_error_perc, clustering_acc_perc);
