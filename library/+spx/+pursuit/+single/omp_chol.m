function result  = omp_chol(Dict, x, K, epsilon)
    % support
    Gamma = [];
    r = x;
    L = [1];
    % proxy
    p = Dict' * x;
    k = 1;
    res_norm = norm(r);
    while (k <= K && res_norm > epsilon)
        h = Dict' * r;
        [~, max_ind] = max(abs(h));
        if k > 1
            b = Dict(:, Gamma)' * Dict(:, max_ind);
            opts = struct();
            opts.LT= true;
            w = linsolve(L, b, opts);
            L = [L ones(k -1, 1); w' sqrt(1 - w' * w)];
        end
        Gamma = [Gamma max_ind];
        % now solve for the coefficients using LL' z = p(:,Gamma)
        opts = struct();
        opts.LT = true;
        z1 = linsolve(L, p (Gamma), opts);
        opts = struct();
        opts.LT = true;
        opts.TRANSA = true;
        z2 = linsolve(L, z1, opts);
        % update residual
        D2 = Dict(:, Gamma);
        r = x  -   D2 * z2;
        % update iteration counter
        k  = k + 1;
        % update residual norm
        res_norm = norm(r);
    end
    z = zeros(size(Dict, 2), 1);
    z(Gamma) = z2;
    % Solution vector
    result.z = z;
    % Residual obtained
    result.r = r;
    % Number of iterations
    result.iterations = k;
    % Solution support
    result.support = Gamma;
end
