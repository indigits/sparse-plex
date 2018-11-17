function result = ssc_nn_omp(X, D, K, solver_params)
    solver = spx.cluster.ssc.SSC_NN_OMP(X, D, K);
    result = solver.solve();
end
