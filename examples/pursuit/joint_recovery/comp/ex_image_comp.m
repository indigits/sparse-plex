% Make sure that all the mentioned images below are
% available in the standard_test_images_dir 
% as configured in spx_local.ini file.
% See SPX_RecoveryProblems.problem_test_image_blocks
% for details on how these images are loaded.
clc;
close all;
clear all;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');


image_names = {'barbara', 'cameraman', 'house',...
'jetplane', 'lake', 'lena', 'livingroom', 'mandril',...
'peppers', 'pirate', 'walkbridge', 'blonde', 'darkhair'};
show_figures = true;

image_name = 'cameraman';
% ahoc, data, orth, rand, sine, rlsdla
dict_name = 'rlsdla';
problem = SPX_RecoveryProblems.problem_test_image_blocks(image_name);
Phi = spx.dict.simple.spie_2011(dict_name);
blk_size = problem.blkSize;
signals = problem.signals;
signal_means = mean(signals);
signals = bsxfun(@minus, signals, signal_means);
zero_mean_image = col2im(signals, [blk_size, blk_size], size(problem.image) , 'distinct');
tstart = tic;
K = 8;
solver = SPX_ClusterOMP(Phi, K);
result = solver.solve(signals);
elapsed_time = toc(tstart);
representations = result.Z;
approximations = Phi * representations;
reconstructed_image = col2im(approximations, [blk_size, blk_size], size(problem.image) , 'distinct');
residual = abs(zero_mean_image - reconstructed_image);
mse = sum(sum(residual.^2)) / numel(problem.image);
PSNR = 10 * log10 ( 255^2 / mse);

stats = result.stats;
stats.psnrs = zeros(1, K);
stats.mse = stats.residual_frob_norms.^2 / numel(signals);
stats.psnrs =  10 * log10(255^2 ./ stats.mse);


fprintf('\nK : %d\n', K);
fprintf('Cluster OMP time spent: %.2f seconds\n', elapsed_time);
fprintf('Cluster OMP support merger time: %.2f seconds\n', result.support_merger_time);
fprintf('Cluster OMP net time: %.2f seconds\n', elapsed_time - result.support_merger_time);
fprintf('PSNR : %.2f dB\n', PSNR);
fprintf('Total number of blocks : %d\n', size(signals, 2));
fprintf('Number of clusters : %d\n', result.num_clusters);
fprintf('Average cluster size: %.4f\n', stats.avg_cluster_sizes(end));
fprintf('Maximum cluster size: %d\n', max(result.cluster_sizes));
fprintf('Minimum cluster size: %d\n', min(result.cluster_sizes));
fprintf('Singleton clusters: %d\n', min(result.num_singletons));

stats
result.stats = stats;
data_file_name = sprintf('bin/%s_%s_distinct_K_%d.mat', image_name, dict_name, K);
save(data_file_name, 'result');