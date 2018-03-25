function result  = fast_batch_omp_spr(Y, K, epsilon, sparse_output)
    if nargin < 4
        sparse_output = 1;
    end
    result = mex_batch_omp_spr(Y, K, epsilon, sparse_output);
end
