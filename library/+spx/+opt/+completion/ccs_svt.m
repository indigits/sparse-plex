function [U, S, V, details] = ccs(Y, varargin)
% Matrix completion using singular value thresholding
% as proposed by Cai, Candes and Shen.

    % We need to parse the options one by one
    params = inputParser;
    params.addRequired('Y');
    if ~issparse(Y)
        error('The incomplete data matrix must be sparse.');
    end
    % split the data and indices of the sparse matrix
    [b, omega, n1, n2] = spx.sparse.split_data_indices(Y);
    % The size of data matrix
    sz = n1 * n2;
    % Number of non-zero entries
    m = numel(omega);
    % incoherence factor
    % rough ratio of the Frobenius norm of original matrix
    % vs the sampled points matrix
    % eq 5.2
    p = m / (n1 * n2);
    % Maximum number of iterations
    params.addParameter('max_iters', 500);
    % Tolerance for convergence of the algorithm
    params.addParameter('tolerance', -1);
    params.addParameter('tau', 5 * sqrt(sz));
    params.addParameter('delta', 1.2/ p);
    % Verbosity level
    params.addParameter('verbosity', 0);

    % Parse the input data
    params.parse(Y, varargin{:});
    results = params.Results;
    delta = results.delta;
    tau = results.tau;
    max_iters = results.max_iters;
    tolerance = results.tolerance;
    verbosity = results.verbosity;
    if verbosity >= 1
        fprintf('size: %d x %d, %.1f%% observations\n', ...
            n1, n2, 100*p);
        fprintf('tau: %.2f, delta: %.4f, tolerance: %.2e, max_iters: %d\n', ...
            tau, delta, tolerance, max_iters);
    end

    % Estimate the norm of input matrix
    a_norm_est = normest(Y, 1e-2);
    % Number of steps to skip in the beginning
    k0 = ceil(tau/ (delta * a_norm_est));
    % Norm of all the non-zero entries in Y
    norm_b = norm(b);
    % scaling the contents of Y with the kicking factor
    y = k0 * delta * b;
    spx.fast.update_sparse_data(Y, y);

    details = struct;
    % data capture for debugging purposes
    details.rel_error = zeros(max_iters, 1);
    details.rank = zeros(max_iters, 1);
    details.time = zeros(max_iters, 1);
    details.nuclear_norm = zeros(max_iters, 1);

    svd_time = 0;
    x_update_time = 0;
    y_update_time = 0;
    for iter=1:max_iters
        % Compute all the singular values and vectors above tau
        tstart = tic;
        [U,S, V, svd_details] = spx.fast.lansvd(Y, 'lambda', tau);
        svd_time = svd_time + toc(tstart);
        % current rank
        r = numel(S);
        % smallest singular value
        ssv = S(end);
        % perform shrinkage
        S = S - tau;
        % Compute X over the Omega
        tstart = tic;
        x = spx.fast.partial_svd_compose(U, S, V, omega);
        x_update_time = x_update_time + toc(tstart);
        tstart = tic;
        % Measure the relative error
        residual = b - x;
        relative_error = norm(residual) / norm_b;
        details.rel_error(iter) = relative_error;
        details.rank(iter) = r;
        details.nuclear_norm(iter) = sum(S);
        if verbosity >= 1
            fprintf('iteration [%d], rank: %d, ssv: %.2f, error: %.2e\n',...
                iter, r, ssv, relative_error);
        end
        if (relative_error < tolerance)
            % No further work required
            break;
        end
        if (relative_error > 1e5)
            error('Divergence');
            break;
        end
        % Let's update the values
        y = y + delta*residual;
        spx.fast.update_sparse_data(Y, y);
        y_update_time = y_update_time + toc(tstart);
    end % for iter
    details.iterations = iter;
    details.svd_time = svd_time;
    details.x_update_time = x_update_time;
    details.y_update_time = y_update_time;
end % function
