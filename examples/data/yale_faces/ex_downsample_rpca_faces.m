% This script depends on
% - ex_run_rpca.m
% Please execute the dependencies before
% running this script.

close all; clear all; clc;
fprintf('Loading RPCA images.\n');
load bin/yale_rpca_cache.mat;
fprintf('Loaded RPCA images.\n');
full_width = 168;
full_height = 192;
full_image_size = full_width * full_height;
num_subjects = 38;
images_per_subject  = 50;
orig_images = rpca_images;
[s, n]  = size(orig_images);
width = 42;
height = 48;
sz = width * height;
Y = zeros(sz, n);
for i=1:n
    fprintf('Resizing: %d\n',  i);
    image = reshape(orig_images(:, i), full_height, full_width);
    resized_image = imresize(image, [height, width]);
    Y(:, i) = reshape(resized_image, sz, 1);
end
fprintf('Saving resized RPCA images.\n');
save('bin/yale_rpca_downsampled_images', 'Y');
fprintf('Saved resized RPCA images.\n');

