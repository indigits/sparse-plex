% Demonstrates the effectiveness of sparse representation clustering
% on blocks from Barbara image using the orth dictionary from SPIE 2011
% paper.

clc;
close all;
clear all;
problem = SPX_RecoveryProblems.problem_barbara_blocks();
Phi = SPX_SimpleDicts.spie_2011('orth');
K = 12;
% the 8x8 blocks to be compressed.
signals = problem.signals;
signal_means = mean(signals);
signals = bsxfun(@minus, signals, signal_means);
% zero_mean_image = col2im(signals, [problem.blkSize, problem.blkSize], size(problem.image) , 'distinct');
signals = signals(:, 1:100);
tstart = tic;
proxies = Phi.apply_ctranspose(signals);
[d, s] = size(proxies);
tmp = abs(proxies);
[~, indices] = sort(tmp, 'descend');
proxies2 = zeros(d, s);
% Preserve appropriate part of the proxy
for i=1:s
    ind = indices(1:2*K, i);
    proxies2(ind, i)  = proxies(ind,i);
end
% We identify the support for largest 2K entries
%proxies(indices(5:end, :)) = 0;
proxy_time = toc(tstart);
NumClusters = 20;
src = SPX_SparseRepClustering(proxies2, -1 , NumClusters);
src.SpectralKMeansMaxIter = 1000;
src.SpectralKMeansReplications  = 2;
clustering_result = src.solve();
elapsed_time = toc(tstart);
fprintf('Sparse representation clustering time spent: %.2f seconds\n', elapsed_time);
fprintf('Proxy time spent: %.8f seconds\n', proxy_time);
fprintf('SVD time spent: %.8f seconds\n', src.Spectral.SVDTime);
fprintf('K-means time spent: %.8f seconds\n', src.Spectral.KMeansTime);


% Now perform full OMP recovery
tstart = tic;
omp = spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K);
omp.StopOnResidualNorm = false;
omp.StopOnResNormStable = false;
result = omp.solve_all_linsolve(signals);
omp_elapsed_time = toc(tstart);
representations = result.Z;
fprintf('OMP recovery time spent: %.8f seconds\n', src.Spectral.KMeansTime);
