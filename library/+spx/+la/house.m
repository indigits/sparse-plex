classdef house

methods(Static)

function [v, beta] = gen(x)
    % Generates the householder reflection vector for a given vector x
    % P = I - beta * v * v' is the householder projection matrix
    % P is an orthogonal projector
    % P *x changes x in such a way that only 1st entry is non-zero
    % GVL4: algorithm 5.1.1
    m = length(x);
    if m == 1
        v = 0; beta = 0; return;
    end
    sigma = x(2:m)' * x(2:m);
    v = [1; x(2:m)];
    if sigma == 0  && x(1) >= 0
        beta = 0;
    elseif sigma == 0 && x(1) < 0
        beta = -2;
    else
        mu = sqrt(x(1)^2 + sigma);
        if x(1) <  0
            v(1) = x(1) - mu;
        else
            v(1) = -sigma /(x(1) + mu);
        end % if
        beta = 2 * v(1)^2 / (sigma + v(1)^2);
        v = v / v(1);
    end % if
end % func

function B = premul(A, v, beta)
    % Efficiently computes B = PA  = (I - beta v v') A
    B = A - (beta * v) *(v' * A);
end % func

function B = postmul(A, v, beta)
    % Efficiently computes B = AP  = A (I - beta v v')
    B = A - (A*v) * (beta * v)';
end % func

function beta = beta_from_v(v)
    beta = 2/(v'*v);
end

function v = from_essential_v(essential)
    v = [zeros(j-1,1); 1; essential];
end

function [W, Y] = wy(Q_factors)
    % Let Q be stored in the factored form Q = Q_1 * ... * Q_r
    % where Q_i = I - beta * v * v'
    % This algorithm computes W and Y such that
    % Q = I_r - W * Y';
    % GVL4: algorithm 5.1.2
    [m,r] = size(Q_factors);
    for j=1:r
        % extract j-th v from the factors array
        % The essential part of v
        essential = Q_factors(j+1:m,j);
        % Insert additional zeros and one to complete v
        v = [zeros(j-1,1); 1; essential];
        % Compute beta from v [it is not stored in factors array]
        beta = 2/(v'*v);
        if j==1
            % Initialize W and Y
            Y = v;
            W = beta*v;
        else
            % Update W and Y
            z = beta*(v - W*(Y(j:m,:)'*v(j:m)));
            Y = [Y v];
            W = [W z]; 
        end
    end
end

function B = wy_premul(A, W, Y)
    % Efficiently computes B = (I - WY') A
    B = A - W*(Y'*A);
end % func

function B = wy_postmul(A, W, Y)
    % Efficiently computes B = A (I - WY')
    B = A - (A*W)*Y';
end % func


function [Q_factors, R] = qr(A)
    % GVL4: Algorithm 5.2.1
    import spx.la.house;
    [m,n] = size(A);
    for j=1:min(n,m-1)
        % Compute the jth Householder matrix Q{j}...
        [v,beta] = house.gen(A(j:m,j));
        % Update...
        % A = Q{j}A
        A(j:m,j:n) = house.premul(A(j:m,j:n), v, beta);
        % Save the essential part of householder vector...
        A(j+1:m,j) = v(2:m-j+1);
    end
    % extract the R component
    R = triu(A(1:n,1:n));
    % extract the Q component in factored form
    Q_factors = tril(A,-1);
end

function Q = q_back_accum_thin(Q_factors)
    % Explicit formation of an orthogonal matrix from its factored form
    %   representation. Uses backward accumulation.
    % GVL4: Section 5.2.2
    % Produces a "thin", m x n Q
    % with orthonormal columns, the first n columns of Q_{1}...Q_{n}.
    [m,n] = size(Q_factors);
    % start with an empty matrix
    Q = [];
    % iterate over columns backwards
    for j=n:-1:1
        % extract the essential part of the j-th householder vector
        essential = Q_factors(j+1:m,j);
        % expand it
        v = [1;essential];
        % Compute beta from the vector
        beta = 2/(v'*v);
        % Expand the Q matrix with zeros on top right and bottom left 
        k = m-j;
        Q = [1 zeros(1,n-j);
             zeros(m-j,1) Q];
        % check if the essential part was non-zero
        if norm(essential)>0
            % premultiply Q with the householder projector
            Q = Q - (beta*v)*(v'*Q);
        end
    end
end


function Q = q_back_accum_full(Q_factors)
    % Explicit formation of an orthogonal matrix from its factored form
    %   representation. Uses backward accumulation.
    % Q_factors is m x n and 
    % Produces an m x m Q that is the product of of Q_{1}...Q_{n}.
    % GVL4: Section 5.2.2
    [m,n] = size(Q_factors);
    % We start with a matrix of size (m-n) x (m -n)
    % If m <= n, then we start with a matrix of size 1 x 1
    Q = eye(max(m-n,1),max(m-n,1));
    % We iterative over columns backwards
    for j=min(n,m-1):-1:1
        % Q_fact(j+1:m,j) is the essential part of the 
        % j-th Householder matrix Q_{j}.
        % Get the essential part of householder vector in this column
        essential = Q_factors(j+1:m,j);
        % Extend the vector with 1
        v = [1;essential];
        % Compute beta from the householder vector
        beta = 2/(v'*v);
        % Expand Q with zeros
        k = m-j;
        Q = [1 zeros(1,k);
             zeros(k,1) Q];
        % check for zero changes.
        if norm(essential)>0
            % premultiply with Householder projector
            Q = Q - (beta*v)*(v'*Q);
        end
   end
end % function


end % methods 

end % classdef

