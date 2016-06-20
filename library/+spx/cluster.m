classdef cluster

methods(Static)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Following functions are meant for assisting in 
% setting up experiments.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    function labels = labels_from_cluster_sizes(cluster_sizes)
        % total number of points
        S = sum(cluster_sizes);
        % Number of points in array
        K = numel(cluster_sizes);
        labels = zeros(1, S);
        i = 0;
        for k=1:K
            Sk  = cluster_sizes(k);
            for s=1:Sk
                i = i+1;
                labels(i) = k;
            end
        end
        return;
    end

    function [start_indices, end_indices] = start_end_indices(cluster_sizes)
        % Returns start and end indices from cluster sizes
        start_indices = cumsum(cluster_sizes) + 1;
        start_indices = [1 start_indices(1:end-1)];
        end_indices = start_indices + cluster_sizes -1;
    end

    function result = clustering_error(estimated_labels, true_labels, num_clusters)
        % finds out an appropriate mapping between
        % true labels and estimated labels and 
        % calculates the corresponding clustering error

        % make sure that both are row vectors
        if ~isrow(estimated_labels)
            estimated_labels = estimated_labels';
        end
        if ~isrow(true_labels)
            true_labels = true_labels';
        end
        if size(estimated_labels) ~= size(true_labels)
            error('Both estimated and true label arrays should have same size.');
        end
        % Let us consider all possible mappings
        possible_mappings = perms(1:num_clusters);
        % number of possible mappings
        num_mappings = size(possible_mappings,1 );
        % number of labels
        num_labels = size(estimated_labels, 2);
        % number of misclustered points for each mapping
        missed_points = zeros(num_mappings, 1);
        for j=1:num_mappings
            %cur_mapping = possible_mappings(j, :)
            mapped_labels = possible_mappings(j, true_labels);
            missed_points(j) = sum(estimated_labels ~= mapped_labels);
        end
        % missed_points
        % we choose the mapping with minimum mismatch
        [miss, index] = min(missed_points, [], 1);
        % final clustering error value
        result.num_labels = num_labels;
        result.num_missed_points = miss;
        result.error  = miss / num_labels;
        % corresponding mapping
        result.mapping = possible_mappings(index, :);
        result.mapped_labels = result.mapping(true_labels);
        result.misses = estimated_labels ~= result.mapped_labels;
    end


end

end
