function result  = mp(Dict, x, options)
% Matching Pursuit
    if nargin < 3
        options = struct;
    end
    if isa(Dict, 'spx.dict.Operator')
        dict = Dict;
    elseif ismatrix(Dict)
        dict = spx.dict.MatrixOperator(Dict); 
    else
        error('Unsupported operator.');
    end
    [m, n] = size(dict);

    % halting criteria
    stop_on_r_norm = false;
    stop_on_iterations = false;
    max_iterations = n;
    max_residual_norm = 0;
    if isfield(options, 'max_iterations')
        stop_on_iterations = true;
        max_iterations = options.max_iterations;
    end
    if isfield(options, 'max_residual_norm')
        stop_on_r_norm = true;
        max_residual_norm = options.max_residual_norm;
    end

    Gamma = [];
    r = x;
    z = zeros(n, 1);
    iter = 0;
    % norm of signal being reconstructed
    x_norm = norm(x);
    while true 
        h = dict.apply_ctranspose(r);
        [~, index] = max(abs(h));
        coeff = h(index);
        z(index) = z(index) + coeff;
        r = r - coeff*dict.column(index);
        r_norm = norm(r);
        iter = iter + 1;
        if stop_on_iterations
            if iter >= max_iterations
                break;
            end
        end
        if stop_on_r_norm
            if r_norm < max_residual_norm
                break;
            end
        end
        if r_norm / x_norm < 1e-6
            % we have reached exact exact recovery
            break;
        end
        if iter > 4*n
            % we have reached highest number of iterations.
            break;
        end
    end
    result.z = z;
    result.r = r;
    result.iterations = iter;
    result.support = find(z);
end
