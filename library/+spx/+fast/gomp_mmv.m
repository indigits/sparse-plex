function result  = gomp_mmv(Dict, X, K, L, T, epsilon, options)
    if(isobject(Dict))
        Dict = double(Dict);
    end
    if ~isa(Dict, 'double')
        error('Dict must be a double matrix');
    end
    if nargin < 4
        L = 1;
    end
    if nargin < 5
        T = 1;
    end
    if nargin < 6
        epsilon = 1e-3;
    end
    if nargin < 7
        options = struct;
    end
    if ~isfield(options, 'sparse_output')
        options.sparse_output = 1;
    end
    if ~isfield(options, 'verbose')
        options.verbose = 0;
    end
    result = mex_gomp_mmv(Dict, X, K, L, T, epsilon, ...
        options.sparse_output,...
        options.verbose);
end
