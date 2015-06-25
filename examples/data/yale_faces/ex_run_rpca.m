%%% This example depends on 
% LRS library https://github.com/andrewssobral/lrslibrary
% It uses a specific algorithm called Robust Principal Component Analysis

close all; clear all; clc;
% Load the Yale face images
yf = SPX_YaleFaces();
yf.load();
ns = yf.num_subjects();
ni = yf.ImagesToLoadPerSubject;
image_size = 192 * 168;
num_images = ns * ni;
% Storage for images after Robust PCA
rpca_images = zeros(image_size, num_images);
rpca_svds = zeros(ni, ns);
start_idx  = 0;
for i=1:ns
    fprintf('Processing subject no: %d\n', i);
    % Get all images for a specific subject
    Y = yf.get_subject_images(i);
    fprintf('\n Computing SVD\n');
    tstart = tic;
    s_orig = svd(Y);
    elapsed = toc(tstart);
    fprintf('Time taken: %.2f seconds \n', elapsed);
    fprintf('\n Computing RPCA\n');
    tstart = tic;
    % Perform Robust PCA on all images from one subject
    results = process_matrix('RPCA', 'PCP', Y, []);
    elapsed = toc(tstart);
    fprintf('Time taken: %.2f seconds \n', elapsed);
    show_results(Y,results.L,results.S,results.O, 50, 192, 168);
    % Copy the images after RPCA
    rpca_images(:, start_idx + (1:ni)) = results.L;
    start_idx = start_idx + ni;
    fprintf('\n Computing SVD\n');
    tstart = tic;
    % Compute the SVD for these images
    s_rpca = svd(results.L);
    elapsed = toc(tstart);
    fprintf('Time taken: %.2f seconds \n', elapsed);
    rpca_svds(:, i) = s_rpca;
    subplot(211);
    plot(s_orig);
    subplot(212);
    plot(s_rpca);
    pause(.5);
end
% Maintain the RPCA-ed images in a cache.
save('bin/yale_rpca_cache.mat', 'rpca_images', 'rpca_svds');



