function result  = gomp(Dict, X, K, L, epsilon, options)
    if(isobject(Dict))
        Dict = double(Dict);
    end
    if ~isa(Dict, 'double')
        error('Dict must be a double matrix');
    end
    if nargin < 4
        L = 2;
    end
    if nargin < 5
        epsilon = 1e-3;
    end
    if nargin < 6
        options = struct;
    end
    if ~isfield(options, 'sparse_output')
        options.sparse_output = 1;
    end
    % Options for least squares
    ls_ls = 0;
    ls_chol = 1;
    if ~isfield(options, 'ls_method')
        options.ls_method = 'chol';
    end
    ls_method = ls_chol;
    if strcmp(options.ls_method,'ls')
        ls_method = ls_ls;
    elseif strcmp(options.ls_method, 'chol')
        ls_method = ls_chol;
    end
    if ~isfield(options, 'verbose')
        options.verbose = 0;
    end
    result = mex_gomp(Dict, X, K, L, epsilon, ...
        options.sparse_output,...
        ls_method, ...
        options.verbose);
end
