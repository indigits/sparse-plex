classdef simple 

methods(Static)


    function signal = picket_fence(N)
        import spx.discrete.number;
        if ~number.is_perfect_square(N)
            error('N must be perfect square');
        end
        n = sqrt(N);
        signal = zeros(1, N);
        signal(1:n:end) = 1;
    end

    function X = uniform(N, S)
        % Generates uniformly distributed signals

        % Generate Gaussian vectors
        X = randn(N, S);
        % Make them unit length
        X = spx.commons.norm.normalize_l2(X);
    end

end

end
