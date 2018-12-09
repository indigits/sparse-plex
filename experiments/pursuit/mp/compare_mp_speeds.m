%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Note, in order to run this script, you will need
% the package sparsify v0.5 by Thomas Blumensath
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Signal space 
N = 1024;
% Number of measurements
M = 100;
% Sparsity level
K = 8;

% solver instance
% solver = spx.pursuit.single.MatchingPursuit(Phi);
% Solve the sparse recovery problem
% result = solver.solve(y);
max_residual_norm = 1e-6;
options.max_residual_norm = max_residual_norm;
tstart = tic;
T = 1000;
t1 = 0;
t2 = 0;
for i=1:T
    if mod(i, 10) == 0
        fprintf('.');
    end
    % Construct the signal generator.
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
    % Generate bi-uniform signals
    x = gen.biUniform(1, 2);
    % Sensing matrix
    Phi = spx.dict.simple.gaussian_mtx(M, N);
    % Measurement vectors
    y = Phi * x;
    tic;
    if 0
        result = spx.pursuit.single.mp(Phi, y,options);
    else
        [s, err_mse, iter_time] = greed_mp(y, Phi, N, ...
            'stopCrit', 'mse', 'stopTol', max_residual_norm^2, ...
            'maxIter', 4 * N);
    end
    % result.iterations
    t1 = t1 + toc;
    % norm(result.r) / norm(y)
    tic;
    result = spx.fast.mp(Phi, y,options);
    t2 = t2 + toc;
end
fprintf('\n');
fprintf('Time taken by MATLAB implementation: %0.3f\n', t1);
fprintf('Time taken by C++ implementation: %0.3f\n', t2);
fprintf('Gain: %0.2f\n', t1/t2);