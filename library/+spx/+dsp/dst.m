classdef dst
% Functions related to discrete sine transform
%
% Remarks:
% 
% 
%  Influenced by:
%  - WaveLab



methods(Static)

    function alpha = forward_1(x)
        % Forward transform for DST type 1.
        options.length_constraint = @spx.dsp.dyadic_minus_one_length_constraint;
        alpha = spx.dsp.apply_transform(x, @dst_1_impl, options);
    end

    function x = inverse_1(alpha)
        % Inverse transform for DST type 1.
        options.length_constraint = @spx.dsp.dyadic_minus_one_length_constraint;
        x = spx.dsp.apply_transform(alpha, @dst_1_impl, options);
    end

    function alpha = forward_2(x)
        % Forward transform for DST type 2.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        alpha = spx.dsp.apply_transform(x, @dst_2_impl, options);
    end

    function x = inverse_2(alpha)
        % Inverse transform for DST type 2.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        x = spx.dsp.apply_transform(alpha, @dst_3_impl, options);
    end

    function alpha = forward_3(x)
        % Forward transform for DST type 3.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        alpha = spx.dsp.apply_transform(x, @dst_3_impl, options);
    end

    function x = inverse_3(alpha)
        % Inverse transform for DST type 3.
        options.length_constraint = @spx.dsp.dyadic_length_constraint;
        x = spx.dsp.apply_transform(alpha, @dst_2_impl, options);
    end

end

end



function alpha = dst_1_impl(x)
    % Forward and inverse transform for DST type 1.
    n = length(x);
    n = n + 1;
    y = zeros(1, 2*n);
    y(2:n) = -x;
    z = fft(y);
    alpha = sqrt(2/n) .* imag(z(2:n));
end

function alpha = dst_2_impl(x)
    % Forward transform for DST type 2.
    % Inverse transform for DST type 3.
    n   = length(x);
    % Interleave with 0s like 0 x1 0 x2 0 x3 ...
    x_up  = reshape([ zeros(1,n) ; x ],1,2*n);
    % Pad with 2n zeros at the end
    x_padded   = [x_up zeros(1,2*n)];
    % Compute FFT and take the imaginary part
    w   = - imag(fft(x_padded)) ;
    % Normalize and prepare transformed coefficients.
    alpha   = sqrt(2/n)*w(2:n+1);
    alpha(n)= alpha(n)/sqrt(2);
end

function alpha = dst_3_impl(x)
    % Forward transform for DST type 3.
    % Inverse transform for DST type 2.
    n   = length(x);
    % Scale down
    x(n) = x(n)/sqrt(2);
    % Pad with zeros
    y    = [ 0 x zeros(1,(3*n-1)) ];
    % Compute FFT and take the imaginary part, negate it.
    w    = - imag(fft(y)) ;
    % Normalize to obtain the transform coefficients.
    alpha = sqrt(2/n)*w(2:2:2*n);
end
