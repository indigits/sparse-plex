classdef SPX_SSP

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

        function cr = cross_correlation(x, y)
            if ~isvector(x) or ~isvector(y)
                error('Both x and y must be vectors');
            end
            nx = length(x);
            ny = length(y);
            % Length of cross correlation vector
            nr = nx + ny - 1;
            % compute the Fourier transforms
            fx = fft(x, nr);
            fy = fft(y, nr);
            % multiply fx with conjugate of fy
            s = fx .* conj(fy);
            % Take inverse transform
            r = ifft(s);
            % Finally shift the entries 
            cr = fftshift(r);
        end

    end
end


