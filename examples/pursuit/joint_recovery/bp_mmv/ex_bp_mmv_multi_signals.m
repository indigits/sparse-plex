close all;
clear all;
clc;
rng('default');
png_export = true;
pdf_export = false;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

mf = SPX_Figures();

% Signal space 
N = 256;
% Number of measurements
M = 64;
% Sparsity level
K = 8;
% Number of signals
S = 4;
% Construct the signal generator.
gen  = SPX_SparseSignalGenerator(N, K, S);
% Generate bi-uniform signals
X = gen.biUniform(1, 2);
% Sensing matrix
Phi = SPX_SimpleDicts.gaussian_dict(M, N);
% Measurement vectors
Y = Phi * X;

solver = SPX_BP_MMV(Phi);
result = solver.solve_linf_l1(Y);
% Solution vectors
Z = result.Z;

solver = SPX_BP_MMV(Phi);
result = solver.solve_l1_l1(Y);
% Solution vectors
Z = result.Z;

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

