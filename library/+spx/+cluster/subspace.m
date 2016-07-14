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


function result = subspace_preservation_stats(C, cluster_sizes)
    % Returns statistics of subspace preservation
    % We assume that all points within clusters are adjacent to each other
    %spr stands for subspace preserving representation

    labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
    % C must be an SxS square matrix.
    if ~spx.commons.matrix.is_square(C)
        error('C must be a square matrix.');
    end
    % number of points
    S = size(C, 1);
    % checking if the representation is subspace preserving
    spr_flags = zeros(1, S);
    spr_errors = zeros(1, S);
    % we are concerned only with absolute values
    C = abs(C);
    for i=1:S
        % pick the i-th signal
        ci = C(:, i);
        % identify its cluster number
        k = labels(i);
        % identify non-zero entries
        non_zero_indices = (ci >= 1e-3);
        % identify the clusters of corresponding vectors
        non_zero_labels = labels(non_zero_indices);
        % verify that they all belong to same subspace
        spr_flags(i) = all(non_zero_labels == k);
        % flags for current subspace
        w = labels == k;
        % identify entries in current subspace
        cik = ci(w);
        spr_errors(i) = 1 - sum(cik) / sum (ci);
    end
    %spr stands for subspace preserving representation
    result.spr_errors = spr_errors;
    result.spr_error = mean(spr_errors);
    result.spr_flags = spr_flags;
    % all representations are subspace preserving
    result.spr_flag = all(spr_flags);
    % component of subspace preserving representations
    result.spr_component = sum(spr_flags) / S;
    % percentage of subspace preserving representations
    result.spr_perc = result.spr_component * 100;
end

