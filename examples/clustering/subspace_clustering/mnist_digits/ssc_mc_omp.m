function result = ssc_mc_omp(X, D, K)
    solver = spx.cluster.ssc.SSC_MC_OMP(X, D, K);
    solver.BranchingFactor = 2;
    solver.MaxCandidatesToRetain = 4;
    result = solver.solve();
end

