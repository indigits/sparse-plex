classdef vector
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
                    vec = spx.vector.reshape_as_row_vec(x);
                end
            else
                if iscolumn(x)
                    vec = x;
                else
                    vec = spx.vector.reshape_as_col_vec(x);
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


        function x_extended = repeat_vector_at_end(x, p)
            % Repeats the vector at the end for p more samples to create its periodic extension
            %
            % Inputs 
            %  x - vector
            %  p - number of samples to repeat

            n = length(x);
            % ensure that x is a column vector
            % all intermediate calculations are happening with the assumption
            % that x is a column vector
            % but we maintain a flag to note that x was originally a row vector
            row = false;
            if isrow(x)
                x = x';
                row = true;
            end
            if p < n
                % The usual case, we pad x with first p samples of x
                x_extended = [x ; x(1:p)];
            else
                padding = zeros(p, 1);
                indices = 1:p;
                modular_indices = rem(indices - 1, n) + 1;
                padding(indices) = x(modular_indices);
                x_extended = [x ; padding];
            end
            if row
                % Restore the shape as row vector
                x_extended = x_extended';
            end
        end

        function x_extended = repeat_vector_at_start(x, p)
            % Repeats the vector at the start for p more samples to create its periodic extension
            %
            % Inputs 
            %  x - vector
            %  p - number of samples to repeat

            n = length(x);
            row = false;
            if isrow(x)
                x = x';
                row = true;
            end
            if p <= n
                % The usual case, we copy the last p samples of x at the beginning
                x_extended = [x((n-p+1):n) ; x];
            else
                padding = zeros(p, 1);
                indices = 1:p;
                modular_indices = rem(p*n - p + indices - 1, n) + 1;
                padding(indices) = x(modular_indices);
                x_extended = [padding ; x];
            end
            if row
                % Restore the shape as row vector
                x_extended = x_extended';
            end
        end
    end


end
