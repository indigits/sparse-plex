close all;
clear all;
clc;
rng('default');
N = 256;
% Number of signals
S = 2;
% Choosing non-zero values uniformly between (-b, -a) and (a, b)
a = 1;
b = 2; 
% unsigned magnitudes of non-zero entries
XM = a + (b-a).*rand(N, S);
% Generate sign for non-zero entries randomly
sgn = sign(randn(N, S));
% Combine sign and magnitude
X = sgn .* XM;
% Creating noise using helper function
SNR = 15;
Noise = SPX_NoiseGen.createNoise(X, SNR);
Y = X + Noise;

cs = spx.commons.signalsComparison(X, Y);
cs.difference_norms()
cs.reference_norms()
cs.estimate_norms()
cs.error_to_signal_norms()
cs.signal_to_noise_ratios()
cs.summarize()

