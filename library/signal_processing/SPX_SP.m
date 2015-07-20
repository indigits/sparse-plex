classdef SPX_SP
% Basic functions related to signal processing

    methods(Static)
        function count = overlapped_blocks_count(...
            signalLength, blockLength, overlappedSamples )
            num = signalLength  - blockLength;
            den = blockLength - overlappedSamples;
            count = fix(num/den) + 1;
        end
        function locations = overlapped_blocks_locations(...
            signalLength, blockLength, overlappedSamples )
            num = signalLength  - blockLength;
            den = blockLength - overlappedSamples;
            count = SPX_SP.overlapped_blocks_count(signalLength, ...
                blockLength, overlappedSamples);
            locations = den * (1:count);
            locations = locations - (den -1);
        end

        function y = apply_transform(x, transform, check_dyadic)
            % Applies a given transform to a vector (row / column) or all columns of a signal matrix.
            [n, d] = size(x);
            if nargin < 3
                check_dyadic = false;
            end
            if isvector(x)
                n   = n * d;
                if check_dyadic & ~SPX_Number.is_power_of_2(n)
                    error('x must be of dyadic length.');
                end
                col = false;
                if iscolumn(x)
                    col = true;
                    x = x';
                end
                y = transform(x, n);
                if col
                    % Convert the resulting vector to a column vector
                    y = y';
                end
            else
                % It is a signal matrix. We will process column by column
                if check_dyadic & ~SPX_Number.is_power_of_2(n)
                    error('signals must be of dyadic length.');
                end
                y = zeros(n, d);
                for i=1:d
                    y(:, i) = transform(x(:, i)', n);
                end
            end
        end


    end


end
