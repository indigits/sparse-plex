classdef subspaces
% Generates subspaces of various kinds.

methods(Static)

    function bases = random_subspaces(N, K, Ds)
        % D dimensional random subspaces
        % in N dimensional space
        % N = ambient dimension
        % K = number of subspaces
        % Ds dimensions of subspaces
        if numel(Ds) == 1
            Ds = ones(1, K) * Ds;
        elseif numel(Ds) ~= K
            error('K and numel(Ds) dont match');     
        end
        bases = cell(1, K);
        for k=1:K
            D = Ds(k);
            basis = orth(randn(N, D));
            bases{k} = basis;
        end
    end

    function result = uniform_points_on_subspaces(bases, points_per_subspace)
        % bases is a cell array containing ONB for each subspace.
        % points_per_subspace is an array containing number of points
        % to be sampled from each subspace.
        K = numel(bases);
        if isscalar(points_per_subspace)
            points_per_subspace = points_per_subspace * ones(1, K);
        end
        if K ~= numel(points_per_subspace)
            error('Invalid points_per_subspace array.');
        end
        % Total number of points
        S = sum(points_per_subspace);
        % The ambient dimension
        M = size(bases{1}, 1);
        % storage for points
        X = zeros(M, S);
        start_indices = cumsum(points_per_subspace) + 1;
        start_indices = [1 start_indices(1:end-1)];
        end_indices = start_indices + points_per_subspace -1;
        for k=1:K
            start_index = start_indices(k);
            end_index = end_indices(k);
            num_points = points_per_subspace(k);
            basis = bases{k};
            % subspace dimension
            D = size(basis, 2);
            coefficients = randn(D, num_points);
            % normalize columns
            coefficients = spx.commons.norm.normalize_l2(coefficients);
            X(:, start_index:end_index) = basis * coefficients;
        end
        % Make sure that all points are normalized
        X = spx.commons.norm.normalize_l2(X);
        result.X = X;
        result.start_indices = start_indices;
        result.end_indices = end_indices;
    end
end

end
