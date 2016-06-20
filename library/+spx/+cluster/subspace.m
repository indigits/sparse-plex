classdef subspace

methods(Static)

function result = ssc_l1_mahdi(X, options)
    if nargin > 1
    else
        % empty options
        options = struct;
    end
    cvx_solver sdpt3
    cvx_quiet(true);
    [M, S] = size(X);
    % M is ambient dimension 
    % S is number of signals
    % storage for coefficients
    Z = zeros(S, S);
    for s=1:S
        fprintf('.');
        if (mod(s, 50) == 0)
            fprintf('\n');
        end
        x = X(:, s);
        cvx_begin
        % storage for  l1 solver
        variable z(S, 1);
        minimize norm(z, 1)
        subject to
        x == X*z;
        z(s) == 0;
        cvx_end
        Z(:, s)  = z;
    end
    fprintf('\n');
    W = abs(Z) + abs(Z).';
    result = spx.cluster.spectral.simple.normalized_symmetric(W, options);
    result.Z = Z;
    result.W = W;
end


function result = min_angles_within_between(X, num_points_array)
    % total number of points
    S = sum (num_points_array);
    % Number of clusters
    K = numel(num_points_array);
    [m, n] = size(X);
    if n ~= S
        error('Number of points not matching');
    end
    start_indices = cumsum(num_points_array) + 1;
    start_indices = [1 start_indices(1:end-1)];
    end_indices = start_indices + num_points_array -1;
    result.within_angles = zeros(1, S);
    result.between_angles = zeros(1, S);
    G = abs(X' * X);
    G = min(G, 1);
    for k=1:K
        start_index = start_indices(k);
        end_index = end_indices(k);
        for s =(start_index:end_index)
            prods = G(:, s);
            prods(s) = 0;
            within = prods(start_index:end_index);
            % between
            prods(start_index:end_index) = 0;
            result.within_angles(s) = rad2deg(acos(max(within)));
            result.between_angles(s) = rad2deg(acos(max(prods)));
        end
    end
    result.difference = result.between_angles - result.within_angles    ;
end


function result = affinity(base1, base2)
    % compute the subspace angles
    %  the subspace affinity is used by
    % local subspace affinity algorithm
    thetas = spx.la.spaces.principal_angles_radian(base1, base2);
    % compute the affinity between subspaces
    tmp = sin(thetas).^2;
    result = exp(-sum(tmp));
end

end


end
