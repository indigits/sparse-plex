function result = ssc_mc_omp(X, D, K, params)
    if nargin < 4
        params.branching_factor = 2;
        params.max_candidates_to_retain = 4;
    end
    rnorm_thr = 1e-3;
    method = spx.cluster.ssc.OMP_REPR_METHOD.MC_OMP;
    solver = spx.cluster.ssc.SSC_OMP(X, D, K, rnorm_thr, method);
    solver.RepSolverOptions = params;
    fprintf('candidates: %d, bf: ', params.max_candidates_to_retain);
    fprintf('%d ', params.branching_factor);
    fprintf('\n');
    result = solver.solve();
end
