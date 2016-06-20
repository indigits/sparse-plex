classdef svd

methods(Static)

    function [rank, max_gap] = mahdi_rank(singular_values)
        % rank accordingly to mahdi 2013 heuristic
        [ min_val , ind_min ] = min( diff( singular_values(1:end-1) ) ) ;
        rank = ind_min;
        max_gap = -min_val;
    end

end

end