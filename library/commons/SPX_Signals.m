classdef SPX_Signals
    %SPX_SIGNALS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function [x,i] = findFirstLessEqEnergy(X, energy)
            % Returns the first signal with energy less than or equal to
            % given threshold
            s = size(X, 2);
            for i=1:s
                x = X(:,i);
                xx = x' * x;
                if xx <= energy
                    return
                end
            end
            % None could be found
            i = -1;
            x = [];
        end

        
    end
    
end

