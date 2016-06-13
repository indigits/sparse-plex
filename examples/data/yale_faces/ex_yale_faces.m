close all; clear all; clc;
yf = SPX_YaleFaces();
yf.load();
yf.describe();
mf = spx.graphics.Figures();
mf.new_figure('Example faces');
canvas = yf.create_random_canvas();
imshow(canvas);
colormap(gray);
axis image;
axis off;

yf.resize_all(42, 48);
mf.new_figure('Subject 1');
canvas = yf.create_subject_canvas(1);
imshow(canvas);
colormap(gray);
axis image;
axis off;


