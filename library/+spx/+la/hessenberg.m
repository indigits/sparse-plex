classdef hessenberg
% Functions to work with Hessenberg forms

methods(Static)


function [Q, R] = qr(A)
    % Givens method for computing the QR factorization A = QR of a Hessenberg matrix.
    % A is modified in the algorithm
    % GVL4: algorithm 5.2.5
    import spx.la.givens.rotation;
    [n,n] = size(A);
    % Space for saving the Q factor
    Q = eye(n, n);
    % iterate over each column from first to last but one.
    for j=1:n-1
        % We need to process only one pair of rows
        % The diagonal element and immediate sub-diagonal element.
        a = A(j,j);
        b = A(j+1,j);
        % Compute the needed rotation for making b 0.
        [c,s] = rotation(a,b);
        % Form the givens rotation matrix.
        G = [c s;-s c];
        % Rotate the two consecutive rows based submatrix
        A(j:j+1,j:n) = G'*A(j:j+1,j:n);
        % Rotate corresponding columns n Q matrix
        % by postmultiplication with G
        Q(:,j:j+1) = Q(:,j:j+1)*G;
    end
    % Return the triangular form
    R = A;
end % function



function [H, cs, ss] = qr_rq(H)
    % Takes a Hessenberg matrix H = QR and returns RQ
    % GVL4: algorithm 7.4.1
    import spx.la.givens.rotation;
    [n,n] = size(H);
    % Space for storing the c and s values
    cs = zeros(1, n);
    ss = zeros(1, n);
    % first the QR factorization
    % iterate over each column from first to last but one.
    for k=1:n-1
        % We need to process only one pair of rows
        % The diagonal element and immediate sub-diagonal element.
        a = H(k,k);
        b = H(k+1,k);
        % Compute the needed rotation for making b 0.
        [c,s] = rotation(a,b);
        % Store the rotation
        cs(k) = c;
        ss(k) = s;
        % Form the givens rotation matrix.
        G = [c s;-s c];
        % Rotate the two consecutive rows based submatrix
        H(k:k+1,k:n) = G'*H(k:k+1,k:n);
    end
    % Now the RQ formation
    for k=1:n-1
        G = [cs(k) ss(k); -ss(k) cs(k)];
        H(1:k+1,k:k+1) = H(1:k+1,k:k+1) * G;
    end
    % The product of these Givens rotations is also upper Hessenberg.
    % Product of two Hessenberg matrices is Hessenberg.
end % function


function [H, U0] = hess(A)
    % Reduction of a square matrix A into Hessenberg form 
    % using Householder reflections
    % GVL4: algorithm 7.4.2
    [n,n] = size(A);
    import spx.la.house;
    % Iterate over columns of A
    for k=1:n-2
        % Compute the householder reflector for k-th column
        % covering only sub-diagonal elements
        [v,beta] = house.gen(A(k+1:n,k));
        % Update the submatrix of A by premultiplication with the Projector
        A(k+1:n,k:n) = A(k+1:n,k:n) - (beta*v)*(v'*A(k+1:n,k:n));
        % Postmultiply with the same projector without affecting
        % the 0's in the k-th column
        A(:,k+1:n) = A(:,k+1:n) - (A(:,k+1:n)*v)*(beta*v)';
        % Store the householder reflection vector 
        A(k+2:n,k) = v(2:n-k);
    end
    % Extract the Hessenberg form
    H = triu(A,-1);
    if nargout > 1
        % Extract the orthogonal matrix U_0 such that
        % A = U_0 H U_0^T
        U0 = eye(n,n);
        U0(2:n,2:n) = house.q_back_accum_full(A(2:n,1:n-1));
    end
end % function


function [H, i1, i2] = backsearch(H, z)
    % Searches for a subdiagonal entry in H which is
    % negligible. From last row to first row.
    if nargin < 2
        z = size(H, 2);
    end
    i1 = z;
    i2 = z;
    % Compute the Frobenius norm of H
    h_norm = norm(H, 'fro');
    % The threshold for negligible entries
    thr = eps * h_norm
    % iterate over diagonal entries backwards
    while i1 >1
        % check for negligible subdiagonal entry.
        fprintf('%d, %d, %e\n', i1, i1-1, H(i1, i1-1));
        if (abs(H(i1, i1-1)) < thr )
            % Make this entry zero
            H(i1, i1-1) = 0;
            if (i1 == i2)
                i2 = i1 - 1;
                i1 = i1 - 1;
            else
                return;
            end
        else
            i1 = i1 - 1;
        end

    end
end


end % methods 

end % classdef

