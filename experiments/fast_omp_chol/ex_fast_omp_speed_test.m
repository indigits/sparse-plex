function ompspeedtest
%OMPSPEEDTEST Test the speed of the OMP functions.
%  OMPSPEEDTEST invokes the three operation modes of OMP and compares
%  their speeds. The function automatically selects the number of signals
%  for the test based on the speed of the system.
%
%  To run the test, type OMPSPEEDTEST from the Matlab prompt.
%
%  See also OMPDEMO.


%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  ronrubin@cs
%
%  August 2009



% random dictionary %

n = 512;
L = 1000;
T = 8;

D = randn(n,L);
D = D*diag(1./sqrt(sum(D.*D)));    % normalize the dictionary


% select signal number according to computer speed %

x = randn(n,20);
result = spx.pursuit.fast_omp_chol(D, x, T, 1e-12);
tic; omp(D,x,[],T,'messages',-1); t=toc;
signum = ceil(20/(t/20));     % approximately 20 seconds of OMP-Cholesky


% generate random signals %

X = randn(n,signum);

G = D' * D;
DtX = D'*X;
% run OMP  %

printf('\nRunning OMP-Cholesky...');
tic; omp(D,X,[],T,'messages',4); t1=toc;

printf('\nRunning Batch-OMP...');
tic; omp(D,X,G,T,'messages',1); t2=toc;

printf('\nRunning Batch-OMP with D''*X specified...');
tic; omp(DtX,G,T,'messages',1); t3=toc;

printf('\nRunning SPX-OMP-Cholesky...');
tic; spx.pursuit.fast_omp_chol(D, X, T, 1e-12); t4=toc;

printf('\nRunning SPX-Batch-OMP...');
tic; spx.pursuit.fast_batch_omp(D, X, G, [], T, 0); t5=toc;

printf('\nRunning SPX-Batch-OMP with DtX...');
tic; spx.pursuit.fast_batch_omp([], [], G, DtX, T, 0); t6=toc;

% display summary  %
import spx.io.printf
printf('\n\nSpeed summary for %d signals, dictionary size %d x %d:\n', signum, n, L);
printf('Call syntax        Algorithm               Total time');
printf('--------------------------------------------------------');
printf('OMP(D,X,[],T)                    OMP-Cholesky            %5.2f seconds', t1);
printf('OMP(D,X,G,T)                     Batch-OMP               %5.2f seconds', t2);
printf('OMP(DtX,G,T)                     Batch-OMP with D''*X    %5.2f seconds\n', t3);
printf('SPX-OMP(D, X, T)                 SPX-OMP-Cholesky        %5.2f seconds\n', t4);
printf('SPX-OMP(D, X, G, [], T)          SPX-Batch-OMP           %5.2f seconds\n', t5);
printf('SPX-OMP([], [], G, Dtx, T)       SPX-Batch-OMP           %5.2f seconds\n', t6);
