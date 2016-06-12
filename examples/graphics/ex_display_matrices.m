clear all; close all; clc;

% The matrix to be displayed.
data = spiral(100);

spx.graphics.display.matrix(data);

data = randn(100, 100);
options.color_map = 'gray';
spx.graphics.display.matrix(data, options);
