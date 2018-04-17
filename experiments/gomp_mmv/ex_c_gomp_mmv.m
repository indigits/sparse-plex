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
M = 48;
% Sparsity level
K = 4;
% Number of signals
S = 100;
% Construct the signal generator.
gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
% Generate bi-uniform signals
X = gen.biUniform(1, 2);
% Sensing matrix
Phi = spx.dict.simple.gaussian_mtx(M, N);
% Measurement vectors
Y = Phi * X;
% Number of atoms per iteration
L = 4;
% Number of vectors in MMV set
T = 20;
res_norm_bnd = 0;
options.verbose = 2;
Z = spx.fast.gomp_mmv(Phi, Y, K, L, T, res_norm_bnd, options);
% Comparison
cs = spx.commons.SparseSignalsComparison(X, Z, K);
cs.summarize();
if 0
for s=1:2
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
end
