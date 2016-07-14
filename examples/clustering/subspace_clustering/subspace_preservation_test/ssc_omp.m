function result = ssc_omp(X, D, K, solver_params)
    solver = spx.cluster.ssc.SSC_OMP(X, D, K);
    result = solver.solve();
end
