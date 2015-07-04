classdef SPX_Statistics < handle

    methods(Static)

        function r = auto_correlation(x)
            if ~isvector(x)
                error('Input must be a vector');
            end
            % Returns the autocorrelation of x
            n  = length(x);
            % identify the length for FFT
            fft_length = 2^nextpow2(2*n-1);
            % Perform the N point fft of x
            xf = fft(x, fft_length);
            % Multiply point wise the fft with its complex conjugate
            s = xf .* conj(xf);
            % Compute inverse transform
            r = ifft(s);
            % Rearrange and keep values corresponding to lags: -(n-1):+(n-1)
            % Pick up the n-1 terms from the end
            % then pick n terms from the beginning
            % total 2 * n - 1 terms.
            if iscolumn(x)
                r = [r(end-n+2:end) ; r(1:n)];
            else
                r = [r(end-n+2:end)  r(1:n)];
            end
        end

        function [ statistic ] = compute_statistic_per_vector(...
            receivedSequence, N, statisticFunc)
            %COMPUTE_STATISTIC_PER_VECTOR Computes a statistic for each vector
            %   Detailed explanation goes here

            % Number of samples
            L = length(receivedSequence);
            % Number of vectors
            M = round(L / N);
            % Each row now represents one vector
            receivedSequence = reshape(receivedSequence, N, M)';
            statistic = zeros(M, 1);
            for i=1:M
                data = receivedSequence(i, :);
                statistic(i) = statisticFunc(data);
            end
        end

    end

end

