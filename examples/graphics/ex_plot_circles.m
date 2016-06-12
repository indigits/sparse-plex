
% Initialization
clear all; close all; clc;

spx.graphics.figure.full_screen;
spx.graphics.draw.circle(0, 0, 4);
options.color = 'g';
spx.graphics.draw.circle(2, 2, 2, options);
options.color = 'k';
spx.graphics.draw.circle(3, -3, 2, options);
% lets give some leg room in the axes
axis([-5 5 -5 5]);
% the axes must be equal for proper visualization
axis equal;
