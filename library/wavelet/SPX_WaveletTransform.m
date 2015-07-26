classdef SPX_WaveletTransform
% Implements different versions of wavelet transform
% n=1024, J=10, L=6
% L - J = 10 - 6 = 4.
% s_10 = s_6 + d_6 + d_7 + d_8 + d_9
% j=J-1:-1:L = [9, 8, 7, 6]
% n = 256, J=8, L=0
% s_8 = s_0 + d_0 + d_1 + d_2 + d_3 + d_4 + d_5 + d_6 + d_7.
% s_J = s_L + sum(L <= j < J) d_j.

methods(Static)

    function w = forward_periodized_orthogonal(qmf, x, L)
        % Computes the forward wavelet transform of x
        %
        % Uses the periodized version of x 
        % with an orthogonal wavelet basis
        % length of x must be dyadic.
        if nargin < 3
            % We perform full wavelet decomposition
            L = 0;
        end

        % Let's get the dyadic length of x and verify that
        % length of x is a power of 2.
        [n, J, consistent] = SPX_Wavelet.dyad_length(x);
        if ~consistent
            error('x must be of dyadic length');
        end
        if L >= J
            error('L must be smaller than dyadic index of x');
        end
        % We will work with row vectors in this function.
        col = false;
        if iscolumn(x)
            col = true;
            % Convert it to row vector
            x = x';
        end
        % Create the storage for wavelet coefficients.
        w = zeros(1, n);
        for j=J-1:-1:L
            % Start from the finest level and keep going down.
            % identify the hipass component of x and downsample it.
            c = SPX_Wavelet.hi_pass_down_sample(qmf, x);
            % Identify the locations where the hipass component will be stored.
            indices = SPX_Wavelet.dyad(j);
            w(indices) = c;
            % Replace x with its low pass downsampled version
            x = SPX_Wavelet.lo_pass_down_sample(qmf, x);
        end
        % Store the remaining contents of x in the beginning of array
        w(1:(2^L)) = x;
        if col
            % Convert the wavelet coefficients to a column vector
            w = w';
        end
    end

    function x = inverse_periodized_orthogonal(qmf, w, L)
        % Computes the inverse wavelet transform of x
        %
        % Uses the periodized version of x 
        % with an orthogonal wavelet basis
        % length of x must be dyadic.
        if nargin < 3
            % We perform full wavelet composition
            L = 0;
        end

        % Let's get the dyadic length of w and verify that
        % length of w is a power of 2.
        [n, J, consistent] = SPX_Wavelet.dyad_length(w);
        if ~consistent
            error('w must be of dyadic length');
        end
        if L >= J
            error('L must be smaller than dyadic index of w');
        end
        % We will work with row vectors in this function.
        col = false;
        if iscolumn(w)
            col = true;
            % Convert it to row vector
            w = w';
        end
        % initialize x with its coerce approximation
        x = w(1:2^L);
        for j=L:J-1
            % Identify the locations where the hipass component is stored.
            indices = SPX_Wavelet.dyad(j);
            c = w(indices);
            % Compute the low pass portion of the next level of approximation
            x_low = SPX_Wavelet.up_sample_lo_pass(qmf, x);
            % Compute the high pass portion of the next level of approximation
            x_hi = SPX_Wavelet.up_sample_hi_pass(qmf, c);
            % Compute the next level approximation of x
            x = x_low + x_hi;
        end
        if col
            % Convert the resulting vector to a column vector
            x = x';
        end
    end
    
end

end
