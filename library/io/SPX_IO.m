classdef SPX_IO

    properties
    end
    
    methods (Static)

        function [ ] = printSparseVector( x )
        %PRINTSPARSEVECTOR Prints a sparse vector as pairs of indices and values
        N = length(x);
        K = 0;
        for i=1:N
            if x(i)
                if mod(K, 8) == 0
                    % We introduce a new line after every 8 values
                    fprintf('\n');
                end
                fprintf('(%d,%d) ',i, x(i));
                K = K+1;
            end
        end
        fprintf('  N=%d, K=%d\n', N, K);
        end
    end
end
