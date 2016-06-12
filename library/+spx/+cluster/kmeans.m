classdef kmeans < handle

    methods (Static)
        function [seeds, labels] = pp_initialize(X, k)
            % Finds k initial seed vectors for k-means algorithm
            % Assumes each column of X is an observation

            % dimension of data
            d = size(X, 1);
            % Number of observations
            n = size(X, 2);
            % randomly chosen first centroid
            index = 1 + round(rand * (n - 1));
            % Corresponding first seed vector added to the seeds matrix
            % Note that seeds matrix will be dynamically built column by column.
            seeds = X(:, index);
            % Create a row vector of ones
            % Basically all points are put in 1st cluster
            labels = ones(1, n);
            % We will now choose other seeds one by one
            for i=2:k
                % Subtract every point from its nearest seed vector
                differences = X - seeds(:, labels);
                % Each column is a difference vector
                % Compute squared distances
                sqrd_distances = dot(differences, differences, 1);
                % compute distances
                distances = sqrt(sqrd_distances);
                % Build the CDF over the distances
                cum_distances = cumsum(distances);
                cdf = cum_distances/cum_distances(end);
                % Now the distances are in the range [0, 1]
                % Generate a uniform random variable between 0 and 1
                next = rand;
                % Find the first index in distances cdf just above next. 
                next_index = find(next < cdf, 1);
                seeds(:, i) = X(:, next_index);
                % Assign individual vectors to nearest seed vector
                % See http://statinfer.wordpress.com/2011/12/12/efficient-matlab-ii-kmeans-clustering-algorithm/
                % We don't really need to compute the distances of x_i with seed_i. 
                % All we need is the ranking as to which seed is nearest to x_i
                [~,labels] = max(bsxfun(@minus,2*real(seeds'*X),dot(seeds,seeds,1).'));
            end
        end
    end
end
