clear all; close all; clc;

% The matrix to be displayed.
data = spiral(100);

SPX_Display.matrix(data);

data = randn(100, 100);
options.color_map = 'gray';
SPX_Display.matrix(data, options);
