%--------------------------------------------------------------------------
% C = lrsc(A,tau)
% Low Rank Subspace Clustering algorithm for clean data lying in a 
% union of subspaces
%
% C = argmin |C|_* + tau/2 * |A - AC|_F^2 s.t. C = C'
%
% A: clean data matrix whose columns are points in a union of subspaces
% tau: scalar parameter 
%--------------------------------------------------------------------------
% Adapted from LRSC by @ Rene Vidal, November 2012
%--------------------------------------------------------------------------

function C = clean_relaxed(A,tau)
% Make an estimate of tau if necessary
    if nargin < 2
        tau = 100/norm(A)^2;
    end
    threshold = 1/sqrt(tau)
    options = struct;
    options.lambda = threshold;
    options.tolerance =  16*eps;
    M = size(A, 1);
    options.p0 = ones(M, 1);
    % options.k = 200;
    [~, S, V, details] = spx.fast.lansvd(A, options);
    spx.io.print.vector(S);
    r = numel(S)
    C = V * (eye(r) - diag(1./(S.^2)/tau)) * V';
end
