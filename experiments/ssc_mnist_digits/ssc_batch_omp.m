function result = ssc_batch_omp(X, D, K, options)
    solver = spx.cluster.ssc.SSC_BATCH_OMP(X, D, K);
    solver.Quiet = true;
    result = solver.solve();
end
