classdef SPX_Vec
% Utility functions related to working with vectors

    methods(Static)
        function [ e ] = unit_vector( N, i )
            %unit_vector Creates a unit vector in the ith dimension of an N dimensional
            %space.
            e = zeros(N,1);
            e(i) = 1;
        end

        function r = reverse(v)
            % Reverses the contents of a vector
            r  = v(length(v): -1 : 1);
        end

        function row = reshape_as_row_vec(x)
            % Converts x to a row vector
            row = x(:)';
        end

        function col = reshape_as_col_vec(x)
            % Converts x to a column vector
            col = x(:);
        end

        function vec = reshape_as_prototype(x, proto)
            % Shapes a vector as the prototype vector
            % Both x and proto must be vectors.
            % if proto is row vec, then x would be made row
            % if proto is col vec, then x would be made col
            if ~isvector(x)
                error('x must be a vector');
            end
            if ~isvector(proto)
                error('proto must be a vector');
            end
            if isrow(proto)
                if isrow(x)
                    vec = x;
                else
                    vec = SPX_Vec.reshape_as_row_vec(x);
                end
            else
                if iscolumn(x)
                    vec = x;
                else
                    vec = SPX_Vec.reshape_as_col_vec(x);
                end
            end
        end

        function y = shift_r(x)
            % Right shift the contents of the vector
            y = zeros(size(x));
            y(2:end) = x(1:end-1);
        end

        function y = shift_rc(x)
            % Circular right shift the contents of the vector
            y = zeros(size(x));
            y(2:end) = x(1:end-1);
            y(1)  = x(end);
        end


        function y = shift_l(x)
            % Left shift the contents of the vector
            y = zeros(size(x));
            y(1:end-1) = x(2:end);
        end

        function y = shift_lc(x)
            % Circular left shift the contents of the vector
            y = zeros(size(x));
            y(1:end-1) = x(2:end);
            y(end)  = x(1);
        end

        function y = shift_rn(x, n)
            % Right shift the contents of the vector by n places
            y = zeros(size(x));
            y(n+1:end) = x(1:end-n);
        end

        function y = shift_rcn(x, n)
            % Circular right shift the contents of the vector by n places
            y = zeros(size(x));
            y(n+1:end) = x(1:end-n);
            y(1:n)  = x(end-n+1:end);
        end


        function y = shift_ln(x, n)
            % Left shift the contents of the vector by n places
            y = zeros(size(x));
            y(1:end-n) = x(1+n:end);
        end

        function y = shift_lcn(x, n)
            % Circular left shift the contents of the vector by n places
            y = zeros(size(x));
            y(1:end-n) = x(1+n:end);
            y(end-n+1:end)  = x(1:n);
        end
    end


end
