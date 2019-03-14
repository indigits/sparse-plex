classdef ls
% Most of these methods are for reference only
% MATLAB provides high quality implementation of
% Least Squares problems.

methods(Static)

function x = normal_gvl4(A, b)
    % Method of normal equations
    % GVL4 algorithm 5.3.1
    import spx.la.tris;
    % Form the normal equations  A' A x  = A' b
    % Write C = A' A
    C = A' * A;
    % Write d = A' b
    d = A' * b;
    % Factorize C = G G'. Equation: G G' x = b
    G = chol(C, 'lower');
    % Let y = G' x
    % Solve the system G y = b
    y = tris.forward_col(G, d);
    % Solve the system G' x = y
    x = tris.back_col(G', y);
end % function

end % methods

end % classdef