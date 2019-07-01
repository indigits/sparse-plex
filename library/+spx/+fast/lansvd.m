function [U, S, V, details]  = lansvd(A, varargin)
    % We need to parse the options one by one
    params = inputParser;
    params.addRequired('A');
    % Number of singular values to compute
    params.addParameter('k', NaN);
    % Threshold for singular values
    params.addParameter('lambda', NaN);
    % Desired level of orthogonality
    params.addParameter('delta', -1);
    % Desired level of orthogonality after reorthogonalization
    params.addParameter('eta', -1);
    % Tolerance for iterated Gram-Schmidt procedure
    params.addParameter('gamma', -1);
    % Flag for classic/modified Gram-Schmidt
    params.addParameter('cgs', true);
    % Flag for extended local reorthogonalization
    params.addParameter('elr', false);
    % Verbosity level
    params.addParameter('verbosity', 0);
    % Maximum number of iterations
    params.addParameter('max_iters', -1);
    % Tolerance for convergence of singular values
    params.addParameter('tolerance', -1);
    % Initial vector specified by user
    params.addParameter('p0', []);
    % Parse the results
    params.parse(A, varargin{:});
    results = params.Results;
    options = struct;
    if(isobject(A))
        A = double(A);
    end
    if ~isnan(results.k)
        options.k = results.k;
    end
    if ~isnan(results.lambda)
        options.lambda = results.lambda;
    end
    if ~isfield(options, 'k') && ~isfield(options, 'lambda')
        % By default we compute 6 singular values
        options.k = 6;
    end
    options.delta  = results.delta;
    options.eta  = results.eta;
    options.gamma = results.gamma;
    options.cgs = results.cgs;
    options.elr = results.elr;
    options.verbosity = results.verbosity;
    options.max_iters = results.max_iters;
    options.tolerance = results.tolerance;
    if ~isempty(results.p0)
        options.p0 = results.p0;
    end
    [U, S, V, alpha, beta, p, details] = mex_lansvd(A, options);
    % number of Lanczos vectors computed
    k_done = size(alpha, 1);
    p_norm = beta(k_done+1);
    if isfield(options, 'k')
        k = options.k;
    end
    if isfield(options, 'lambda')
        k = find(S <= options.lambda,1) - 1;
    end
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
