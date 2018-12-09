function result  = mp(Dict, x, options)
% Matching Pursuit
    if(isobject(Dict))
        Dict = double(Dict);
    end
    if ~isa(Dict, 'double')
        error('Dict must be a double matrix');
    end
    if nargin < 3
        options = struct;
    end
    if ~isfield(options, 'sparse_output')
        options.sparse_output = 1;
    end
    if ~isfield(options, 'verbose')
        options.verbose = 0;
    end
    if ~isfield(options, 'max_iterations')
        options.max_iterations = 0;
    end
    if ~isfield(options, 'max_residual_norm')
        options.max_residual_norm = 0;
    end
    z = mex_mp(Dict, x, options.max_iterations, ...
        options.max_residual_norm, ...
        options.sparse_output,...
        options.verbose);
    result.z = z;
    % result.r = r;
    % result.iterations = iter;
    % result.support = find(z);
end
