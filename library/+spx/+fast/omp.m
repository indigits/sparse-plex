function result  = omp(Dict, X, K, epsilon, options)
    if(isobject(Dict))
        Dict = double(Dict);
    end
    if ~isa(Dict, 'double')
        error('Dict must be a double matrix');
    end
    if nargin < 4
        epsilon = 1e-3;
    end
    if nargin < 5
        options = struct;
    end
    if ~isfield(options, 'sparse_output')
        options.sparse_output = 1;
    end
    if ~isfield(options, 'verbose')
        options.verbose = 0;
    end
    result = mex_omp_chol(Dict, X, K, epsilon, ...
        options.sparse_output,...
        options.verbose);
end
