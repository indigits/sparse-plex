close all;
clear all;
clc;
rng('default');
png_export = true;
pdf_export = false;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

% Signal space 
N = 256;
% Number of measurements
M = 64;
% Sparsity level
K = 6;
% Construct the signal generator.
gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
% Generate bi-uniform signals
x = gen.biGaussian;
% Sensing matrix
Phi = spx.dict.simple.gaussian_mtx(M, N);
% Measurement vectors
y = Phi * x;
options.norm_factor = 2;
options.reset_interval = 4;
options.VERBOSE = true;
res_norm_thr = 1e-3;
% Solve the sparse recovery problem using OMP
z = spx.fast.omp_ar(Phi, y, K, res_norm_thr, options);
stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
spx.commons.sparse.print_recovery_performance(stats);
fprintf('x support: ');
fprintf('%d ', spx.commons.sparse.support(x));
fprintf('\n');
fprintf('x: ');
spx.io.print.sparse_signal(x);

if 1
figure;
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
end
