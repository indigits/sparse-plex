function result = ssc_mc_omp(X, D, K, params)
    if nargin < 4
        params.BranchingFactor = 2;
        params.MaxCandidatesToRetain = 4;
    end
    solver = spx.cluster.ssc.SSC_MC_OMP(X, D, K);
    solver.BranchingFactor = params.BranchingFactor;
    solver.MaxCandidatesToRetain = params.MaxCandidatesToRetain;
    fprintf('candidates: %d, bf: ', solver.MaxCandidatesToRetain);
    fprintf('%d ', solver.BranchingFactor);
    fprintf('\n');
    result = solver.solve();
end

