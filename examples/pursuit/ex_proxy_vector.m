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

p = Phi.apply_transpose(y);

mf.new_figure('Proxy');

subplot(311);
stem(x, '.');
title('Sparse vector');

subplot(312);
stem(y, '.');
title('Measurements');

subplot(313);
stem(p, '.');
title('Initial proxy vector');

if png_export
export_fig bin/proxy_vector.png -r120 -nocrop;
end
if pdf_export
export_fig bin/proxy_vector.pdf;
end
