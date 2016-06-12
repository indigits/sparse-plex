clear all; close all; clc;

% Draws poles and zeros on a complex plane
% Coefficients of the rational filter
b = [1 0.7 0.6];
a = [1 -1.5 0.9];
spx.graphics.plot.rational_poles_zeros(b,a);