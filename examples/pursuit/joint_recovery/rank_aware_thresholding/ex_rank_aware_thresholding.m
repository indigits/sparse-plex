% Rank aware thresholding needs much more measurements than MUSIC to work
% properly.

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
% Sparsity level
K = 6;
% Number of measurements
M = 32;
% Number of signals
S = 4;
% Construct the signal generator.
gen  = SPX_SparseSignalGenerator(N, K, S);
% Generate bi-uniform signals
X = gen.biUniform(1, 2);
% Sensing matrix
Phi = SPX_SimpleDicts.gaussian_dict(M, N);
% Measurement vectors
Y = Phi.apply(X);
%  Rank Aware Thresholding solver instance
solver = SPX_RankAwareThresholding(Phi, K);
% Solve the sparse recovery problem
result = solver.solve(Y);
% Solution vector
Z = result.Z;
% Comparison
cs = SPX_SparseSignalsComparison(X, Z, K);
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

