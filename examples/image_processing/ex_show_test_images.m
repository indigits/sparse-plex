
clear all; close all; clc;
mf = spx.graphics.Figures(600, 600);
mf.X_SHIFT = 150;
mf.Y_SHIFT = 0;
mf.new_figure('barbara');
imshow(spx.data.standard_images.barbara_gray_512x512 / 255);
mf.new_figure('cameraman');
imshow(spx.data.standard_images.cameraman_gray_512x512 / 255);
mf.new_figure('jetplane');
imshow(spx.data.standard_images.jetplane_gray_512x512 / 255);
mf.new_figure('lake');
imshow(spx.data.standard_images.lake_gray_512x512 / 255);
mf.new_figure('lena');
imshow(spx.data.standard_images.lena_gray_512x512 / 255);
mf.new_figure('peppers');
imshow(spx.data.standard_images.peppers_gray_512x512 / 255);
mf.new_figure('pirate');
imshow(spx.data.standard_images.pirate_gray_512x512 / 255);
