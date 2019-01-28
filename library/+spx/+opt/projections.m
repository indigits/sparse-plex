classdef projections
% projections to different convex sets

methods(Static)

function x = proj_l2_ball(x, radius)
    % project x to an l2 ball of given radius
    if nargin < 2
        radius = 1;
    end
    x_norm  = norm(x); 
    if x_norm > radius
        x = (radius / x_norm) * x;
    end
end


function x = proj_linf_ball(x, radius)
    % project x to an l-inf ball of given radius
    if nargin < 2
        radius = 1;
    end
    x = x .* radius ./ max(radius, abs(x)); 
end


end % methods

end % classdef