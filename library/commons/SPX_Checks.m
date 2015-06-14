classdef SPX_Checks < handle

    methods(Static)

        function result = is_square(A)
            [m, n]  = size(A);
            result = (m == n);
        end

        function result = is_symmetric(A)
            result = SPX_Checks.is_square(A);
            if ~result
                return;
            end
            result =  all(all(A==A.'));
        end

        function result = is_hermitian(A)
            result = SPX_Checks.is_square(A);
            if ~result
                return;
            end
            result =  all(all(A==A'));
        end

        function result = is_positive_definite(A)
            result = SPX_Checks.is_hermitian(A);
            if ~result
                return;
            end
            % Perform Cholesky decomposition of A
            [R, p] = chol(A);
            result = (p == 0);
        end

    end
end
