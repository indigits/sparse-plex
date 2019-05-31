classdef schur
% Methods for computing the Schur form

methods(Static)

function kappa = wilk_shift(a,b,c,d)
    % Computes the Wilkinson shift for 2x2 sub-matrix
    kappa = d;
    % check if the matrix is 0
    s = abs(a) + abs(b) + abs(c) + abs(d);
    if (s == 0)
        % nothing to do
        return;
    end

    q = (b/s)*(c/s);

    if (q ~= 0)
        p = 0.5*((a/s) - (d/s));
        r = sqrt(p*p + q);
        if ( (real(p)*real(r) + imag(p)*imag(r)) < 0 )
            r = -r;
        end
        kappa = kappa - s*(q/(p+r));
    end
end % function

function [H, U, details] = qr_hessenberg(A, options)
    % Computes the eigen values of A through
    % QR algorithm based on Hessenberg decomposition
    % GVL4 : Equation 7.5.1
    if nargin < 2
        options = struct;
    end
    [m, n] = size(A);
    tolerance = 1e-6;
    if isfield(options, 'tolerance')
        tolerance = options.tolerance;
    end
    max_iterations = 30;
    if isfield(options, 'max_iterations')
        max_iterations = options.max_iterations;
    end
    import spx.la.hessenberg;
    % Compute the Hessenberg form of A
    [H, U0] = hessenberg.hess(A);
    U = U0;
    iter = 0;
    gap = 1;
    lambda_prev = ones(n, 1);
    % Perform Hessenberg QR iterations
    while gap > tolerance && iter < max_iterations
        %  Perform one QR factorization of H
        [H, cs, ss] = hessenberg.qr_rq(H);
        % Update U
        for k=1:n-1
            G = [cs(k) ss(k); -ss(k) cs(k)];
            U(:,k:k+1) = U(:,k:k+1)*G;
        end
        % pick the approximate eigen values from the diagonal
        lambdas = diag(H);
        % compute the ratio with previous values on diagonal
        gap = lambdas ./ lambda_prev;
        % measure how close are the ratios with 1
        gap = abs(abs(gap) - 1);
        % maximum ratio
        gap = max(max(gap));
        lambda_prev = lambdas;
        iter = iter + 1;
    end % while
    details.iterations = iter;
end % functions


function [H, Z]  = francis_step(H, Z)
    % A step of Francis algorithm for computation of Schur form
    % which applies the double implicit shift and chases the
    % bulge formed after that
    % H0 is Hessenberg form of a matrix.
    % GVL4 algorithm 7.5.1
    n = length(H);
    if n<=2
        % The matrix is already in quasi-triangular form
        % There is nothing left to do
        return
    end
    % Initialize Q array if necessary
    if nargout > 1
        if nargin  < 2
            Z = eye(n);
        end
    end
    import spx.la.house;
    % Let's examine the two eigen values 
    % of the bottom right 2x2 matrix
    m = n-1;
    % sum of eigen values is the trace of the matrix
    s = H(m,m)+H(n,n);
    % product of eigen values is the determinant
    t = H(m,m)*H(n,n) - H(m,n)*H(n,m);
    % Compute the first column of (H-alfa1*I)(H-alfa2*I)) where
    % alfa 1 and alfa2 are the eigenvalues of the lower 2x2...
    x = H(1,1)*H(1,1)+H(1,2)*H(2,1) - s*H(1,1) + t;
    y = H(2,1)*(H(1,1)+H(2,2)-s);
    z = H(2,1)*H(3,2);
    % Chase the bulge...
    for k=0:n-3
        % compute the Householder reflection
        % disp([x, y, z])
        [v,beta] = house.gen([x;y;z]);
        q = max(1,k);
        % Apply the reflection (pre multiplication) to relevant three rows
        H(k+1:k+3,q:n) =  H(k+1:k+3,q:n) - (beta*v)*(v'*H(k+1:k+3,q:n));
        % disp(H)
        % Apply the reflection (post multiplication) accordingly
        r = min(k+4,n);
        H(1:r,k+1:k+3) =  H(1:r,k+1:k+3) - (H(1:r,k+1:k+3)*v)*(beta*v)';
        % disp(H)
        % update x, y, z
        x = H(k+2,k+1);
        y = H(k+3,k+1);
        if k<n-3
            % z cannot be updated in last iteration
            z = H(k+4,k+1);
        end
        if nargout > 1
            % We need to update Z 
            Z(1:r,k+1:k+3) =  Z(1:r,k+1:k+3) - (Z(1:r,k+1:k+3)*v)*(beta*v)';
        end
    end
    %  One final update for last pair of rows
    % Compute the reflection vector
    [v,beta] = house.gen([x;y]);
    % Pre-multiply the projector over two rows
    H(n-1:n,n-2:n) = H(n-1:n,n-2:n) - (beta*v)*(v'*H(n-1:n,n-2:n));
    % Corresponding post multiplication
    H(1:n,n-1:n) = H(1:n,n-1:n) - (H(1:n,n-1:n)*v)*(beta*v)';
    if nargout > 1
        % We need to update Z 
        Z(1:n,n-1:n) = Z(1:n,n-1:n) - (Z(1:n,n-1:n)*v)*(beta*v)';
    end
end % function


function [T, Q, details] = francis(A, options)
    % Computes the Schur decomposition of A 
    % using Francis implicit shift algorithm
    % GVL4: algorithm 7.5.2
    if nargin < 2
        options = struct;
    end
    % size of matrix
    n = size(A, 2);
    tolerance = 1e-11;
    if isfield(options, 'tolerance')
        tolerance = options.tolerance;
    end
    max_iterations = 30;
    if isfield(options, 'max_iterations')
        max_iterations = options.max_iterations;
    end
    compute_full_u = false;
    if isfield(options, 'compute_full_u')
        compute_full_u = options.compute_full_u;
    end
    import spx.la.hessenberg;
    [T, Q] = hessenberg.hess(A);
    iter = 0;
    m = n;
    % Iterate till the whole matrix becomes quasi triangular
    while m > 2
        % find the beginning of quasi-triangular part
        % from bottom
        m = find_lower_quasi_triangular_block(T, m);
        if m <= 2
            % The whole matrix is quasi-triangular
            break;
        end
        % The end of upper Hessenberg part
        q = m -1;
    end
    details.iterations = iter;
end

end % methods
end  % classdef


function m = find_lower_quasi_triangular_block(T, m)
    % Looks for a quasi-triangular block starting from m-th row
    while m>2 && (H(m,m-1)==0 || H(m-1,m-2)==0)
       if H(m,m-1)==0
           m = m-1;
       elseif H(m-1,m-2)==0
           m = m-2;
       end
   end
end
