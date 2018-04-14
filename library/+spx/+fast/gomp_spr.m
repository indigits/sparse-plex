function result  = gomp_spr(Y, K, L, epsilon, options)
    if nargin < 3
        L = 2;
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
    result = mex_gomp_spr(Y, K, L, epsilon, ...
        options.sparse_output,...
        options.verbose);
end
