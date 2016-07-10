function result = ssc_l1(X, D, K)
    ssc = spx.cluster.ssc.SSC_L1(X, D, K);
    ssc.NoiseFactor = 0.001;
    result = ssc.solve();
end
