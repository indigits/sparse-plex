function [ z, stats ] = solve_cosamp( Phi, K, y, x)
%SOLVEBPIC Solves the CoSaMP problem
    [M, N] = size(Phi);
    epsilon = 1e-6;
    %We now setup our recovery program.
    solver = spx.pursuit.single.CoSaMP(Phi, K);
    result = solver.solve(y);
    % recovered representation. N length vector
    z = result.z;
    stats.recoveredRepresentationVector  = z;
    % recovery error vector. N length vector
    h = x - z;
    stats.recoveryErrorVector = h;
    % l_2 norm of reconstruction error
    stats.recoveryErrorL2Norm = norm(h);
    % The K non-zero coefficients in x (set of indices)
    stats.T0 = find (x ~= 0);
    % The portion of recovery error over T0 K length vector
    stats.recoveryErrorVectorT0 = h(stats.T0); 
    % Positions of other places (set of indices)
    stats.T0C = setdiff(1:N , stats.T0);
    % Recovery error at T0C places [N - K] length vector
    hT0C = h(stats.T0C);
    stats.recoveryErrorVectorT0C = hT0C;
    % The K largest indices after T0 in recovery error (set of indices)
    stats.T1 = spx.commons.signals.largest_indices(hT0C, K);
    % The recovery error component over T1. [K] length vector.
    hT1 = h(stats.T1);
    stats.recoveryErrorVectorT1 = hT1;
    % Remaining indices [N - 2K] set of indices
    stats.TRest = setdiff(stats.T0C , stats.T1);
    % Recovery error over remaining indices [N - 2K] length vector
    hTRest = h(stats.TRest);
    stats.recoveryErrorVectorTRest = hTRest;
    % largest indices of the recovered vector
    stats.TT0 = spx.commons.signals.largest_indices(z, K);
    % Support Overlap
    stats.supportOverlap = intersect(stats.T0, stats.TT0);
    % Support recovery ratio
    stats.supportRecoveryRatio = numel(stats.supportOverlap) / K;
    % measurement error vector [M] length vector
    e = y - Phi * z;
    stats.measurementError = e;
    % Norm of measurement error.  This must be less than epsilon
    stats.measurementErrorL2Norm = norm(e);
    % Ratio between the norm of recovery error and measurement error
    stats.recoveryToMeasurementErrorNormRatio = ...
        stats.recoveryErrorL2Norm / stats.measurementErrorL2Norm;
    % whether we consider the process to be success or not.
    % We consider success only if the support has been recovered
    % completely.
    stats.success = numel(stats.supportOverlap) == K;
end

