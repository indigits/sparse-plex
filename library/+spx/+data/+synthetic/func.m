classdef func 

methods(Static)

function [x, y, res] = sinusoid(varargin)
    params = inputParser;
    params.addParameter('n', 10);
    params.addParameter('sigma', 0.1);
    params.addParameter('min', 0);
    params.addParameter('max', 1);
    params.addParameter('theta', 0);
    params.addParameter('f', 1);
    params.parse(varargin{:});
    res = params.Results;
    x = linspace(res.min, res.max, res.n)';
    y = sin(2*pi*res.f * x + res.theta) + res.sigma * randn(size(x));
end % function

end % methods

end % classdef

