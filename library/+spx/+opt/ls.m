classdef ls
% Most of these methods are for reference only
% MATLAB provides high quality implementation of
% Least Squares problems.

methods(Static)

function x = normal_eq(A, b)
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


function x = house_ls(A, b)
    % Householder LS solution
    % Assumes A is full rank
    % GVL4 algorithm 5.3.2
    import spx.la.tris;
    import spx.la.house;
    % Perform householder QR factorization of A
    [QF, R] = house.qr(A);
    [m, n] = size(A);
    % A  = QR
    % QR x = b
    % R x = Q' b
    % We focus on computation of Q' b
    % Q = Q_1 ... Q_n
    % Q' b = Q_n' ... Q_1' b
    % Q_i' = Q_i [Householder orthogonal projector]
    % Q_i 'b = Q_i b
    % Iterate over householder vectors to compute b = Q_i b
    for j=1:n
        % extract the essential part of the j-th householder vector
        essential = QF(j+1:m,j);
        % expand it
        v = [1;essential];
        % Compute beta from the vector
        beta = 2/(v'*v);
        % Project b over corresponding householder projector
        b(j:m) = b(j:m) - beta * (v' * b(j:m)) * v;
    end % for
    % solve the upper triangular system R x  = Q' b.
    x = tris.back_col(R, b(1:n));
end % function

end % methods

end % classdef