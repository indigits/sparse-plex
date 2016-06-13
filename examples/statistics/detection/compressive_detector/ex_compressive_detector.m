%% This script simulates compressed detector as defined by Davenport.

%% Initialization code
clear all; close all; clc; tic;
rng('default');
% Length of each signal
N = 1000;
% Sample signal is generated using Gaussian random numbers
signal = randn(N, 1);
% Each sample signal is a column in the signals matrix
% We normalize sample signal
signal = spx.commons.norm.normalize_l2(signal);
M = 200;
phi = spx.dict.simple.rademacher_mtx(M, N);

% Signal norm (this is known to be 1)
sNorm = norm(signal); % 1x1
% Dimensions of the signal and measurement spaces
% [M, N] = size(phi);

% SNR (dB)
SNRdB = 20;
SNR = db2pow(SNRdB);
%variance of the noise based on SNR
variance = sNorm^2 / SNR;
% std of channel AWGN
sigma = sqrt(variance);

% The false alarm rate
expectedPF = 0.01;

% Number of bits being transmitted
B = 1000*100;
% Probability of 1 being transmitted
P1 = 0.5;

%% Detector simulation
tic;
results = SPX_CompressiveDetector.simulate(...
    phi, signal, P1, sigma, expectedPF, B);
toc;
fprintf('Signal energy: %f = %f dB \n', sNorm^2, 20 * log10(sNorm) ); 
fprintf('SNR %d (dB), Noise variance: %f, sigma: %f\n', ...
    SNRdB, variance, sigma);
fprintf('Threshold gamma: %f\n', results.gamma);  
fprintf('Design PF: %f, Actual PF: %f\n', expectedPF,...
    results.detectionResults.PF); 
fprintf('Design PD: %f, Actual PD: %f\n', results.expectedPD,...
    results.detectionResults.PD);
fprintf('Detection performance:\n');
disp(results.detectionResults);
%% Display of results

spx.graphics.Figures.full_screen_figure;
subplot(211);
imshow(mat2gray(phi));
title(sprintf('Rademacher sensing matrix (%dx%d)', M, N));
subplot(212);
plot(signal);
title('Signal');

% We show case some sample bits
ShowBits = 20;
spx.graphics.Figures.full_screen_figure;
subplot(611);
stem(results.transmittedBits(1:ShowBits));
title('Transmitted bits');
subplot(612);
plot(results.transmittedSequence(1:ShowBits*N));
title('Transmitted sequence');
subplot(613);
plot(results.receivedSequence(1:ShowBits*N));
title('Received sequence with noise');
subplot(614);
plot(results.measurementVectors(1:ShowBits*M));
title('Measurements');
subplot(615);
stem(results.statistic(1:ShowBits));
hold on;
tmp = results.gamma * ones(ShowBits, 1);
plot(tmp);
hold off;
title('Sufficient statistics');
subplot(616);
stem(results.receivedBits(1:ShowBits));
title('Received bits');

