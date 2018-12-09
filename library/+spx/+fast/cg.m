function result  = cg(A, x, options)
% Conjugate Gradients
    if(isobject(A))
        A = double(A);
    end
    if ~isa(A, 'double')
        error('A must be a double matrix');
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
    if ~isfield(options, 'tolerance')
        options.tolerance = 0;
    end
    x = mex_cg(A, x, options.max_iterations, ...
        options.tolerance, ...
        options.sparse_output,...
        options.verbose);
    result.x = x;
    % result.r = r;
    % result.iterations = iter;
    % result.support = find(z);
end
