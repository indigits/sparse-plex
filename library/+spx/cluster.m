classdef cluster

methods(Static)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Following functions are meant for assisting in 
% setting up experiments.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    function labels = labels_from_cluster_sizes(num_points_array)
        % total number of points
        S = sum(num_points_array);
        % Number of points in array
        K = numel(num_points_array);
        labels = zeros(1, S);
        i = 0;
        for k=1:K
            Sk  = num_points_array(k);
            for s=1:Sk
                i = i+1;
                labels(i) = k;
            end
        end
        return;
    end


    function [error_value, mapping] = clustering_error(estimated_labels, true_labels, num_clusters)
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
        error_value  = miss / num_labels;
        % corresponding mapping
        mapping = possible_mappings(index, :);
    end


end

end
