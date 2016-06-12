clear all; close all; clc;
% A symmetric positive definite matrix
A = [ 3 2 ; 
      2 6 ];

b = [ 2 ; -8 ];

spx.graphics.plot.quadratic_form(A, b, -10, 10, -10, 10);