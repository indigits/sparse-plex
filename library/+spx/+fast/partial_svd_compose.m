function y = partial_svd_compose(U,S, V,varargin)
    % Computes A only for a subset of indices Omega where
    % A = U S V'
    % Number of rows of A
    M = size(U,1);
    % Number of columns of A
    N = size(V,1);
    % Merge singular values in U
    U = U * diag(S);
    if nargin > 4
        I = varargin{1};
        J = varargin{2};
    else
        omega = varargin{1};
        [I,J] = ind2sub(  [M,N], omega );
    end
    y = mex_partial_svd_compose(U, V, I, J, false);
end

