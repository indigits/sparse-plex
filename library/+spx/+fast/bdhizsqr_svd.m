function [U, S, V]  = bdhizsqr_svd(alpha, beta, options)
    if nargin < 3
        options = struct;
    end
    n = numel(alpha);
    if nargout <= 1
        U = mex_svd_bd_hizsqr(alpha, beta, options);
    else if nargout == 2
        [U, S] = mex_svd_bd_hizsqr(alpha, beta, options);
    else 
        [U, S, V] = mex_svd_bd_hizsqr(alpha, beta, options);
        V = V.';
        S = spdiags(S, [0], n, n);
    end
end
