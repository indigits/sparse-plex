clc;
close all;
if ~exist('md', 'var')
    clear all;
    md = spx.data.image.ChongMNISTDigits;
end
% initialize the random number generator for repeatability
rng('default');
digit_set = 0:9;
num_samples_per_digit = 600;
K = length(digit_set);
% Number of subspaces
K = K;
cluster_sizes = num_samples_per_digit*ones(1, K);
cluster_sizes = cluster_sizes;
% maximum dimension for each subspace
D = 10;
S = sum(cluster_sizes);
% identify sample indices for each digit
sample_list = [];
for k=1:K
    digit = digit_set(k);
    fprintf('Loading samples for: %d\n', digit);
    digit_indices = md.digit_indices(digit);
    num_digit_samples = length(digit_indices);
    choices = randperm(num_digit_samples, cluster_sizes(k));
    selected_indices = digit_indices(choices);
    % fprintf('%d ', selected_indices);
    % fprintf('\n');
    sample_list = [sample_list selected_indices];
end
[Y, true_labels] = md.selected_samples(sample_list);
% disp(Y(1:10, 1)');
% Perform PCA to reduce dimensionality
fprintf('Performing PCA\n');
tstart = tic;
Y = spx.la.pca.low_rank_approx(Y, 500);
elapsed_time = toc(tstart);
fprintf('Time taken in computing PCA: %.2f seconds\n', elapsed_time);
