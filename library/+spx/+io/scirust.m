classdef scirust < handle

    methods(Static)
    
        function [ ] = printMatrix( A, precision)
        %PRINTMATRIX Prints matrix for SciRust
        if nargin < 2 
            precision = 1;
        end
        [M,N] = size(A);
        fprintf('matrix_rw_f64(%d, %d, [\n', M, N);
        format_a  = sprintf('%%.%df, ', precision);
        format_b  = sprintf('%%.%df', precision);
        for i=1:M
            % Pick up ith row
            x = A (i, :);
            % some blank space at the beginning of the line.
            fprintf('        ');
            for j=1:N-1
                fprintf(format_a, x(j));
            end
            fprintf(format_b, x(N));
            if i == M
                fprintf('\n');
            else
                fprintf(',\n');
            end
        end
        fprintf('        ]);\n');
        end

    end

end
