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
% Construct the signal generator.
gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
% Generate bi-uniform signals
x = gen.biUniform(1, 2);
% Sensing matrix
Phi = spx.dict.simple.gaussian_dict(M, N);
% Measurement vectors
y = Phi.apply(x);


% solver instance
% solver = spx.pursuit.single.MatchingPursuit(Phi);
% Solve the sparse recovery problem
% result = solver.solve(y);
options.max_residual_norm = 1e-6;
%result = spx.pursuit.single.mp(Phi, y,options);
result = spx.fast.mp(Phi, y,options);

% Solution vector
z = result.z;
stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
spx.commons.sparse.print_recovery_performance(stats);

mf.new_figure('MP solution');
subplot(411);
stem(x, '.');
title('Sparse vector');
subplot(412);
stem(z, '.');
title('Recovered sparse vector');
subplot(413);
stem(abs(x - z), '.');
title('Recovery error');
subplot(414);
stem(y, '.');
title('Measurement vector');
