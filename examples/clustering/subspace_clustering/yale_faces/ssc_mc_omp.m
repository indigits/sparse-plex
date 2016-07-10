function result = ssc_mc_omp(X, D, K)
    solver = spx.cluster.ssc.SSC_MC_OMP(X, D, K);
    solver.MaxCandidatesToRetain = 4;
    if K <= 5
        solver.BranchingFactor = [2 1 1 1 1];
    else if K <= 30
        solver.BranchingFactor = [4 2 1 1 1];
    else
        solver.BranchingFactor = [8 4 2 1 1];
        solver.MaxCandidatesToRetain = 8;
    end
    result = solver.solve();
end

