close all;
clearvars;
clc;
% The function
f=@(x,y) 2*x.^2 + 4*y.^2;;
% Construct a mesh of (x,y) values
[X,Y]=meshgrid(-3:0.1:3);
% compute f on all these (x, y) values
Z=f(X,Y);
% draw a contour plot
levels = [2:2:20];
[c, h] = contour3(X,Y,Z);
grid on;