function result = nearest_same_subspace_neighbors_by_inner_product(X, cluster_sizes)
    % it counts the number of nearest neighbors in the same subspace based on inner product. 

    % total number of points
    S = sum (cluster_sizes);
    % Number of clusters
    K = numel(cluster_sizes);
    [M, n] = size(X);
    if n ~= S
        error('Number of points not matching');
    end
    [start_indices, end_indices] = spx.cluster.start_end_indices(cluster_sizes);
    % compute all the inner products
    G = abs(X' * X);
    G = min(G, 1);
    % rad2deg(acos(G))
    % cluster labels of each point
    labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
    result.S = S;
    result.K = K;
    result.cluster_sizes = cluster_sizes;
    result.within_neighbor_counts = zeros(1, S);
    % angle of the nearest neighbor
    result.minimum_angles = zeros(1, S);
    % angle of the nearest neighbor in the same subspace
    result.within_minimum_angles = zeros(1, S);
    % angle of the neighbor in the same subspace before the first bad neighbor
    result.within_maximum_angles = zeros(1, S);
    result.outside_nearest_neighbor_angles = zeros(1, S);
    result.nearst_neighbor_indices = zeros(1, S);
    result.nearst_within_neighbor_indices = zeros(1, S);
    result.nearst_outside_neighbor_indices = zeros(1, S);
    result.nearst_outside_neighbor_absolute_indices = zeros(1, S);
    result.percentile_95 = zeros(1, S);
    result.percentile_98 = zeros(1, S);
    result.SORTED_G = zeros(size(G));
    for s=1:S
        % get the inner products with all vectors
        g = G(:, s);
        % cluster of current vector
        k = labels(s);
        % ignore self.
        g(s) = 0;
        % sort them by decreasing inner product
        [sorted_g, indices] = sort(g, 'descend');
        result.SORTED_G(:, s) = sorted_g;
        % identify corresponding cluster labels
        neighbor_labels = labels(indices);
        % inner products with faces within the cluster
        sorted_g_within = sorted_g(neighbor_labels == k);
        % inner products with faces outside the cluster
        sorted_g_outside = sorted_g(neighbor_labels ~= k);
        % find the first entry from a different cluster
        first_outside_neighbor = find(neighbor_labels ~= k, 1);
        first_within_neighbor = find(neighbor_labels == k, 1);
        result.within_neighbor_counts(s) = first_outside_neighbor - 1;
        result.within_minimum_angles(s) = rad2deg(acos(sorted_g_within(1)));
        result.within_maximum_angles(s) = rad2deg(acos(sorted_g_within(end-1)));
        result.nearst_within_neighbor_indices(s) = find(neighbor_labels == k, 1);
        result.minimum_angles(s) = rad2deg(acos(sorted_g(1)));
        result.nearst_neighbor_indices(s) = indices(1);
        result.outside_nearest_neighbor_angles(s) = rad2deg(acos(sorted_g(first_outside_neighbor)));
        result.nearst_outside_neighbor_indices(s) = first_outside_neighbor;
        result.nearst_outside_neighbor_absolute_indices(s) = indices(first_outside_neighbor);
        % divide with the largest inner product value
        normalized_sorted_g = sorted_g / sorted_g(1);
        result.percentile_95(s) = sum(normalized_sorted_g > .95);
        result.percentile_98(s) = sum(normalized_sorted_g > .98);
    end
    result.first_in_out_angle_spreads = result.outside_nearest_neighbor_angles - result.within_minimum_angles;
    result.no_within_neighbor_count = sum(result.within_neighbor_counts == 0);
    result.no_within_neighbor_component = result.no_within_neighbor_count/S;
    result.no_within_neighbor_perc = result.no_within_neighbor_component * 100;


    % Let us compute the first residual for each point within its subspace
    R = zeros(size(X));
    res_norms = zeros(1, S);
    for s=1:S
        x = X(:, s);
        within_nearest_neighbor_index = result.nearst_within_neighbor_indices(s);
        z = X(:, within_nearest_neighbor_index);
        % compute residual
        r = (eye(M) - z * z') * x; 
        r_norm = norm(r);
        res_norms(s) = r_norm;
        if r_norm ~= 0
            r = r ./r_norm;
        end
        R(:, s) = r;
    end
    % Now identify nearest neighbors for residuals
    for s=1:S
        % get the inner products with all vectors
        r = R(:, s);
        % inner products
        g = X' * r;
        % ignore the s-th data-point
        g (s)  = 0;
        % clean-up
        g  = abs(g);
        g  = min(g, 1);
        % cluster of current vector
        k = labels(s);
        % sort them by decreasing inner product
        [sorted_g, indices] = sort(g, 'descend');
        % identify corresponding cluster labels
        neighbor_labels = labels(indices);
        % inner products with faces within the cluster
        sorted_g_within = sorted_g(neighbor_labels == k);
        % inner products with faces outside the cluster
        sorted_g_outside = sorted_g(neighbor_labels ~= k);
        % find the first entry from a different cluster
        first_outside_neighbor = find(neighbor_labels ~= k, 1);
        first_within_neighbor = find(neighbor_labels == k, 1);
        result.r1_within_neighbor_counts(s) = first_outside_neighbor - 1;
        result.r1_within_minimum_angles(s) = rad2deg(acos(sorted_g_within(1)));
        result.r1_within_maximum_angles(s) = rad2deg(acos(sorted_g_within(end-1)));
        result.r1_nearst_within_neighbor_indices(s) = find(neighbor_labels == k, 1);
        result.r1_minimum_angles(s) = rad2deg(acos(sorted_g(1)));
        result.r1_nearst_neighbor_indices(s) = indices(1);
        result.r1_outside_nearest_neighbor_angles(s) = rad2deg(acos(sorted_g(first_outside_neighbor)));
        result.r1_nearst_outside_neighbor_indices(s) = first_outside_neighbor;
        result.r1_nearst_outside_neighbor_absolute_indices(s) = indices(first_outside_neighbor);
        % divide with the largest inner product value
        normalized_sorted_g = sorted_g / sorted_g(1);
        result.r1_percentile_95(s) = sum(normalized_sorted_g > .95);
        result.r1_percentile_98(s) = sum(normalized_sorted_g > .98);
    end    
    result.r1_first_in_out_angle_spreads = result.r1_outside_nearest_neighbor_angles - result.r1_within_minimum_angles;
    result.r1_no_within_neighbor_count = sum(result.r1_within_neighbor_counts == 0);
    result.r1_no_within_neighbor_component = result.r1_no_within_neighbor_count/S;
    result.r1_no_within_neighbor_perc = result.r1_no_within_neighbor_component * 100;
end


function print_nearest_neighbor_result(result)
    S = result.S;
    fprintf('Within Neighbor Counts:\n %s\n', spx.stats.format_descriptive_statistics(result.within_neighbor_counts));
    fprintf('Nearest Within Neighbor Indices:\n %s\n', spx.stats.format_descriptive_statistics(result.nearst_within_neighbor_indices));
    nearst_within_neighbor_indices = result.nearst_within_neighbor_indices;
    % club all those cases where nearest within neighbor is far away.
    nearst_within_neighbor_indices(nearst_within_neighbor_indices > 10) = -1;
    tabulate(nearst_within_neighbor_indices);

    fprintf('Within Minimum Angles:\n %s\n', spx.stats.format_descriptive_statistics(result.within_minimum_angles));
    fprintf('Within Maximum Angles:\n %s\n', spx.stats.format_descriptive_statistics(result.within_maximum_angles));
    fprintf('Outside Nearest Angles:\n %s\n', spx.stats.format_descriptive_statistics(result.outside_nearest_neighbor_angles));

    fprintf('First In Out Angle Spreads:\n %s\n', spx.stats.format_descriptive_statistics(result.first_in_out_angle_spreads));
    fioas = result.first_in_out_angle_spreads;
    %fioas = round(fioas * 10) / 10;
    fioas = round(fioas/4)*4;
    fioas(fioas > 8) = 100;
    fioas(fioas < -8) = 100;
    angle_gt_zero_flags = result.first_in_out_angle_spreads >= 0;
    angle_gte_zero = result.first_in_out_angle_spreads(angle_gt_zero_flags);
    angle_lte_two_flags =  angle_gte_zero <= 2;
    angle_lte_four_flags =  angle_gte_zero <= 4;
    angle_lte_eight_flags =  angle_gte_zero <= 8;
    angle_lt_zero_flags = result.first_in_out_angle_spreads < 0;
    angle_lt_zero =  result.first_in_out_angle_spreads(angle_lt_zero_flags);
    angle_gte_minus_two_flags =  angle_lt_zero >= -2;
    angle_gte_minus_four_flags =  angle_lt_zero >= -4;
    abs_angle_lte_four_flags = abs(result.first_in_out_angle_spreads) <=4;
    fprintf('angle greater than equal to 0: %.2f %%\n', sum(angle_gt_zero_flags) * 100 / S);
    fprintf('angle less than 2: %.2f %%\n', sum(angle_lte_two_flags) * 100 / S);
    fprintf('angle less than 4: %.2f %%\n', sum(angle_lte_four_flags) * 100 / S);
    fprintf('angle less than 8: %.2f %%\n', sum(angle_lte_four_flags) * 100 / S);
    fprintf('angle less than 0: %.2f %%\n', sum(angle_lt_zero_flags) * 100 / S);
    fprintf('angle greater than -2: %.2f %%\n', sum(angle_gte_minus_two_flags) * 100 / S);
    fprintf('angle greater than -4: %.2f %%\n', sum(angle_gte_minus_four_flags) * 100 / S);
    fprintf('abs angle less than 4: %.2f %%\n', sum(abs_angle_lte_four_flags) * 100 / S);

    fprintf('95 percentile of maximum inner product:\n %s\n', spx.stats.format_descriptive_statistics(result.percentile_95));
    tabulate(result.percentile_95);
    fprintf('98 percentile of maximum inner product:\n %s\n', spx.stats.format_descriptive_statistics(result.percentile_98));
    tabulate(result.percentile_98);

    fprintf('\n\n1st Residual\n\n');
    fprintf('Within Neighbor Counts:\n %s\n', spx.stats.format_descriptive_statistics(result.r1_within_neighbor_counts));
    fprintf('Nearest Within Neighbor Indices:\n %s\n', spx.stats.format_descriptive_statistics(result.r1_nearst_within_neighbor_indices));
    r1_nearst_within_neighbor_indices = result.r1_nearst_within_neighbor_indices;
    % club all those cases where nearest within neighbor is far away.
    r1_nearst_within_neighbor_indices(r1_nearst_within_neighbor_indices > 35) = -1;
    tabulate(r1_nearst_within_neighbor_indices);

    fprintf('Within Minimum Angles:\n %s\n', spx.stats.format_descriptive_statistics(result.r1_within_minimum_angles));
    fprintf('Within Maximum Angles:\n %s\n', spx.stats.format_descriptive_statistics(result.r1_within_maximum_angles));
    fprintf('Outside Nearest Angles:\n %s\n', spx.stats.format_descriptive_statistics(result.r1_outside_nearest_neighbor_angles));

    fprintf('First In Out Angle Spreads:\n %s\n', spx.stats.format_descriptive_statistics(result.r1_first_in_out_angle_spreads));

    fprintf('95 percentile of maximum inner product:\n %s\n', spx.stats.format_descriptive_statistics(result.r1_percentile_95));
    tabulate(result.r1_percentile_95);
    fprintf('98 percentile of maximum inner product:\n %s\n', spx.stats.format_descriptive_statistics(result.r1_percentile_98));
    tabulate(result.r1_percentile_98);
end



end


end
