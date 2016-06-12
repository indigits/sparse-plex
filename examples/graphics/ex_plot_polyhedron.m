

% Initialization
clear all; close all; clc;

a1 = [ 2;  1];
a2 = [ 2; -1];
a3 = [-1;  2];
a4 = [-1; -2];

A = [a1 a2 a3 a4]';

b = ones(4,1);
span = [-2 2 -2 2];
spx.graphics.plot.polyhedron(A, b, span);