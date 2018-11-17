function result = ssc_l1_mahdi(X, D, K, solver_params)
% SSC_L1_MAHDI  Solve sparse subspace clustering using l1 minimization
% method developed by Mahdi et al.
%
%   :X: Data set
%   :D: Dimension for each subspace
%   :K: Number of subspaces
%   :solver_params: ignored.
%
    options.num_clusters = K;
    result = spx.cluster.subspace.ssc_l1_mahdi(X, options);
end
