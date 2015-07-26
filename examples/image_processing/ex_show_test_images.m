
clear all; close all; clc;
mf = SPX_Figures(600, 600);
mf.X_SHIFT = 150;
mf.Y_SHIFT = 0;
mf.new_figure('barbara');
imshow(SPX_TestImages.barbara_gray_512x512 / 255);
mf.new_figure('cameraman');
imshow(SPX_TestImages.cameraman_gray_512x512 / 255);
mf.new_figure('jetplane');
imshow(SPX_TestImages.jetplane_gray_512x512 / 255);
mf.new_figure('lake');
imshow(SPX_TestImages.lake_gray_512x512 / 255);
mf.new_figure('lena');
imshow(SPX_TestImages.lena_gray_512x512 / 255);
mf.new_figure('peppers');
imshow(SPX_TestImages.peppers_gray_512x512 / 255);
mf.new_figure('pirate');
imshow(SPX_TestImages.pirate_gray_512x512 / 255);
