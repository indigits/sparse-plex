classdef lcs
% Provides methods for implementing projections using local sine and cosine bases

methods(Static)


    function result  = psi(epsilon, x)
        c  = pi / (4 * epsilon);
        % identify values of x which are inside (-epsilon, epsilon);
        inside  = (x >= -epsilon) & (x < epsilon);
        % assign psi to constant value c inside the region and 0 output the region.
        result = c.* inside;
    end

    function result  = theta(epsilon, x)
        slope  = pi / (4 * epsilon);
        result = slope * (x + epsilon);
        result(x < -epsilon) = 0;
        result(x >= epsilon) = pi/2;
    end

    function result = s_eps(epsilon, x)
        result = sin(spx.wavelet.lcs.theta(epsilon, x));
    end

    function result = c_eps(epsilon, x)
        result = cos(spx.wavelet.lcs.theta(epsilon, x));
    end

    function result = project_0_right(f, step, stop, epsilon, polarity)
        x = 0:step:stop;
        s_e = spx.wavelet.lcs.s_eps(epsilon, x);
        c_e = spx.wavelet.lcs.c_eps(epsilon, x);
        fx = f(x);
        f_minus_x = f(-x);
        first = (s_e.^2) .* fx;
        second = (s_e .* c_e) .* f_minus_x;
        if polarity
            result = first + second;
        else
            result = first - second;
        end

    end
end

end