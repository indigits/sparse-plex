% Adapted from ompspeedtest by Ron Rubinstein in OMPBOX v10
clearvars;
close all;
clc;
rng default;
% random dictionary %

n = 512;
L = 1000;
T = 8;

D = randn(n,L);
D = D*diag(1./sqrt(sum(D.*D)));    % normalize the dictionary


% select signal number according to computer speed %

x = randn(n,20);
result = spx.fast.omp(D, x, T, 1e-12);
tic; omp(D,x,[],T,'messages',-1); t=toc;
signum = ceil(20/(t/20));     % approximately 20 seconds of OMP-Cholesky


% generate random signals %

X = randn(n,signum);

G = D' * D;
DtX = D'*X;
% run OMP  %

fprintf('\nRunning OMP-Cholesky...');
tic; omp(D,X,[],T,'messages',4); t1=toc;

fprintf('\nRunning SPX-OMP-Cholesky...');
tic; spx.fast.omp(D, X, T, 1e-12); t2=toc;

fprintf('\nRunning SPX-OMP-LS...');
options.ls_method = 'ls';
tic; spx.fast.omp(D, X, T, 1e-12, options); t3=toc;


% display summary  %
fprintf('\n\nSpeed summary for %d signals, dictionary size %d x %d:\n', signum, n, L);
fprintf('Call syntax        Algorithm               Total time\n');
fprintf('--------------------------------------------------------\n');
fprintf('OMP(D,X,[],T)                    OMP-Cholesky            %5.2f seconds\n', t1);
fprintf('SPX-OMP(D, X, T)                 SPX-OMP-Cholesky        %5.2f seconds\n', t2);
fprintf('SPX-OMP-LS(D, X, T)              SPX-OMP-LS              %5.2f seconds\n', t3);
