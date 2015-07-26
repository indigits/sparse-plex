
% Initialization
clear all; close all; clc;

SPX_Figures.full_screen_figure;
SPX_Draw.circle(0, 0, 4);
options.color = 'g';
SPX_Draw.circle(2, 2, 2, options);
options.color = 'k';
SPX_Draw.circle(3, -3, 2, options);
% lets give some leg room in the axes
axis([-5 5 -5 5]);
% the axes must be equal for proper visualization
axis equal;
