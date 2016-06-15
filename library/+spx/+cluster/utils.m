classdef utils

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


end

end
