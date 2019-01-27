clc;
close all;
clearvars;
rand('seed', 0);
randn('seed', 0);

m = 1000; % number of examples
n = 100;  % number of features
for t=1:20
    % A random matrix
    A = randn(m,n);
    % Original signal
    x0 = 10*randn(n,1);
    % Measurements
    b = A*x0;
    % Introduce sparse noise in the signal
    % Select a subset of indices [2% of m indices]
    idx = randsample(m,ceil(m/50));
    % Introduce noise in these indices
    b(idx) = b(idx) + 1e2*randn(size(idx));
    % Perform Least absolute deviation optimization
    tstart = tic;
    options.verbose  = 0;
    x = spx.opt.admm.lad(A, b, options);
    toc(tstart)
    % measure the maximum difference
    recovery_error = x - x0;
    max_diff = max(abs(x - x0));
    fprintf('Maximum difference: %e\n', max_diff);
    fprintf('Recovery error norm: %e\n', norm(recovery_error));
end
