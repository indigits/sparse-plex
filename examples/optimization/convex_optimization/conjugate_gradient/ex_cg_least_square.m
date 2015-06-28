close all; clear all; clc;
rng('default');

A = [
1 -1
1 1
2 1
];

B = [
2
4 
8
];

solver = SPX_CGLeastSquare(A, B);
x = solver.solve();
solver.printResults();



