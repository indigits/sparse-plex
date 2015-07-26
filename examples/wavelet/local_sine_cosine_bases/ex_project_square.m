% Demonstrates the projection of x^2 function
clear all; close all; clc;

% The function to be projected.
func = @(x) (x-2).^2;

% epsilon
polarity = 0;
step = 0.01;
epsilon = 0.2;
stop = 2;
x = 0:step:stop;
func_x = func(x);
projection = SPX_LCSBase.project_0_right(func, step, stop, epsilon, polarity);
subplot(311);
plot(x, func_x, 'r');
subplot(312);
plot(x, projection, 'b');
residual = func_x - projection;
subplot(313);
plot(x, residual, 'g');
