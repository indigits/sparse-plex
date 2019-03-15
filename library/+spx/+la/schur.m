classdef schur
% Methods for computing the Schur form

methods(Static)

function [H, U, details] = qr_hessenberg(A, options)
    % Computes the eigen values of A through
    % QR algorithm based on Hessenberg decomposition
    % GVL4 : Equation 7.5.1
    if nargin < 2
        options = struct;
    end
    [m, n] = size(A);
    tolerance = 1e-6;
    if isfield(options, 'tolerance')
        tolerance = options.tolerance;
    end
    max_iterations = 30;
    if isfield(options, 'max_iterations')
        max_iterations = options.max_iterations;
    end
    import spx.la.hessenberg;
    % Compute the Hessenberg form of A
    [H, U0] = hessenberg.hess(A);
    U = U0;
    iter = 0;
    gap = 1;
    lambda_prev = ones(n, 1);
    % Perform Hessenberg QR iterations
    while gap > tolerance && iter < max_iterations
        %  Perform one QR factorization of H
        [H, cs, ss] = hessenberg.qr_rq(H);
        % Update U
        for k=1:n-1
            G = [cs(k) ss(k); -ss(k) cs(k)];
            U(:,k:k+1) = U(:,k:k+1)*G;
        end
        % pick the approximate eigen values from the diagonal
        lambdas = diag(H);
        % compute the ratio with previous values on diagonal
        gap = lambdas ./ lambda_prev;
        % measure how close are the ratios with 1
        gap = abs(abs(gap) - 1);
        % maximum ratio
        gap = max(max(gap));
        lambda_prev = lambdas;
        iter = iter + 1;
    end % while
    details.iterations = iter;
end % functions


end % methods
end  % classdef


