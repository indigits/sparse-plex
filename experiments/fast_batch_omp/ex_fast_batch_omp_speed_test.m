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
result = spx.fast.omp(D, x, T, 1e-12);
tic; omp(D,x,[],T,'messages',-1); t=toc;
signum = ceil(100/(t/100));     % approximately 20 seconds of OMP-Cholesky


% generate random signals %

X = randn(n,signum);

G = D' * D;
DtX = D'*X;
% run OMP  %

fprintf('\nRunning Batch-OMP...');
tic; omp(D,X,G,T,'messages',1); t1=toc;

fprintf('\nRunning Batch-OMP with D''*X specified...');
tic; omp(DtX,G,T,'messages',1); t2=toc;

fprintf('\nRunning SPX-Batch-OMP...');
tic; spx.fast.batch_omp(D, X, G, [], T, 0); t3=toc;

fprintf('\nRunning SPX-Batch-OMP with DtX...');
tic; spx.fast.batch_omp([], [], G, DtX, T, 0); t4=toc;


% display summary  %
fprintf('\n\nSpeed summary for %d signals, dictionary size %d x %d:\n', signum, n, L);
fprintf('Call syntax        Algorithm               Total time\n');
fprintf('--------------------------------------------------------\n');
fprintf('OMP(D,X,G,T)                     Batch-OMP               %5.2f seconds\n', t1);
fprintf('OMP(DtX,G,T)                     Batch-OMP with DTX    %5.2f seconds\n', t2);
fprintf('SPX-Batch-OMP(D, X, G, [], T)    SPX-Batch-OMP           %5.2f seconds\n', t3);
fprintf('SPX-Batch-OMP([], [], G, Dtx, T) SPX-Batch-OMP DTX     %5.2f seconds\n', t4);


fprintf('Gain SPX/OMPBOX without DTX %.2f\n', t1 / t3 );
fprintf('Gain SPX/OMPBOX with DTX %.2f\n', t2 / t4 );

