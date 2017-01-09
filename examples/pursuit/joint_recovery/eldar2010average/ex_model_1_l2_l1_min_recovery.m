close all;
clear all;
clc;
rng('default');
png_export = true;
pdf_export = false;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

mf = spx.graphics.Figures();

% Signal space 
N = 256;
% Number of measurements
M = 64;
% Sparsity level
K = 8;
% Number of signals
S = 4;
% Generate data as per model 1
X = model_1_data(N, K, S);
% Sensing matrix random spherical ensemble
Phi = spx.dict.simple.gaussian_dict(M, N);
% Measurement vectors
Y = Phi * X;

solver = spx.pursuit.joint.BasisPursuit(Phi);
% Solve using L2-L1 norm minimization
result = solver.solve_l2_l1(Y);
% Solution vectors
Z = result.Z;
% Comparison
cs = spx.commons.SparseSignalsComparison(X, Z, K);
cs.summarize();
for s=1:S
    mf.new_figure(sprintf('MMV signal: %d', s));
    subplot(411);
    stem(X(:, s), '.');
    title('Sparse vector');
    subplot(412);
    stem(Z(:, s), '.');
    title('Recovered sparse vector');
    subplot(413);
    stem(abs(X(:, s) - Z(:, s)), '.');
    title('Recovery error');
    subplot(414);
    stem(Y(:, s), '.');
    title('Measurement vector');
end

