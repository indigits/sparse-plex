function [U, S, V, details]  = lansvd(A, k, options)
    if(isobject(A))
        A = double(A);
    end
    if nargin < 3
        options = struct;
    end
    if nargin < 2
        k = 6;
    end
    [U, S, V, alpha, beta, p, details] = mex_lansvd(A, k, options);
    % number of Lanczos vectors computed
    k_done = size(alpha, 1);
    p_norm = beta(k_done+1);
    % Let's compute all the singular vectors if requested by caller
    if nargout>2 % computation of Ritz vectors
        % Form the k+1 x k bidiagonal matrix from alpha and beta
        B = spdiags([alpha(1:k_done) beta(2:k_done+1)], [0, -1], k_done+1, k_done);
        % Compute singular vectors
        [P,S,Q] = svd(full(B),0);
        % Singular values 
        S = diag(S);
        % Keep the relevant K columns
        if size(Q,2)~=k
            Q = Q(:,1:k); 
            P = P(:,1:k);
        end
        % Compute and normalize Ritz vectors (overwrites U and V to save memory).
        if p_norm~=0
            U = U*P(1:k_done,:) + (p/p_norm)*P(k_done+1,:);
        else
            U = U*P(1:k_done,:);
        end
        V = V*Q;
        % Make sure that the requested Ritz vectors are normalized
        for i=1:k     
            nq = norm(V(:,i));
            if isfinite(nq) & nq~=0 & nq~=1
              V(:,i) = V(:,i)/nq;
            end
            nq = norm(U(:,i));
            if isfinite(nq) & nq~=0 & nq~=1
              U(:,i) = U(:,i)/nq;
            end
        end
    end % computation of Ritz vectors
    % Pick out desired part the spectrum
    S = S(1:k);
    if nargout == 1
        U = S;
    end
    if nargout >= 4
        details.alpha = alpha;
        details.beta = beta;
        details.p = p;
        details.k_done = k_done;
    end
end
