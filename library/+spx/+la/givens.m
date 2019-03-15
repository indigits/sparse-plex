classdef givens

methods(Static)

function [c,s] = rotation(a,b)
    % Givens rotation computation
    % Determines cosine-sine pair (c,s) so that [c s;-s c]'*[a;b] = [r;0]
    % G = [c  s; -s c]
    % x = [a; b]
    % G' x = [r; 0]
    % GVL4: algorithm 5.1.3
    if b==0
        % No rotation needed
        c = 1; s = 0;
    else
        if abs(b)>abs(a)
            tau = -a/b; 
            s = 1/sqrt(1+tau^2); 
            c = s*tau;
        else
            tau = -b/a; 
            c = 1/sqrt(1+tau^2); 
            s = c*tau;
        end
    end
end % function

function G = planerot(x)
    % Mimics the planerot function of MATLAB
    a = x(1);
    b = x(2);
    if b==0
        % No rotation needed
        c = 1; s = 0;
    else
        sa = sign(a);
        sb = sign(b); 
        if abs(b)>abs(a)
            tau = -a/b; 
            s = -sb/sqrt(1+tau^2); 
            c = s*tau;
        else
            tau = -b/a; 
            c = sa/sqrt(1+tau^2); 
            s = c*tau;
        end
    end
    G = [c, -s; s c];
end % function

function theta = theta(c, s)
    theta = atan(s/c);
end

function [Q, R] = qr(A)
    % Givens method for computing the QR factorization A = QR.
    % A is modified in the algorithm
    % GVL4: algorithm 5.2.4
    import spx.la.givens.rotation;
    [m,n] = size(A);
    % Space for saving the Q factor
    Q = eye(m,m);
    % Iterate over columns from first to last
    for j=1:n
        % Iterate over rows from last pair to first pair
        for i=m:-1:j+1
            % pick two elements from consecutive rows
            a = A(i-1,j);
            b = A(i,j);
            % Compute the needed rotation for making b 0.
            [c,s] = rotation(a,b);
            % form the Givens rotation matrix
            G = [c s;-s c];
            % Rotate the two consecutive rows based submatrix
            A(i-1:i,j:n) = G'*A(i-1:i,j:n);
            % Rotate corresponding columns in Q matrix
            % by postmultiplication with G
            Q(:,i-1:i) = Q(:,i-1:i)*G;
        end
    end
    % Return the triangular form
    R = A;
end % function

end % methods 

end % classdef

