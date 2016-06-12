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

        function y = apply_transform(x, transform, options)
            % Applies a given transform to a vector (row / column) or all columns of a signal matrix.
            [n, d] = size(x);
            if nargin < 3
                options.length_constraint = @SPX_Lang.noop;
            elseif ~isstruct(options)
                error('Options must be a structure.');                
            end
            if isvector(x)
                n   = n * d;
                % Apply any constraints on length
                options.length_constraint(n);
                col = false;
                if iscolumn(x)
                    col = true;
                    x = x';
                end
                y = transform(x);
                if col
                    % Convert the resulting vector to a column vector
                    y = y';
                end
            else
                % Apply any constraints on length of signals
                options.length_constraint(n);
                % It is a signal matrix. We will process column by column
                y = zeros(n, d);
                for i=1:d
                    y(:, i) = transform(x(:, i)');
                end
            end
        end


        % These are constraints for apply_transform function
        function dyadic_length_constraint(n)
            % Checks if length is dyadic or not
            if ~SPX_Number.is_power_of_2(n)
                error('signal must be of dyadic length.');
            end
        end

        function dyadic_minus_one_length_constraint(n)
            % Checks if length is 2^j -1 or not
            if ~SPX_Number.is_power_of_2(n+1)
                error('signal must be of length like 2^j - 1.');
            end
        end

    end


end
