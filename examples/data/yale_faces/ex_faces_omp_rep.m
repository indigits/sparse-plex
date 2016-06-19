% This script depends on
% - ex_omp_approx.m
% Please execute the dependencies before
% running this script.

% This script takes sample images from the original 
% set of cropped faces and corresponding images
% obtained by constructing OMP representations.
% The script presents both set of sample images
% in canvases to have a subjective feeling of 
% quality of approximation.

close all; clear all; clc;

export = true;

load bin/omp_representations;
[D, total_images] = size(representations);

width = 42;
height = 48;
yf = SPX_YaleFaces();
yf.load();
yf.resize_all(width, height);



num_subjects = yf.num_subjects();
images_per_subject = total_images / num_subjects;
load('bin/omp_dictionary');
all_images = dictionary * representations;

rows = 8;
cols = 20;
k  = rows * cols;
indices = randperm(total_images, k);

mf = spx.graphics.Figures();

mf.new_figure('Example faces');
%indices = (indices - 1) * images_per_subject + 1;
images = yf.ImageData(:, indices);
canvas = spx.graphics.canvas.create_image_grid(images, rows, cols, ...
    height, width);
canvas = uint8(canvas);

imshow(canvas);
colormap(gray);
axis image;
axis off;

if export
export_fig bin/images/yale_faces_sample.png -r120 -nocrop;
export_fig bin/images/yale_faces_sample.pdf;
end

mf.new_figure('Example faces from OMP reconstruction');
%indices = (indices - 1) * images_per_subject + 1;
images = all_images(:, indices);
canvas = spx.graphics.canvas.create_image_grid(images, rows, cols, ...
    height, width);
canvas = uint8(canvas);

imshow(canvas);
colormap(gray);
axis image;
axis off;

if export
export_fig bin/images/yale_faces_omp_rec_sample.png -r120 -nocrop;
export_fig bin/images/yale_faces_omp_rec_sample.pdf;
end

