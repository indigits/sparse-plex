function result  = omp(Dict, X, K, epsilon)
    if(isobject(Dict))
        Dict = double(Dict);
    end
    if ~isa(Dict, 'double')
        error('Dict must be a double matrix');
    end
    [M, S] = size(X);
    N = size(Dict, 2);
    result = zeros(N, S);
    for s=1:S
        result(:, s) = mex_omp_chol(Dict, X(:, s), K, epsilon);
    end
end