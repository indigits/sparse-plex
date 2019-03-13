classdef eig

methods(Static)

function [x, lambda, details] = power(A, x, tolerance, options)
    if nargin < 3
        options = struct;
    end
    tolerance = 1e-6;
    if isfield(options, 'tolerance')
        tolerance = options.tolerance;
    end
    max_iterations = 100;
    if isfield(options, 'max_iterations')
        max_iterations = options.max_iterations;
    end
    if nargin < 2
        x = zeros(size(A, 2),1);
        x(1) = 1;
    end
    % Power method for computing largest eigen-value
    gap = 1;
    prev_lambda = norm(x);
    iter = 0;
    details.lambdas = [];
    while gap > tolerance && iter < max_iterations
        %  Apply the matrix
        y = A * x;
        % current norm
        lambda = norm(y);
        % eigen gap
        gap = abs(lambda  - prev_lambda);
        % normalize
        x = y / lambda;
        % keep previous lambda
        prev_lambda = lambda;
        iter = iter + 1;
        details.lambdas(end + 1) = lambda;
    end % while
    details.iterations = iter;
end % function

function [T, U, details] = qr_simple(A, options)
    if nargin < 2
        options = struct;
    end
    [m, n] = size(A);
    U = eye(n);
    tolerance = 1e-2;
    if isfield(options, 'tolerance')
        tolerance = options.tolerance;
    end
    max_iterations = 30;
    if isfield(options, 'max_iterations')
        max_iterations = options.max_iterations;
    end
    T = A;
    lambda_prev = ones(n, 1);
    iter = 0;
    gap = 1;
    while gap > tolerance && iter < max_iterations
        [Q, R] =  qr(T);
        T = R * Q;
        U = U * Q;
        iter = iter + 1;
        % pick the approximate eigen values from the diagonal
        lambdas = diag(T);
        % compute the ratio with previous values on diagonal
        gap = lambdas ./ lambda_prev;
        % measure how close are the ratios with 1
        gap = abs(abs(gap) - 1);
        % maximum ratio
        gap = max(max(gap));
        lambda_prev = lambdas;
    end % while
    details.iterations = iter;
end % function

end % methods
end  % classdef


