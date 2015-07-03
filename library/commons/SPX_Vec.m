classdef SPX_Vec
% functions related to a vector

    methods(Static)
        function r = reverse(v)
            r  = v(length(v): -1 : 1);
        end
    end


end
