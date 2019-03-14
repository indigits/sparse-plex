classdef qr 
% Algorithms related to QR factorization
% These are mostly for reference


methods(Static)

function [Q, R] = gram_schmidt(A)
    [m, n] = size(A);
    if m < n
        error('Wide matrices not supported');
    end
    Q = zeros(m, n);
    R = zeros(n, n);
    for j=1:n
        % pick up the j-th column from A
        v = A(:, j);
        % Compute the projection of v on exiting columns
        for i = 1: j - 1
            % Pick up i-th Q vector
            qi  = Q(:, i);
            % Compute the projection of v on qi
            tmp = qi' * v;
            % Keep tmp as the coefficient in R
            R(i, j) = tmp;
            % Remove the projection from v
            v = v  - tmp * qi;
        end
        % Compute the norm of the new vector
        vnorm = norm(v);
        % Store it in R
        R(j, j) = vnorm;
        % Add the new vector to Q after normalization
        Q(:, j) = v / vnorm;
    end
end % function

function [Q, R] = mgs(A)
    % Modified Gram-Schmidt computation of the thin QR factorization A = QR
    % GVL4: algorithm 5.2.6
    [m,n] = size(A);
    % space for R factor
    R = zeros(n,n);
    %  space for Q factor
    Q = zeros(m,n);
    % Iterate over columns from first to last
    for k=1:n
        % fill the k-th diagonal entry in R
        R(k,k) = norm(A(:,k));
        % Initialize the k-th vector in Q
        Q(:,k) = A(:,k)/R(k,k);
        % Compute the inner product of new q vector with each of the remaining
        % columns in A and place in k-th row of R
        R(k,k+1:n) = Q(:,k)'*A(:,k+1:n);
        % Subtract the contribution of k-th q vector from all remaining columns of A.
        A(:,k+1:n) = A(:,k+1:n) - Q(:,k)*R(k,k+1:n);
    end
end % function

function [U, R] = householder_ur(A)
    % Performs QR decomposition using Householder reflectors
    % Doesn't return Q explicitly
    [m, n] = size(A);
    R = A;
    U  = zeros(m);
    for k=1:n
        % select elements from k-th column
        x = R(k:m, k);
        % compute the norm of x
        x_norm = norm(x);
        % construct a coordinate vector of length m - k + 1
        z = zeros(length(x), 1);
        z(1) = x_norm * sign(x(1));
        % construct the reflection vector
        u =  x + z;
        % compute norm squared of this
        norm_u_sqrd = u' * u;
        % Identify the part of R which will go through the
        % change in this iteration
        RR = R(k:m, k:n);
        % Update it
        R(k:m, k:n) = RR - 2*u*u'* RR / norm_u_sqrd;
        % Put the unit norm vector in Q
        U(k:m, k) = u;
    end
end % function

function [Q, R] = householder_qr(A)
    % Compute the QR decomposition of an mxn matrix A
    % using Householder transformations
    % see http://www.cs.cornell.edu/~bindel/class/cs6210-f09/lec18.pdf
    [m, n] = size(A);
    Q = eye(m); % Orthogonal transform so far
    R = A; % Transformed matrix so far
    % iterate over columns
    for k=1:n
        x = R(k:m, k);
        % compute the norm of x
        x_norm = norm(x);
        s = sign(x(1));
        % first entry
        u1 = x(1) + s*x_norm;
        % The reflection vector
        w = x / u1;
        w(1) = 1;
        tau = s * u1 / x_norm;
        % Update R matrix
        R(k:m, :) = R(k:m, :) - (tau*w)*(w' * R(k:m, :));
        % Update Q matrix
        Q(:, k:m) = Q(:, k:m) - (Q(:, k:m)*w)*(tau*w)';
    end

end % function

function [H, v] = householder_matrix(x)
    % Computes the householder matrix for a given x which 
    % can reflect it to the coordinate axis
    % i.e. H x = e
    % example usage:
    % x = rand(3, 1);
    % H = spx.la.qr.householder_matrix(x)
    % z = H * x
    % verify that z(1) == norm(x) and 
    % other entries in z are zero.
    n = length(x);
    x_norm = norm(x);
    xhat = [x_norm; zeros(n - 1, 1)];
    v = x - xhat;
    v = v ./ norm(v);
    H = eye(n) - 2 * v * v';
end % function


function [Q, R] =  givens_qr(A)
    % Implements Q, R factorization using Givens rotations
    [m, n] = size(A);
    Q = eye(m); % Orthogonal transform so far
    R = A; % Transformed matrix so far
    for c=1:n
        for r=m:-1:(c+1)
            x = R(r-1:r, c);
            G = planerot(x);
            % G will affect r-1 and r-th rows of R
            R(r-1:r, :) = G * R(r-1:r, :);
            % G will affect r-1 and r-th columns of Q
            Q(:, r-1:r) = Q(:, r-1:r) * G';
        end
    end 
end % function

end % methods

end % classdef

