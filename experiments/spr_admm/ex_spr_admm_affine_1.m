close all;
clc;
clearvars;
rng('default');

try_spx = true;
try_ehsan = true;
try_cvx = false;

% dimension of ambient space
n = 100;
% number of subspaces = number of clusters
ns = 2;
% dimensions of individual subspaces 1 and 2
d1  = 2;
d2 = 2;
% number of signals in individual subspaces
s1 = 100;
s2 = 100;
% total number of signals
s = s1 + s2;
% A random basis for first subspace;
basis1 = randn(n,d1);
% An origin for first subspace
origin1 = randn(n, 1);
% coefficients for s1 vectors chosen randomly in subspace 1
coeffs1 = randn(d1,s1);
% Random signals from first subspace
Y1 = basis1 * coeffs1 + origin1;
% A random basis for second subspace
basis2 = randn(n,d2);
% An origin for second subspace
origin2 = randn(n, 1);
% coefficients for s2 vectors chosen randomly in subspace 2
coeffs2 = randn(d2,s2);
% Random signals from first subspace
Y2 = basis2 * coeffs2 + origin2;
% Prepare the overall set of signals
Y = [Y1 Y2];
% ground through clustering data
true_labels = [1*ones(s1,1) ; 2*ones(s2,1)];
% the largest dimension amongst all subspaces
K = max(d1, d2);
% All signals are expected to  have a K-sparse representation

% This is an affine problem
affine = true;

if try_spx
    fprintf('Attempting our implementation of SPR-ADMM-Affine\n');
    tstart = tic;
    options.affine = true;
    [C1, details] = spx.cluster.ssc.spr_admm(Y, options);
    elapsed_time = toc(tstart);
    fprintf('Maximum difference: %.4f\n', max(max(abs(Y - Y*C1))));
    fprintf('Number of iterations: %d\n', details.iterations);
    fprintf('Elapsed time: %.4f seconds\n', elapsed_time);
    disp(details);
    figure;
    imshow(C1);
end

if try_ehsan
    fprintf('Attempting admmLasso_mat_func\n');
    tstart = tic;
    [C2, details] = admmLasso_mat_func(Y, affine);
    elapsed_time = toc(tstart);
    fprintf('Maximum difference: %.4f\n', max(max(abs(Y - Y*C2))));
    fprintf('Number of iterations: %d\n', details.iterations);
    fprintf('Elapsed time: %.4f seconds\n', elapsed_time);
    disp(details);
    figure;
    imshow(C2);
end

if try_cvx 
    fprintf('Attempting CVX\n');
    tstart = tic;
    options.verbose = 1;
    options.affine = affine;
    [C3, details] = spx.cluster.ssc.spr_cvx(Y, options);
    elapsed_time = toc(tstart);
    fprintf('Maximum difference: %.4f\n', max(max(abs(Y - Y*C3))));
    fprintf('Elapsed time: %.4f seconds\n', elapsed_time);
    disp(details);
    figure;
    imshow(C3);
end
