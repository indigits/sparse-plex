close all; clear all; clc;
rng('default');

A = [3 2; 2 6];
X = [ 2 1 0 4; 
     -2 2 0 4];
B = A * X;

solver = SPX_ConjugateDescent(A, B);
x = solver.solve();
solver.printResults();



