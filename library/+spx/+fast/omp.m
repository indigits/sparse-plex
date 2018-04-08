function result  = omp(Dict, X, K, epsilon)
    if(isobject(Dict))
        Dict = double(Dict);
    end
    if ~isa(Dict, 'double')
        error('Dict must be a double matrix');
    end
    result = mex_omp_chol(Dict, X, K, epsilon);
end