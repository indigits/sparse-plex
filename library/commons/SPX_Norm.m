classdef SPX_Norm < handle

    methods(Static)


        function result = norms_l1_cw(X)
            result = sum(abs(X));
        end

        function result = norms_l2_cw(X)
            result = sqrt(sum(X .* conj(X), 1));
        end

        function result = norms_linf_cw(X)
            result = max(abs(X));
        end

        function X = normalize_l1(X)
            % Normalizes all points in X by the column-wise l-1 norm
            norms = sum(abs(X));
            X = SPX_Norm.scale_columns(X, norms);
        end

        function X = normalize_l2(X)
            % Normalizes all points in X by the column-wise l-2 norm
            norms =sqrt(sum(X .* conj(X), 1));
            X = SPX_Norm.scale_columns(X, norms);
        end

        function X = normalize_l2_rw(X)
            % Normalizes all points in X by the row-wise l-2 norm
            norms =sqrt(sum(X .* conj(X), 2));
            X = SPX_Norm.scale_rows(X, norms);
        end

        function X = normalize_linf(X)
            % Normalizes all points in X by the column-wise l-infinity norm
            norms = max(abs(X));
            X = SPX_Norm.scale_columns(X, norms);
        end

        function X = scale_columns(X, factors)
            n = size(X, 2);
            for i=1:n
                v = factors(i);
                if 0 == v
                    continue
                end
                % Scale it down
                X(:, i) = X(:, i) / v;
            end
        end

        function X = scale_rows(X, factors)
            n = size(X, 1);
            % make sure that there are no -zero vectors
            factors(factors == 0) = 1e-10;
            for i=1:n
                v = factors(i);
                % Scale it down
                X(i, :) = X(i, :) / v;
            end
        end

        function result = inner_product_cw(A, B)
            result = sum (A.* conj(B));
        end

        function [ sumsqr ] = sum_square( input )
            %SUMSQUARE Computes the squared sum of input vector
            %   Detailed explanation goes here
            sumsqr = sum(input.^2);
        end

    end    
end
