function result = ssc_mc_omp(X, D, K)
    solver = spx.cluster.ssc.SSC_TOMP(X, D, K);
    result = solver.solve();
end
