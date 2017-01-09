classdef distance 

    methods(Static)

        function result = pairwise_distances(X, distance)
            % Returns the pairwise distance matrix
            if (nargin < 2)
                distance = 'euclidean';
            end
            % Pair wise distance matrix (symmetric)
            result  =  squareform(pdist(X', distance));
        end

        function result = sqrd_l2_distances_cw(X)
            % The vectors are stored column wise.
            % Number of vectors = number of columns
            result = spx.commons.distance.pairwise_x_y(X);
        end

        function result = sqrd_l2_distances_rw(X)
            % The vectors are stored row wise.
            % Number of vectors = number of rows
            result = spx.commons.distance.pairwise_x_y(X');
        end


        function [ distance_matrix ] = pairwise_x_y( X, Y )
            % Computes pairwise distance squared between vectors in X and Y
            % c.f. pdist built-in function
            % We assume that vectors are column vectors
            % Dimension of space to which the vectors belong
            %N = size(X,1);
            % Number of vectors in X
            %nx = size(X,2);
            % Number of vectors in Y
            %ny = size(Y,2);
            % The result 
            % distance_matrix(i,j) = distance (x_i, y_j)
            if nargin < 2
                Y = X;
            end
            distance_matrix = bsxfun(@plus,dot(X,X,1)',dot(Y,Y,1))-2*(X'*Y); 
        end


    end

end

