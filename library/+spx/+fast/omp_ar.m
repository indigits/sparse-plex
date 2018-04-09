function result  = omp_ar(Dict, X, K, epsilon, options)
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
    if ~isfield(options, 'threshold_factor')
        options.threshold_factor = 2;
    end
    if ~isfield(options, 'reset_cycle')
        options.reset_cycle = 5;
    end
    if ~isfield(options, 'verbose')
        options.verbose = 0;
    end
    if ~isfield(options, 'sparse_output')
        options.sparse_output = 1;
    end

    [M, S] = size(X);
    N = size(Dict, 2);

    result = mex_omp_ar(Dict, X, K, epsilon, ...
        options.threshold_factor, ...
        options.reset_cycle, ...
        options.sparse_output, ...
        options.verbose);
end
