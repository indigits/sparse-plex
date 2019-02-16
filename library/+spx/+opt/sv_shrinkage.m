function Y = sv_shrinkage(A, kappa)
% Performs shrinkage over the singular values
    % y = max(0, a-kappa) + min(0, a+kappa);
    [U, S, V] = svd(A, 'econ');
    S = diag(S);
    % identify singular values bigger than threshold
    ind = find(S > kappa);
    % Construct the singular value sub-matrix
    % After shrinkage of singular values
    S = diag(S(ind) - kappa);
    % Corresponding left singular vectors
    U = U(:, ind);
    % Corresponding right singular vectors
    V = V(:, ind);
    % Result
    Y = U * S * V';
end

