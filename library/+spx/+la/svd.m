classdef svd

methods(Static)

    function [rank, max_gap] = mahdi_rank(singular_values)
        % rank accordingly to mahdi 2013 heuristic
        [ min_val , ind_min ] = min( diff( singular_values(1:end-1) ) ) ;
        rank = ind_min;
        max_gap = -min_val;
    end

    function rank = vidal_rank(singular_values,kappa)
        if nargin < 2
            kappa = .1;
        end
        % Rank used in Vidal papers
        n = length(singular_values);
        % we will try rank values between 1 to n-1.
        % an array to store criterion value
        criterion = zeros(1, n-1);
        for(r=1:n-1)
            num = singular_values(r+1)^2;
            den = sum(singular_values(1:r).^2);
            criterion(r)=num/den + kappa*r;
        end
        %criterion
        % find the rank with minimum value of the criterion
        [min_value, index]=min(criterion);
        rank = index;
    end


    function result = low_rank_approx(X, r)
        % return low rank approximation of X
        [U S V] = svd(X);
        % keep the first r left singular vectors
        U = U(:, 1:r);
        % keep the first r singular values
        S = S(1:r, 1:r);
        % keep the first r right singular vectors
        V = V(:, 1:r);
        % Return the approximation
        result = U * S * V';
    end

    function [result, basis] = low_rank_projection(X, r)
        % Projects X to a low dimensional space
        % X is NxS
        % result is RxS
        % basis is [NxR] orthonormal basis

        % Compute the SVD
        [U, ~, ~] = svd(X, 0);
        % Choose the low rank basis
        basis = U(:, 1:r);
        % Compute coefficients in this basis
        result = basis' * X;

    function result = low_rank_basis(X, r)
        % Returns the ON basis for low rank approximation
        [U S V] = svd(X, 'econ');
        result = U(:, 1:r);
    end

    function result = low_rank_bases(X, counts, r)
        % low rank bases for individual subspaces
        K = length(counts);
        % bases cell array
        result = cell(1, K);
        [start_indices, end_indices] = spx.cluster.start_end_indices(counts);
        for k=1:K
            ss = start_indices(k);
            ee = end_indices(k);
            XX = X(:, ss:ee);
            basis = spx.la.svd.low_rank_basis(XX, r);
            result{k} = basis;
        end
    end


    function [result, r] = mahdi_rank_basis(X)
        [U S V] = svd(X, 'econ');
        sv = diag(S);
        r = spx.la.svd.mahdi_rank(sv);
        % r = r + 1;
        result = U(:, 1:r);
    end

    function [result, ranks] = mahdi_rank_bases(X, counts)
        % low rank bases for individual subspaces
        K = length(counts);
        % bases cell array
        result = cell(1, K);
        [start_indices, end_indices] = spx.cluster.start_end_indices(counts);
        ranks = zeros(1, K);
        for k=1:K
            ss = start_indices(k);
            ee = end_indices(k);
            XX = X(:, ss:ee);
            [basis,r] = spx.la.svd.mahdi_rank_basis(XX);
            result{k} = basis;
            ranks(k) = r;
        end
    end

    function [result, r] = vidal_rank_basis(X, kappa)
        if nargin < 3
            kappa = 0.1;
        end
        [U S V] = svd(X, 'econ');
        sv = diag(S)';
        r = spx.la.svd.vidal_rank(sv, kappa);
        % r = r + 1;
        result = U(:, 1:r);
    end

    function [result, ranks] = vidal_rank_bases(X, counts, kappa)
        if nargin < 3
            kappa = 0.1;
        end
        % low rank bases for individual subspaces
        K = length(counts);
        % bases cell array
        result = cell(1, K);
        [start_indices, end_indices] = spx.cluster.start_end_indices(counts);
        ranks = zeros(1, K);
        for k=1:K
            ss = start_indices(k);
            ee = end_indices(k);
            XX = X(:, ss:ee);
            [basis,r] = spx.la.svd.vidal_rank_basis(XX, kappa);
            result{k} = basis;
            ranks(k) = r;
        end
    end



end

end