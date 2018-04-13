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
trials  = 2;
matching_mode = 2;
for t=1:trials
    fprintf('Trial: %d: \n', t);
    % Construct the signal generator.
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
    % Generate bi-uniform signals
    x = gen.biGaussian;
    % Sensing matrix
    Phi = spx.dict.simple.gaussian_mtx(M, N);
    % Measurement vectors
    y = Phi * x;    
    options.ls_method = 4;
    options.verbose = 1;
    % Solve the sparse recovery problem using OMP
    z = spx.fast.omp(Phi, y, K, 0, options);
    stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
    spx.commons.sparse.print_recovery_performance(stats);
end
