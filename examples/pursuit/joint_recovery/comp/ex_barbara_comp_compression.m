clc;
close all;
clear all;


show_figures = true;

problem = SPX_RecoveryProblems.problem_barbara_blocks();
Phi = spx.dict.simple.spie_2011('orth');
blk_size = problem.blkSize;
signals = problem.signals;
signal_means = mean(signals);
signals = bsxfun(@minus, signals, signal_means);
zero_mean_image = col2im(signals, [blk_size, blk_size], size(problem.image) , 'distinct');
results = {};
Ks = 1:14;
nk = length(Ks);
psnrs = zeros(1, nk);
average_cluster_sizes = zeros(1, nk);
num_clusters = zeros(1, nk);
processing_times = zeros(1, nk);
for K=Ks
    tstart = tic;
    solver = SPX_ClusterOMP(Phi, K);
    result = solver.solve(signals);
    elapsed_time = toc(tstart);
    results{K} = result;
    representations = result.Z;
    approximations = Phi * representations;
    reconstructed_image = col2im(approximations, [blk_size, blk_size], size(problem.image) , 'distinct');
    residual = abs(zero_mean_image - reconstructed_image);
    mse = sum(sum(residual.^2)) / numel(problem.image);
    PSNR = 10 * log10 ( 255^2 / mse);

    psnrs(K) = PSNR;
    average_cluster_sizes(K) = mean(result.cluster_sizes);
    num_clusters(K) = result.num_clusters;
    processing_times(K) = elapsed_time;

    fprintf('\nK : %d\n', K);
    fprintf('Cluster OMP time spent: %.2f seconds\n', elapsed_time);
    fprintf('Cluster OMP support merger time: %.2f seconds\n', result.support_merger_time);
    fprintf('Cluster OMP net time: %.2f seconds\n', elapsed_time - result.support_merger_time);
    fprintf('PSNR : %.2f dB\n', PSNR);
    fprintf('Total number of blocks : %d\n', size(signals, 2));
    fprintf('Number of clusters : %d\n', result.num_clusters);
    fprintf('Average cluster size: %.4f\n', average_cluster_sizes(K));
    fprintf('Maximum cluster size: %d\n', max(result.cluster_sizes));
    fprintf('Minimum cluster size: %d\n', min(result.cluster_sizes));
    fprintf('Singleton clusters: %d\n', min(result.num_singletons));

end

if show_figures 

    mf = spx.graphics.Figures();

    mf.new_figure('Cluster OMP performance with K');

    subplot(2,2, 1);
    plot(Ks, psnrs);
    xlabel('K');
    ylabel('PSRN (dB)');
    title('K vs. PSNR');



    subplot(2,2, 2);
    plot(Ks, num_clusters);
    xlabel('K');
    ylabel('Clusters');
    title('K vs. Number of clusters');

    subplot(2,2, 3);
    plot(Ks, processing_times);
    xlabel('K');
    ylabel('Processing time (seconds)');
    title('K vs. Processing time');

    subplot(2,2, 4);
    plot(Ks, average_cluster_sizes);
    xlabel('K');
    ylabel('Average cluster size');
    title('K vs. Average cluster size');

end

