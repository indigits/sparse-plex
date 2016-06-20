classdef svd

methods(Static)

    function [rank, max_gap] = mahdi_rank(singular_values)
        % rank accordingly to mahdi 2013 heuristic
        [ min_val , ind_min ] = min( diff( singular_values(1:end-1) ) ) ;
        rank = ind_min;
        max_gap = -min_val;
    end

    function rank = vidal_rank(singular_values,kappa)
        if nargin < 2
            kappa = .1;
        end
        % Rank used in Vidal papers
        n = length(singular_values);
        % we will try rank values between 1 to n-1.
        % an array to store criterion value
        criterion = zeros(1, n-1);
        for(r=1:n-1)
            num = singular_values(r+1)^2;
            den = sum(singular_values(1:r).^2);
            criterion(r)=num/den + kappa*r;
        end
        %criterion
        % find the rank with minimum value of the criterion
        [min_value, index]=min(criterion);
        rank = index;
    end


end

end