classdef tris

methods(Static)

function x = forward_row(L,b)
    % Solvex L x = b problem by forward substitution row wise
    % b gets overwritten in the process
    % GVL4: algorithm 3.1.1
    n = length(b);
    % start from last row
    for i=1:n
        b(i) = (b(i) - L(i, 1:i-1)* b(1:i-1)) / L(i,i);
    end
    x = b;
end % function


function x = back_row(U,b)
    % Solvex U x = b problem by back substitution row wise
    % b gets overwritten in the process
    % GVL4: algorithm 3.1.2
    n = length(b);
    % start from last row
    for i=n:-1:1
        b(i) = (b(i) - U(i, i+1:n) * b(i+1:n)) / U(i,i);
    end
    x = b;
end % function


function x = forward_col(L,b)
    % Solvex L x = b problem by forward substitution column wise
    % b gets overwritten in the process
    % GVL4: algorithm 3.1.3
    n = length(b);
    % start from last row
    for j=1:n
        b(j) = b(j) / L(j, j);
        b(j+1:n) = b(j+1:n) - L(j+1:n, j)*b(j);
    end
    x = b;
end % function

function x =  back_col(U, b)
    % Solves U x = b problem by back substitution column wise
    % b gets overwritten during the process
    % GVL4: algorithm 3.1.4
    n = length(b);
    % we iterate backwards from last column onwards
    for j=n:-1:1
        % Scale with the diagonal entry in this column
        b(j) = b(j)/U(j,j);
        % subtract rest of the column
        b(1:j-1) = b(1:j-1) - U(1:j-1,j)*b(j);
    end
    x = b;
end % function


end % methods 

end % classdef
