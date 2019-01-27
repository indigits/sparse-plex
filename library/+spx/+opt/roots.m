classdef roots

methods(Static)
% Public static methods

function [x, change, iterations] = newton(f, df, x0, tolerance, max_iters)

if nargin < 2
    error("function and its derivative handles must be provided.");
end

if nargin < 3
    error('Initial estimate must be provided');
end

if nargin < 4
    tolerance = 1e-4;
end

if nargin < 5
    max_iters = 10;
end

% first estimate 
x = x0 - f(x0) / df(x0);
change = abs(x   - x0);
iterations = 1;
while (change >= tolerance) && iterations < max_iters
    % compute the change in x
    dx = f(x) / df(x);
    % update x
    x = x - dx;
    % update the absolute change
    change = abs(dx);
    % update iteration counter
    iterations = iterations + 1;
end
end % function

end % static methods

end % class
