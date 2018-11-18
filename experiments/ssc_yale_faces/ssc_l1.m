function result = ssc_l1(X, D, K)
    ssc = spx.cluster.ssc.SSC_L1(X, D, K);
    ssc.Affine = false;
    ssc.NoiseFactor = 0.01;
    result = ssc.solve();
end
