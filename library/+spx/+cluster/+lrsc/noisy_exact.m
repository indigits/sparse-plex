
function [A,C] = noisy_exact(D,alpha,~)
    % Implements the solution of noisy data with exact condition A = AC
    if nargin < 2
        tau = 100/norm(D)^2;
        alpha = 0.5*tau;
    end
    % eq 41, theorem 5
    threshold = sqrt(2/alpha);
    options = struct;
    options.lambda = threshold;
    options.tolerance =  16*eps;
    % Initial vector
    M = size(D, 1);
    options.p0 = ones(M, 1);
    [U, S, V, details] = spx.fast.lansvd(A, options);
    A = U * diag(S) * V';
    C = V * V';
end

