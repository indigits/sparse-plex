classdef SPX_Similarity
    % Functions for measuring distances and similarities
    properties
    end

    methods(Static)

        function result = gaussian_similarity(dist_matrix, sigma)
            % Converts a distance matrix to Gaussian similarity matrix
            if (nargin < 2)
                sigma = 1;
            end
            % Compute the Gaussian similarity
            d = dist_matrix.^2 / (2 * sigma^2);
            result = exp(-d);
        end

        function result = gauss_sim_from_sqrd_dist_mat(sqrd_dist_mat, sigma)
            % Converts a squared distance matrix to Gaussian similarity matrix
            if (nargin < 2)
                sigma = 1;
            end
            % Compute the Gaussian similarity
            d = sqrd_dist_mat ./ (2 * sigma^2);
            result = exp(-d);
        end

        function result = esp_neighborhood_similarity(dist_matrix, threshold)
            % number of points
            n = size(dist_matrix, 1);
            % Create the similarity matrix.
            result = dist_matrix < threshold;
        end

        function result = filter_k_nearest_neighbors(sim_matrix, K)
            % Filters a similarity matrix to K-nearest neighbors

            % number of columns
            n = size(sim_matrix, 2);
            % iterate over columns
            for c=1:n
                col = sim_matrix(:, c);
                % sort the column in descending order
                [~,indices] = sort(col,'descend');
                % remove the entries from sim_matrix which is lower than k indices
                sim_matrix(indices(K+1:end), c) = 0;
            end
            % Now ensure symmetry
            for c=1:n
                for r=c+1:n
                    v1 = sim_matrix(r, c);
                    v2 = sim_matrix(c, r);
                    if v1 == 0 && v2 ~= 0
                        sim_matrix(r, c)  = sim_matrix(c, r);
                    elseif v2 == 0
                        sim_matrix(c, r) = sim_matrix(r, c);
                    end
                end
            end
            % Return updated values
            result = sim_matrix;
        end

        function result = filter_mutual_k_nearest_neighbors(sim_matrix, K)
            % Filters a similarity matrix to mutual K-nearest neighbors
            % number of columns
            n = size(sim_matrix, 2);
            % iterate over columns
            for c=1:n
                col = sim_matrix(:, c);
                % sort the column in descending order
                [~,indices] = sort(col,'descend');
                % remove the entries from sim_matrix which is lower than k indices
                sim_matrix(indices(K+1:end), c) = 0;
            end
            % Now ensure symmetry
            for c=1:n
                for r=c+1:n
                    v1 = sim_matrix(r, c);
                    v2 = sim_matrix(c, r);
                    % If any of them is zero, the other one will be made zero
                    if v1 == 0 || v2 == 0
                        sim_matrix(c, r)  = 0;
                        sim_matrix(r, c)  = 0;
                    end
                end
            end
            % Return updated values
            result = sim_matrix;
        end


        function result = inner_products(X)
            % Returns the pairwise inner products

            % Number of columns (number of data points)
            n = size(X, 2);            
            result = zeros(n, n);
            for r = 1:n
                % r-th vector
                xr = X(:, r);
                value = dot (xr, xr);
                result(r, r) = value;
                for c = r:n
                    % c-th vector
                    xc = X(:, c);
                    value = dot (xr, xc);
                    % Put the value in both places (Hermitian)
                    result(r, c) = value;
                    result(c, r) = conj(value);
                end
            end
        end


    end
end
