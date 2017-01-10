classdef dct
% Functions related to discrete cosine transform
% 
%
%  Influenced by:
%  - WaveLab


methods(Static)

    function alpha = forward_2(x)
        % Forward transform for DCT type 2.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        alpha = spx.dsp.apply_transform(x, @dct_2_impl, options);
    end

    function x = inverse_2(alpha)
        % Inverse transform for DCT type 2.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        x = spx.dsp.apply_transform(alpha, @dct_3_impl, options);
    end

    function alpha = forward_3(x)
        % Forward transform for DCT type 3.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        alpha = spx.dsp.apply_transform(x, @dct_3_impl, options);
    end

    function x = inverse_3(alpha)
        % Inverse transform for DCT type 3.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        x = spx.dsp.apply_transform(alpha, @dct_2_impl, options);
    end

    function alpha = forward_quasi(x)
        % Forward transform for Quasi DCT.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        alpha = spx.dsp.apply_transform(x, @forward_quasi_dct, options);
    end

    function x = inverse_quasi(alpha)
        % Inverse transform for Quasi DCT.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        x = spx.dsp.apply_transform(alpha, @inverse_quasi_dct);
    end

    function result = basis_mtx_2(n)
        % Returns the DCT basis for R^n in matrix form .
        if ~spx.discrete.number.is_power_of_2(n)
            error('n must be of dyadic length.');
        end
        result = spx.dsp.dct.forward_2(eye(n));
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



function alpha = dct_2_impl(x)
    % Forward transform for DCT type 2.
    % Inverse transform for DCT type 3.
    n = length(x);
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


function alpha = dct_3_impl(x)
    % Forward transform for DCT type 3.
    % Inverse transform for DCT type 2.
    n = length(x);
    x(1) = x(1)/sqrt(2);
    % Pad further with 3 n zeros.
    y    = [x zeros(1,3*n)];
    % Compute FFT and take the real part.
    w    = real(fft(y));
    % Perform normalization
    alpha    = sqrt(2/n)*w(2:2:2*n);
end


function alpha = forward_quasi_dct(x)
    % Forward transform for Quasi DCT
    n = length(x);
    x(1) = x(1)/sqrt(2); 
    x(n) = x(n)/sqrt(2);
    rx = reshape( [ x ; zeros(1,n) ], 1, (2*n) );
    y = [ rx zeros(1,2*n-4) ];
    w = real(fft(y)) ;
    alpha = sqrt(2/(n-1))*w(1:2:n);
    alpha(1) = alpha(1)/sqrt(2);
end

function x = inverse_quasi_dct(alpha)
    % Inverse transform for Quasi DCT
    n = length(alpha);
    alpha(1)  = alpha(1)/sqrt(2); 
    y    = reshape( [ alpha ; zeros(1,n) ],1,2*n );
    w     = real(fft(y));
    x     = sqrt(2/n)*w(1:n+1);
    x(1)   = x(1)/sqrt(2);
    x(n+1) = x(n+1)/sqrt(2);
end



