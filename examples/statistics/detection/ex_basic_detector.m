%% Initialization
close all;
clear all;
clc;
tic;
% Number of samples per detection test.
N = 10;
% The signal shape
signal = ones(N, 1);
signalNormSquared = signal' * signal;
% Number of bits being transmitted
B = 1000*100;
% Generate a sequence of bits
transmittedBits = randi(2, B , 1)  - 1;
% We compute the transmitted sequence
startMod = toc;
transmittedSequence = SPX_Modulator.modulate_bits_with_signals(transmittedBits, signal);
endMod = toc;
fprintf('Modulation time: %0.4f seconds\n', endMod - startMod);
% We create transmission channel noise
sigma = 1;
noise = sigma * randn(size(transmittedSequence));
% We add noise to transmitted data to create received sequence
receivedSequence = transmittedSequence + noise;
startMF = toc;
% We compute matched filter output at receiver
matchedFilterOutput = SPX_MatchedFilter.filter(receivedSequence, signal);
stopMF = toc;
fprintf('Matched filter time: %0.4f seconds\n', stopMF - startMF);
% We compute sufficient statistic by normalizing matched filter output
sufficientStatistics = matchedFilterOutput / signalNormSquared;
% We define optimal detection threshold
eta = 0.5;
% We create the received bits 
receivedBits = sufficientStatistics >= eta;
% We compute detection results
detectionResults = SPX_BinaryHypothesisTest.performance(...
    transmittedBits, receivedBits)
toc;
if 0
% Plots
figure;
subplot(311);
stem(transmittedBits);
subplot(312);
stem(sufficientStatistics);
subplot(313);
stem(receivedBits);
end


