%% Initialization code
clear all; close all; clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

%% Main script

% This script generates a set of sample signals which are used for
% modulating sequences.

% Length of each signal
N = 1000;
% Number of sample signals
R = 100;
% Sample signals are generated using Gaussian random numbers
signals = randn(N, R);
% Each sample signal is a column in the signals matrix
% We normalize sample signals
signals = SPX_Norm.normalize_l2(signals);
% We save sample signals in a file
save('bin/sample_signals.mat', 'signals');

fprintf('Number of sample signals: %d\n\n', R);
fprintf('Length of signal: %d\n', N);
% We randomly pickup a few sample signals
tmp = randperm(R);
selection = tmp(1:4);
selectedSignals  = signals(:, selection);
%We verify the norm of each of the selected signals
signalNorms = SPX_Norm.norms_l2_cw(selectedSignals)
% We measure distance between these signals
distance = SPX_Distance.pairwise_distances(selectedSignals);
distance = sqrt(abs(distance))

% We verify the minimum and maximum distances betweeen these
% signals 
distances = SPX_Mat.off_diagonal_matrix(distance);
minDistance = min(distances)
maxDistance = max(distances)


% We plot them 
SPX_Figures.full_screen_figure;
subplot(411);
plot(selectedSignals(:,1));
title('Sample unit norm signals (N=1000)');
subplot(412);
plot(selectedSignals(:,2));
subplot(413);
plot(selectedSignals(:,3));
subplot(414);
plot(selectedSignals(:,4));
