close all;
clear all;
clc;
rng default;
M = 400;
N = 1000;
K = 16;
S = 5000;
Phi = spx.dict.simple.gaussian_mtx(M, N);
% create a set of sparse vectors
X = spx.data.synthetic.SparseSignalGenerator(N, K, S).biGaussian();
% Create measurements
Y = Phi*X;
G = Phi' * Phi;
DtY = Phi' * Y;
start_time = tic;
result = spx.fast.batch_omp(Phi, [], G, DtY, K, 1e-12);
elapsed_time = toc(start_time);
fprintf('Time taken: %.2f seconds\n', elapsed_time);
fprintf('Per signal time: %.2f usec', elapsed_time * 1e6/ S);
cmpare = spx.commons.SparseSignalsComparison(X, result, K);
cmpare.summarize();


fprintf('Reconstruction with Fast OMP')
start_time = tic;
result = spx.fast.omp(Phi, Y, K, 1e-12);
elapsed_time = toc(start_time);
fprintf('Time taken: %.2f seconds\n', elapsed_time);
fprintf('Per signal time: %.2f usec', elapsed_time * 1e6/ S);
cmpare = spx.commons.SparseSignalsComparison(X, result, K);
cmpare.summarize();
