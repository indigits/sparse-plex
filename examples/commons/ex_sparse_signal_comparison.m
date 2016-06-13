close all;
clear all;
clc;
rng('default');
N = 256;
K = 4;
% Constructing a sparse vector
% Choosing the support randomly
Omega = randperm(N, K);
% Number of signals
S = 2;
% Original signals
X = zeros(N, S);
% Choosing non-zero values uniformly between (-b, -a) and (a, b)
a = 1;
b = 2; 
% unsigned magnitudes of non-zero entries
XM = a + (b-a).*rand(K, S);
% Generate sign for non-zero entries randomly
sgn = sign(randn(K, S));
% Combine sign and magnitude
XMS = sgn .* XM;
% Place at the right non-zero locations
X(Omega, :) = XMS;
% Creating noise using helper function
SNR = 15;
Noise = spx.data.noise.Basic.createNoise(XMS, SNR);
Y = X;
Y(Omega, :) = Y(Omega, :) + Noise;

cs = spx.commons.SparseSignalsComparison(X, Y, K);
cs.difference_norms()
cs.reference_norms()
cs.estimate_norms()
cs.error_to_signal_norms()
cs.signal_to_noise_ratios()
cs.sparse_references()
cs.sparse_estimates()
cs.reference_sparse_supports()
cs.estimate_sparse_supports()
cs.support_similarity_ratios()
cs.has_matching_supports(1.0)
cs.summarize()


