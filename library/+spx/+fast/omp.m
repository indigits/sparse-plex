function result  = omp(Dict, X, K, epsilon)
    [M, S] = size(X);
    N = size(Dict, 2);
    result = zeros(N, S);
    for s=1:S
        result(:, s) = mex_omp_chol(Dict, X(:, s), K, epsilon);
    end
end