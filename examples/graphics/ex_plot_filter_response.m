close all; clear all; clc;

h = [1 1 1 1]/4;
x = randn(1, 100);
y = filter(h, [1], x);
SPX_Plot.filter_response_h_x_y(h, x, y);

    