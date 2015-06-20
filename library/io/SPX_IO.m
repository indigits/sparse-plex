classdef SPX_IO

    properties
    end
    
    methods (Static)

        function [ ] = printSparseSignal( x )
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

        function [ ] = printSortedSparseSignal( x )
            %PRINTSORTEDSPARSEVECTOR Sorts non-zero values in x and prints them.
            % We identify non-zero values of x. We sort them. We print them in 
            % the descending magnitude order along with their indices
            values = SPX_Support.sortedNonZeroElements(x);
            fprintf('Index:\tValue\n');
            fprintf('%4d:\t%f\n', values);
        end

        
    end
end
