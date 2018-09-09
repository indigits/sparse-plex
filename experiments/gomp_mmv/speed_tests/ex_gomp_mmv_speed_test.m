close all;
clearvars;
clc;
rng('default');

% Signal space 
N = 1024;
% Number of measurements
M = 512;
% Sparsity level
K = 16;
% Number of signals
S = 1000;
% Construct the signal generator.
gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
% Generate bi-uniform signals
X = gen.biUniform(1, 2);
% Sensing matrix
Phi = spx.dict.simple.gaussian_dict(M, N);
PhiM = double(Phi);
% Measurement vectors
Y = Phi * X;

% Number of atoms per iteration
L = 4;
% Number of vectors in MMV set
T = 20;

fprintf('\nRunning Matlab-GOMP MMV...');
tic;
solver = spx.pursuit.joint.GOMP(PhiM, K);
solver.L = L;
begins = 1:T:S;
ends = begins+T-1;
for t=1:numel(begins)
    YY = Y(:, begins(t) : ends(t));
    result = solver.solve(YY); 
end
t2=toc;

fprintf('\nRunning C GOMP MMV...');
tic;
res_norm_bnd = 0;
options.verbose = 0;
Z = spx.fast.gomp_mmv(Phi, Y, K, L, T, res_norm_bnd, options);
t1=toc;





% display summary  %
fprintf('\n\nSpeed summary for %d signals, dictionary size %d x %d:\n', S, M, N);
fprintf('Algorithm               Total time\n');
fprintf('--------------------------------------------------------\n');
fprintf('Matlab-GOMP MMV   %5.2f seconds\n', t1);
fprintf('C GOMP MMV        %5.2f seconds\n', t2);
