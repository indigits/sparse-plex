classdef pca  
% Methods related to principal component analysis

methods(Static)


%% low_rank_approx: Computes the lower rank approximation of a data set
function Xp = low_rank_approx(X, n)
    % X : the data set to be approximated
    % n : number of dimensions
    [M, S] = size(X);
    if n == 0
        Xp = X;
        return;
    end
    if min(M, S) > 5000
        error('Matrix is too big.');
    end
    if M <= S
        % We have more columns
        % wide matrix
        % We compute the frame matrix
        F = X * X'; % [M \times M]
        % perform eigen value decomposition
        [U, lambda] = eig(F);
        % F is positive semi-definite. All 
        % eigen values are non-negative
        % sort them in descending order.
        [~, index] = sort(-diag(lambda));
        % Construct the basis
        U = U(:, index(1:n));
        % Compute coefficients
        Xp = U' * X;
    else
        % We have more rows than columns
        % tall matrix
        % We compute the gram matrix
        G = X' * X; % S \times S
        % perform eigen value decomposition
        [V, lambda] = eig(G);
        % eigen values are non-negative
        % sort them in descending order.
        lambda = diag(lambda);
        [~, index] = sort(-lambda);
        % Keep the part of V
        V = V(:, index(1:n));
        % corresponding eigen values
        lambda = lambda(index(1:n));
        % compute their square root and diagonalize
        lambda = lambda .^(.5);
        lambda = diag(lambda);
        % Compute the approximation
        Xp = lambda * V';
    end
end






end
end