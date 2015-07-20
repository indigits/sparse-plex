classdef SPX_DST
% Functions related to discrete sine transform

methods(Static)

    function alpha = forward_1(x)
        % Forward transform for DST type 1.
        options.length_constraint = @SPX_SP.dyadic_minus_one_length_constraint;
        alpha = SPX_SP.apply_transform(x, @dst_1_impl, options);
    end

    function x = inverse_1(alpha)
        % Inverse transform for DST type 1.
        options.length_constraint = @SPX_SP.dyadic_minus_one_length_constraint;
        x = SPX_SP.apply_transform(alpha, @dst_1_impl, options);
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

