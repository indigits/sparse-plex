%% Initialization
clear all; close all; clc;

% In this example, the signals under H1 and H0 are zero mean Gaussian noise
% sequences with variances sigma_1 and sigma_0 respectively.

% Number of bits being transmitted
B = 1000*100;
% Generate a sequence of bits
transmittedBits = randi(2, B , 1)  - 1;
table = tabulate(transmittedBits);
% The a-priori probabilities 
P0 = table(1, 2) / B;
P1 = table(2,2) / B;
% The cost matrix
C = [0 1; 1 0];
% The threshold
eta = SPX_BinaryHypothesisTest.bayes_criterion_threshold(C, P1);
% Number of samples per detection test.
N = 10;
% We compute the received sequence
sigma1 = 4;
sigma0 = 1;
fprintf('sigma_0: %d\n', sigma0);
fprintf('sigma_1: %d\n', sigma1);
fprintf('sigma_n: 1\n');

receivedSequence = SPX_Modulator.modulate_bits_with_gaussian_noise(transmittedBits, N, sigma1, sigma0);
% Let us compute the sufficient statistic for this demo
statistic = SPX_Statistics.compute_statistic_per_vector(receivedSequence, N, @spx.commons.norm.sum_square);
threshold = 2* sigma0^2 * sigma1^2 / (sigma1^2 - sigma0^2);
threshold = threshold * (log(eta) - N * log (sigma0 / sigma1));
% We create the received bits 
receivedBits = statistic >= threshold;
% We compute detection results
detectionResults = SPX_BinaryHypothesisTest.performance(...
    transmittedBits, receivedBits)


% We show case some sample bits
ShowBits = 20;
spx.graphics.Figures.full_screen_figure;
subplot(411);
stem(transmittedBits(1:ShowBits), '.');
title('Transmitted bits');
subplot(412);
plot(receivedSequence(1:ShowBits*N));
title('Received sequence with noise (H_0: \sigma_0, H_1: \sigma_1)');
subplot(413);
stem(statistic(1:ShowBits), '.');
hold on;
tmp = threshold * ones(ShowBits, 1);
plot(tmp);
hold off;
title('Sufficient statistics');
subplot(414);
stem(receivedBits(1:ShowBits), '.');
title('Received bits');
