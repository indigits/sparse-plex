classdef lowrank
% Generates matrices of low rank

methods(Static)

function A = from_randn(m, n, r)
    % Returns a low rank matrix constructed by randn(m, r) * randn(r, m)
    X = randn(m, r);
    Y  = randn(r, n);
    A = X * Y;
end % function

end % methods

end % classdef
