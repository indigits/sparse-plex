classdef SPX_DCT
% Functions related to discrete cosine transform


methods(Static)

    function alpha = forward_2(x)
        % Forward transform for DCT type 2.
        alpha = SPX_SP.apply_transform(x, @dct_2_impl, true);
    end

    function x = inverse_2(alpha)
        % Inverse transform for DCT type 2.
        x = SPX_SP.apply_transform(alpha, @dct_3_impl, true);
    end

    function alpha = forward_3(x)
        % Forward transform for DCT type 3.
        alpha = SPX_SP.apply_transform(x, @dct_3_impl, true);
    end

    function x = inverse_3(alpha)
        % Inverse transform for DCT type 3.
        x = SPX_SP.apply_transform(alpha, @dct_2_impl, true);
    end

    function result = dct_2_mtx(n)
        % Returns the DCT basis for R^n in matrix form .
        if ~SPX_Number.is_power_of_2(n)
            error('n must be of dyadic length.');
        end
        result = SPX_DCT.forward_2(eye(n));
    end

    function [ B, A, D] = basis_strang(N, dctType)
        %DCTBASISSTRANG Computes the DCT basis for N length vectors
        %
        % Based on the Eigen value approach described by
        % Gilbert Strang.
        %
        % Input:
        %   N: Basis size
        %
        % Output:
        %   B: The DCT matrix of size N x N
        %   A: The difference equation matrix whose eigen values
        %      form the DCT matrix
        %   D: The eigen values for these eigen vectors
        %
        % Note:
        %
        % Example:
        %   B = dctBasis(4);
        %   B = dctBasis(8);

        A = zeros (N);
        for i=2:N-1
            A(i, i-1:i+1) = [-1 2 -1];
        end
        switch(dctType)
            case 1
                A(1,1:2) = [2 - 2];
                A(N,N-1:N) = [-2 2];
            case 2
                A(1,1:2) = [1 -1];
                A(N,N-1:N) = [-1 1];
            case 3
            case 4
        end
        % Let us perform eigen value decomposition of A
        % We are only interested in 
        [B, D] = eig(A);
        % All eigen values of this matrix are non-negative.
        % If an eigen value is zero,
        % there are chances that due to numerical instability
        % the eigen value is reported as -0.
        % We verify this and change the Eigen vector
        % accordingly.
        lambdas = diag(D);
        incorrect = lambdas < 0;
        % We correct the eigen vectors
        B(:,incorrect) = -1 * B(:,incorrect);
        % We correct the eigen values
        incorrect = diag(incorrect);
        D(incorrect) = - D(incorrect);
    end

end



end



function alpha = dct_2_impl(x, n)
    % Forward transform for DCT type 2.
    % Inverse transform for DCT type 3.
    % Intersperse x with 0s.
    % 0 x1 0 x2 0 x3 and so on
    rx  = reshape([ zeros(1,n) ; x ],1,2*n);
    % Pad further with 2 n zeros.
    y   = [rx zeros(1,2*n)];
    % Compute FFT and take the real part.
    w   = real(fft(y));
    % Perform normalization
    alpha   = sqrt(2/n)*w(1:n);
    alpha(1)= alpha(1)/sqrt(2);
end


function alpha = dct_3_impl(x, n)
    % Forward transform for DCT type 3.
    % Inverse transform for DCT type 2.
    x(1) = x(1)/sqrt(2);
    % Pad further with 3 n zeros.
    y    = [x zeros(1,3*n)];
    % Compute FFT and take the real part.
    w    = real(fft(y));
    % Perform normalization
    alpha    = sqrt(2/n)*w(2:2:2*n);
end


