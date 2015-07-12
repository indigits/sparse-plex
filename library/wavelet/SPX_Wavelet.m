classdef SPX_Wavelet
% SPX_Wavelet provides common functions for implementation of wavelets
% 
% Dyadic index structure
% -----------------------------
% Let us say we are working with a signal s_n which has n=2^J samples.
% 1st level transform will lead to s_{n-1} with 2^{J-1} and 
% d_{n - 1} with 2^{J-2} samples. Applying the transform again on s_{n-1}, 
% we will obtain s_{n-2} with 2^{J-2} and d_{n-2} with 2^{J-2} samples.
% Consider a specific case of J=4.
% s_4 has 16 samples.
% s_3 and d_3 both have 8 samples each.
% s_2 and d_2 both have 4 samples each.
% s_1 and d_1 both have 2 samples each.
% s_0 and d_0 both have 1 samples each.
% No further filtering is possible.
% The final wavelet coefficients are arranged as
% [s_0 d_0 d_1 d_2 d_3].
% They occupy the indices as:
% [1, 2, 3-4, 5-8, 9-16].
% s_0 is placed at the beginning.
% d_j has 2^j samples and is placed between [2^j + 1, 2^{ j + 1}]


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

    function dyad_signal = cut_dyadic(signal)
        % Cuts the signal to the largest dyadic length
        n = length(signal);
        j = floor(log2(n));
        dyad_length = round(2^j);
        if dyad_length == n
            % no change is required
            dyad_signal = signal;
        else
            % We need to cut
            dyad_signal = signal(1:dyad_length);
        end
    end


    function y = aconv(f, x)
        % Filtering by periodic convolution of x with the time reverse of f.
        n = length(x);
        p = length(f);
        % pad x with its periodic repetitions at the end
        x_padded =  SPX_Vec.repeat_vector_at_end(x, p);
        % Reverse the filter
        f_reversed = SPX_Vec.reverse(f);
        % Perform the filtering
        y_padded = filter(f_reversed, 1, x_padded);
        % Remove the padding (remove first p-1 samples ) and keep n samples
        y = y_padded(p:(n+p-1));
    end


    function y = iconv(f, x)
        % Filtering by periodic convolution of x with the time reverse of f.
        n = length(x);
        p = length(f);
        % pad x with its periodic repetitions at the beginning
        x_padded =  SPX_Vec.repeat_vector_at_start(x, p);
        % Perform the filtering
        y_padded = filter(f, 1, x_padded);
        % Remove the padding (remove first p samples ) and keep n samples
        y = y_padded((p+1):(n+p));
    end

    function g = mirror_filter(h)
        % Constructs the mirror filter for a given qmf filter by applying (-1)^t modulation
        n = length(h);
        modulation = (-1).^(0:n-1);
        g = modulation .* h;
    end

    function y = up_sample(x, s)
        % Upsample x by a factor s by introducing zeros in between
        if nargin == 1
            % By default upsample by a factor of 2.
            s = 2;
        end
        n = length(x)*s;
        y = zeros(1,n);
        y(1:s:(n-s+1) )=x;

    end

    function y = lo_pass_down_sample(h, x)
        % Performs low pass filtering followed by downsampling on periodic extension of x
        % Perform filtering
        y = SPX_Wavelet.aconv(h, x);
        % Perform downsampling
        n = length(y);
        y = y(1:2:(n-1));
    end

    function y = hi_pass_down_sample(h, x)
        % Performs high pass filtering followed by downsampling on periodic extension of x
        % Construct  the high pass mirror filter 
        g = SPX_Wavelet.mirror_filter(h);
        % circular left shift the contents of x by 1.
        x  = SPX_Vec.shift_lc(x);
        % Perform filtering
        y = SPX_Wavelet.iconv(g, x);
        % Perform downsampling
        n = length(y);
        y = y(1:2:(n-1));
    end

    function y = up_sample_lo_pass(h, x)
        % Performs upsampling followed by low pass filtering

        % Upsample by a factor of 2 and introduce zeros
        x = SPX_Wavelet.up_sample(x);
        % Perform low pass filtering
        y = SPX_Wavelet.iconv(h, x);
    end

    function y = up_sample_hi_pass(h, x)
        % Performs upsampling followed by high pass filtering

        % Construct  the high pass mirror filter 
        g = SPX_Wavelet.mirror_filter(h);
        % Upsample by a factor of 2 and introduce zeros
        x = SPX_Wavelet.up_sample(x);
        % circular right shift the contents of x by 1.
        x  = SPX_Vec.shift_rc(x);
        % Perform low pass filtering
        y = SPX_Wavelet.aconv(g, x);
    end

end

end
