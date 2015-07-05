classdef SPX_Wavelet
% SPX_Wavelet provides common functions for implementation of wavelets

methods(Static)

    function indices = dyad(j)
        % Returns the indices for the entire j-th dyad of 1-d wavelet transform
        indices = (2^(j)+1):(2^(j+1)) ;
    end

    function result = is_dyadic(j, k)
        % Verifies if the index (j, k) is dyadic
        if (fix(j) ~= j)
            % j must be an integer
            result = false;
            return;
        end
        if (fix(k) ~= k)
            % k must be an integer
            result = false;
            return;
        end
        if j < 0
            % j must be >= 0
            result = false;
            return;
        end
        if k < 0 || k >= 2^j
            % k must lie between 0 included and 2^j excluded. 
            result = false;
            return;
        end
        result = true;
    end

    function index = dyad_to_index(j, k)
        % Converts wavelet indexing into linear indexing
        % 
        % Inputs:
        %  j - Resolution level. j >= 0
        %  k - Translation. 0 <= k < 2^j.
        %
        %  Examples: 
        % (0, 0) -> 2
        % (0, 1)
        index = 2^j + k + 1;
    end

    function [n, j, consistent] = dyad_length(x)
        % Returns the length and dyadic length of x. Checks consistency.
        if ~isvector(x)
            error('x must be a vector');
        end
        n = length(x);
        j = ceil (log2(n));
        consistent = (n == 2^j);
    end
end

end
