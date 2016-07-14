function result = ssc_omp(X, D, K, options)
    solver = spx.cluster.ssc.SSC_OMP(X, D, K);
    solver.Quiet = true;
    result = solver.solve();
end
