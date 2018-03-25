n = 512;
L = 1000;
T = 8;

D = randn(n,L);
D = D*diag(1./sqrt(sum(D.*D)));    % normalize the dictionary

x = randn(n,20);
tic; omp(D,x,[],T,'messages',-1); t=toc;
signum = ceil(20/(t/20));     % approximately 20 seconds of OMP-Cholesky
% generate random signals %

X = randn(n,signum);
Gamma1 = omp(D,X,[],T,'messages',4);
Gamma2 =  spx.pursuit.fast_omp_chol(D, X, T, 1e-12);
cmpare = spx.commons.SparseSignalsComparison(Gamma1, Gamma2, K);
cmpare.summarize();

