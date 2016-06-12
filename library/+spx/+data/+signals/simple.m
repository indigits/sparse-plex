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

end

end
