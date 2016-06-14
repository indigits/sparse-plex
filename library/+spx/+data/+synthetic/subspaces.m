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
end

end
