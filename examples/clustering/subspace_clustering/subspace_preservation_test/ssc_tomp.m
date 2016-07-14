function result = ssc_tomp(X, D, K, solver_params)
    solver = spx.cluster.ssc.SSC_TOMP(X, D, K);
    result = solver.solve();
end
