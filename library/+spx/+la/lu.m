classdef lu

methods(Static)

function [L, U] = outer(A)
    % Computes the A = LU factorization without pivoting
    % This is an outer product version of LU factorization
    % A is modified in the algorithm
    % GVL4: algorithm 3.2.1
    [n,n] = size(A);
    for k=1:n-1
        % identify the range
        rho = k+1:n;
        % Compute L(k+1:n,k)...
        A(rho,k)   = A(rho,k)/A(k,k);
        % The outer product update...
        A(rho,rho) = A(rho,rho) - A(rho,k)*A(k,rho);
    end
    % extract the lower triangular part
    L = eye(n,n) + tril(A,-1);
    % extract the upper triangular part
    U = triu(A);
end % function


function [L, U] = gaxpy(A)
    % GAXPY version of LU factorization
    % A is modified in the algorithm
    % GVL4: Algorithm 3.2.2.
    [n,n] = size(A);
    % Create space for L and U factors
    % L will have 1s on the diagonal
    L = eye(n,n);
    U = zeros(n,n);
    for j=1:n
        if j==1
            v = A(:,1);
        else
            a = A(:,j);
            z = L(1:j-1,1:j-1)\a(1:j-1);
            U(1:j-1,j) = z;
            % This is GAXPY operation
            v(j:n) = a(j:n) - L(j:n,1:j-1)*z;
        end
        % Complete the computation of U(1:j,j) and L(j+1:n,j)...
        U(j,j) = v(j);
        L(j+1:n,j) = v(j+1:n)/v(j);
    end
end % function


function [L, U] = rect(A)
    % Computation of LU factorization of a rectangular matrix A
    % A is modified in the algorithm
    % GVL4: Section 3.2.10
    [n,r] = size(A);
    for k=1:r
        rho = k+1:n;
        % Compute L(k+1:n,k)...
        A(rho,k) = A(rho,k)/A(k,k);
        if k<r
            % The outer product update...
            mu = k+1:r;
            A(rho,mu) = A(rho,mu) - A(rho,k)*A(k,mu);
        end
    end
    L = tril(A);
    for k=1:r
        L(k,k) = 1;
    end
    U = triu(A(1:r,1:r));
end % function


end % methods 

end % classdef
