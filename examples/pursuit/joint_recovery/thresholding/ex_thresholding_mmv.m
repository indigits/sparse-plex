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
K = 5;
% Number of signals
S = 4;
% Construct the signal generator.
gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
% Generate bi-uniform signals
X = gen.biUniform(1, 2);
% Sensing matrix
Phi = spx.dict.simple.gaussian_dict(M, N);
% Measurement vectors
Y = Phi.apply(X);
%  MMV Thresholding solver instance
solver = SPX_Thresholding_MMV(Phi, K);
% Solve the sparse recovery problem
result = solver.solve(Y);
% Solution vector
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

