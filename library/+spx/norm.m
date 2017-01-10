classdef norm < handle
% spx.norm provides helper functions for working with norms of rows and columns
    methods(Static)

        function result = is_unit_norm_vec(x)
            % Checks if a vector is unit norm or not
            if ~isvector(x)
                result = false;
                return;
            end
            result = abs(norm(x) - 1) < 1e-6;
        end

        function result = norms_l1_cw(X)
            % Returns the $l_1$ norm of each column in X
            result = sum(abs(X));
        end

        function result = norms_l1_rw(X)
            % Returns the $l_1$ norm of each row in X
            result = spx.norm.norms_l1_cw(X')';
        end

        function result = norms_l2_cw(X)
            % Returns the $l_2$ norm of each column in X
            result = sqrt(sum(X .* conj(X), 1));
        end

        function result = norms_l2_rw(X)
            % Returns the $l_2$ norm of each row in X
            result = spx.norm.norms_l2_cw(X')';
        end

        function result = norms_linf_cw(X)
            % Returns the $l_{\infty}$ norm of each column in X
            result = max(abs(X));
        end
        function result = norms_linf_rw(X)
            % Returns the $l_{\infty}$ norm of each row in X
            result = spx.norm.norms_linf_cw(X')';
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %  Row column norms
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function result = cr_l1_l1(X)
            % l1 norm over columns followed by l1 norm over rows
            result = sum(sum(abs(X)));
        end

        function result = rc_l1_l1(X)
            % l1 norm over rows followed by l1 norm over columns
            result = spx.norm.cr_l1_l1(X');
        end

        function result = cr_l1_l2(X)
            % l1 norm over columns followed by l2 norm over rows
            result = spx.norm.norms_l1_cw(X);
            result = norm(result, 2);
        end

        function result = rc_l1_l2(X)
            % l1 norm over rows followed by l2 norm over columns
            result = spx.norm.cr_l1_l2(X');
        end

        function result = cr_l1_linf(X)
            % l1 norm over columns followed by l_{\infty} norm over rows
            result = spx.norm.norms_l1_cw(X);
            result = norm(result, Inf);
        end

        function result = rc_l1_linf(X)
            % l1 norm over rows followed by l_{\infty} norm over columns
            result = spx.norm.cr_l1_linf(X');
        end

        function result = cr_l2_l1(X)
            % l2 norm over columns followed by l1 norm over rows
            result = spx.norm.norms_l2_cw(X);
            result = norm(result, 1);
        end

        function result = rc_l2_l1(X)
            % l2 norm over rows followed by l1 norm over columns
            result = spx.norm.cr_l2_l1(X');
        end

        function result = cr_l2_l2(X)
            % l2 norm over columns followed by l2 norm over rows
            result = spx.norm.norms_l2_cw(X);
            result = norm(result, 2);
        end

        function result = rc_l2_l2(X)
            % l2 norm over rows followed by l2 norm over columns
            result = spx.norm.cr_l2_l2(X');
        end

        function result = cr_l2_linf(X)
            % l2 norm over columns followed by l_{\infty} norm over rows
            result = spx.norm.norms_l2_cw(X);
            result = norm(result, Inf);
        end

        function result = rc_l2_linf(X)
            % l2 norm over rows followed by l_{\infty} norm over columns
            result = spx.norm.cr_l2_linf(X');
        end

        function result = cr_linf_l1(X)
            % l_{\infty} norm over columns followed by l1 norm over rows
            result = max(abs(X));
            result = sum(result);
        end

        function result = rc_linf_l1(X)
            % l_{\infty} norm over rows followed by l1 norm over columns
            result = spx.norm.cr_linf_l1(X');
        end

        function result = cr_linf_l2(X)
            % l_{\infty} norm over columns followed by l2 norm over rows
            result = max(abs(X));
            result = norm(result, 2);
        end

        function result = rc_linf_l2(X)
            % l_{\infty} norm over rows followed by l2 norm over columns
            result = spx.norm.cr_linf_l2(X');
        end

        function result = cr_linf_linf(X)
            % l_{\infty} norm over columns followed by l_{\infty} norm over rows
            result = max(max(abs(X)));
        end

        function result = rc_linf_linf(X)
            % l_{\infty} norm over rows followed by l_{\infty} norm over columns
            result = spx.norm.cr_linf_linf(X);
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %  Normalization of rows / columns
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function X = normalize_l1(X)
            % Normalizes all points in X by the column-wise l-1 norm
            norms = sum(abs(X));
            X = spx.norm.scale_columns(X, norms);
        end

        function X = normalize_l2(X)
            % Normalizes all points in X by the column-wise l-2 norm
            norms =sqrt(sum(X .* conj(X), 1));
            X = spx.norm.scale_columns(X, norms);
        end

        function X = normalize_l2_rw(X)
            % Normalizes all points in X by the row-wise l-2 norm
            norms =sqrt(sum(X .* conj(X), 2));
            X = spx.norm.scale_rows(X, norms);
        end

        function X = normalize_linf(X)
            % Normalizes all points in X by the column-wise l-infinity norm
            norms = max(abs(X));
            X = spx.norm.scale_columns(X, norms);
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
