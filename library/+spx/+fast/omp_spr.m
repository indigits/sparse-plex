function result  = omp_spr(Y, K, epsilon, sparse_output)
    if nargin < 4
        sparse_output = 1;
    end
    Y_normalized = spx.norm.normalize_l2(Y);
    result = mex_omp_spr(Y, Y_normalized, K, epsilon, sparse_output);
end
