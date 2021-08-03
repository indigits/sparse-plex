classdef rmse 
methods(Static)

function [r, sse, mse] = vec(x, y)
    % Computes Root Mean Square Error between two data-vectors
    % Identify the non-nan locations
    I = ~isnan(x) & ~isnan(y);
    % keep only the non-nan part
    x = x(I); 
    y = y(I);
    gap = x(:)-y(:);
    sse = sum(gap.^2);
    mse = sse / numel(gap);
    result = sqrt(mse);
end

end % methods
end % classdef

