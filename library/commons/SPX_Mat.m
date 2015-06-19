classdef SPX_Mat < handle

    methods(Static)
        function X = off_diagonal_elements(X)
            % Returns a column vector of off diagonal elements
            [m, n] = size(X);
            idx = eye(m, n);
            X = X(~idx);
        end

        function X = off_diagonal_matrix(X)
            % Returns the matrix of off diagonal elements
            [m, n] = size(X);
            idx = eye(m, n);
            X = (1 - idx).* X;
        end

        function X = off_diag_upper_tri_elements(X)
            % Returns the upper triangular off diagonal elements in a vector
            [m, n] = size(X);
            idx = tril(ones(m, n));
            X = X(~idx);
        end

        function X = off_diag_upper_tri_matrix(X)
            % Returns the upper triangular off diagonal elements in a matrix
            [m, n] = size(X);
            idx = tril(ones(m, n));
            X = (1 - idx).* X;
        end

        function result = nonzero_density(X)
            % Density of nonzero entries in the matrix
            result = nnz(X) / numel(X);
        end
    end

end

