% This script demonstrates the application of Cluster
% OMP algorithm.
% The algorithm is run on synthetic data.
% We first consider a Random dictionary.
% We use columns of the dictionary to form
% 4-dimensional subspaces.
% We construct 8 such subspaces by randomly
% choosing four columns as the basis for
% each subspace. Thus total 32 columns from the
% dictionary are used.
% The data consists of a total of 1600 signals.
% For each of the 8 4-dimensional subspaces there
% are 200 signals. 


clc;
close all;
clear all;
% Prepare dictionary
Phi = SPX_SimpleDicts.spie_2011('rand');
% Dimension of representation space and signal space
[M, N] = size(Phi);
% Number of subspaces
P = 8;
% Number of signals per subspace
SS = 200;
% Sparsity level of each signal (subspace dimension)
K = 4;
% Create signal generator
sg = SPX_MultiSubspaceSignalGenerator(N, K);
% Create disjoint supports
sg.createDisjointSupports(P);
sg.setNumSignalsPerSubspace(SS);
% Generate signal representations
sg.uniform(-1, 1);
% Access  signal representations
X = sg.X;
% Corresponding supports
qs = sg.Supports;
% Prepare signals
Y = Phi * X;
solver = SPX_ClusterOMP(Phi, K);
result = solver.solve(Y);
cs = SPX_SparseSignalsComparison(X, result.Z, K);
snrs = cs.signal_to_noise_ratios();
ssrs = cs.support_similarity_ratios();
fprintf('Average SNR: %.2f \n', mean(snrs));
fprintf('Average Support similarity ratio: %.2f \n', mean(ssrs));
stats = result.stats
