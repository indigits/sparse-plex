classdef lanczos
% The code in this file is largely based on the code and papers for PROPACK
% developed by Rasmus Munk Larsen, 1998.

methods(Static)


function [U, B, V, p, details] = bd(A, k, options)
    % Perform bidiagonalization using Lanczos iterations
    % The U,V vectors are not re-orthogonalized
    % Based on Larsen 1998.
    [m, n] = size(A);
    if nargin < 2
        k = 4;
    end
    if nargin < 3
        options = struct;
    end
    if isfield(options, 'p0')
        p = options.p0;
    else
        p = rand(m, 1) - 0.5;
    end
    verbosity = 0;
    if isfield(options, 'verbosity')
        verbosity = options.verbosity;
    end
    alpha = zeros(k, 1);
    beta = zeros(k+1, 1);
    U = zeros(m, k);
    V = zeros(n, k);
    % We normalize the first left vector U_1
    beta(1) = norm(p);
    for j=1:k
        % Compute the new left vector U_{j}
        U(: , j) = p / beta(j);
        r  = A' * U(:, j);
        if j > 1
            r = r - beta(j)*V(:, j-1);
        end
        % Compute alpha_j
        alpha(j) = norm(r);
        % Compute V_j
        V(:, j) = r / alpha(j);
        % Compute p_j
        p = A * V(:, j) - alpha(j)*U(:, j);
        % Compute beta_{j +1}
        beta(j+1) = norm(p);
    end
    % Form the bidiagonal matrix B_k
    % Place k elements from alpha on the main diagonal
    % Leave beta(1) and place remaining elements 2:k+1 on subdiagonal
    % Number of rows is k+1
    % Number of columns is k.
    % B = spdiags([alpha beta(2:end)], [0, -1], k+1, k);
    B = spdiags([alpha(1:k) [beta(2:k); 0]], [0, -1], k, k);
    % fprintf('alpha: ');
    % spx.io.print.vector(alpha);
    % fprintf('beta: ');
    % spx.io.print.vector(beta);
    details.r = r;
    if verbosity > 1
        fprintf('alpha: ');
        spx.io.print.vector(alpha);
        fprintf('beta: ');
        spx.io.print.vector(beta);
    end
end


function [U, B, V, p, details] = bdfro(A, k, p)
    % Perform bidiagonalization using Lanczos iterations
    % with full reorthogonalization
    % Based on Larsen 1998.
    [m, n] = size(A);
    if nargin < 3
        p = rand(m, 1) - 0.5;
    end
    if nargin < 2
        k = 4;
    end
    alpha = zeros(k, 1);
    beta = zeros(k+1, 1);
    U = zeros(m, k);
    V = zeros(n, k);
    % We normalize the first left vector U_1
    beta(1) = norm(p);
    for j=1:k
        % Compute the new left vector U_{j}
        U(: , j) = p / beta(j);
        r  = A' * U(:, j);
        if j > 1
            r = r - beta(j)*V(:, j-1);
            % full reorthogonalization
            for i=1:j-1
                v = V(:, i);
                r = r - (v' * r) * v;
            end
        end
        % Compute alpha_j
        alpha(j) = norm(r);
        % Compute V_j
        V(:, j) = r / alpha(j);
        % Compute p_j
        p = A * V(:, j) - alpha(j)*U(:, j);
        % full reorthogonalization
        for i=1:j
            u = U(:, i);
            p = p - (u' * p) * u;
        end
        % Compute beta_{j +1}
        beta(j+1) = norm(p);
    end
    % Form the bidiagonal matrix B_k
    % Place k elements from alpha on the main diagonal
    % Leave beta(1) and place remaining elements 2:k+1 on subdiagonal
    % Number of rows is k+1
    % Number of columns is k.
    % B = spdiags([alpha beta(2:end)], [0, -1], k+1, k);
    B = spdiags([alpha(1:k) [beta(2:k); 0]], [0, -1], k, k);
    % fprintf('alpha: ');
    % spx.io.print.vector(alpha);
    % fprintf('beta: ');
    % spx.io.print.vector(beta);
    details.r = r;
    details.p = p;
end


function [U, B, V, p, details] = bdpro(A, k, options)
    % Perform bidiagonalization using Lanczos iterations
    % with partial reorthogonalization
    % Based on Larsen 1998.
    if nargin < 1
        error('A must be specified.');
    end
    if nargin < 2
        error('Number of required singular values must be specified');
    end
    [m, n] = size(A);
    if nargin < 3
        options = struct;
    end
    if isfield(options, 'p0')
        p = options.p0;
    else
        p = rand(m, 1) - 0.5;
    end
    % very simple cases
    if min(m, n) == 0
        % There is nothing to solve, empty input.
        U = [];
        B = [];
        V = [];
        return;
    end
    if min(m, n) == 1
        % A is either a row vector or column vector
        % No factorization needed
        U = 1;
        V = 1;
        B = A;
        return;
    end

    m2 = 3/2;
    n2 = 3/2;

    % desired level of orthogonality
    delta = sqrt(eps/k);
    if isfield(options, 'delta')
        delta = options.delta;
    end

    % desired level of orthogonality after reorthogonalization
    eta = eps^(3/4) / sqrt(k);
    if isfield(options, 'eta')
        eta = options.eta;
    end

    % tolerance for iterate Gram-Schmidt
    gamma = 1/sqrt(2);
    if isfield(options, 'gamma')
        gamma = options.gamma;
    end
    % Flag for switching between iterated MGS and CGS
    cgs = 0;
    if isfield(options, 'cgs')
        cgs = options.cgs;
    end
    % extended local reorthogonalization flag
    elr = 2;
    if isfield(options, 'elr')
        elr = options.elr;
    end
    % Estimated value of the norm of A
    anorm = [];
    % flag to indicate if we should continue updating the estimate of
    % A norm
    est_anorm = 1;
    % Fudge factor for ||A||_2 estimate.
    FUDGE = 1.01;
    % Ensure that p is a column vector
    p = p(:);
    % Number of U inner products
    npu = 0; 
    % Number of V inner products
    npv = 0;
    % Indicator for finishing before k iterations 
    ierr = 0;

    % Prepare for Lanczos iterations
    U = zeros(m, k);
    V = zeros(n, k);
    alpha = zeros(k, 1);
    beta = zeros(k+1, 1);
    % We compute the norm of p to normalize the first left vector U_1
    beta(1) = norm(p);
    % Initialize the recurrences for tracking the loss of orthogonality
    % inner product of v_j with v_i
    nu = zeros(k, 1);
    % inner product of u_j with u_i
    mu = zeros(k+1, 1);
    %TODO these two lines can be removed I guess.
    nu(1) = 1;
    mu(1) = 1;
    % maximum values of nu and mu for each iteration
    numax = zeros(k, 1);
    mumax = zeros(k, 1);
    force_reorth = 0;
    % Number of reorthogonalizations on U
    nreorthu = 0; 
    % Number of reorthogonalizations on V
    nreorthv = 0;
    % transpose of A for future use
    At = A';
    % if delta is zero, then user has requested full reorthogonalization
    fro = (delta == 0);
    % Iterate for k vectors
    for j=1:k
        if options.verbosity > 1
            fprintf('\nIteration: j: %d\n\n', j);
        end
        % Compute the new left vector U_j
        if beta(j) ~= 0
            % normalization of p and assignment as new vector
            U(: , j) = p / beta(j);
        else
            % new left vector is 0 vector
            U(: , j) = p;
        end
        if j == 6
            %Replace A norm estimate with largest Ritz value
            % Form the B matrix size: (j, j-1)
            B = [[diag(alpha(1:j-1))+diag(beta(2:j-1),-1)]; ...
              [zeros(1,j-2),beta(j)]];
            % Norm of A is just slightly larger than norm of B
            anorm = FUDGE*norm(B);
            % We don't need to update norm of A anymore
            est_anorm = 0;
        end
        %%%% Computation of next right vector V_j starts %%%
        if j == 1
            r  = At * U(:, 1);
            alpha(1) = norm(r);
            % Make an estimate of norm of A
            if est_anorm
                anorm = FUDGE * alpha(1);
            end
        else % j > 1
            % Compute r
            r = At * U(:, j) - beta(j)*V(:, j-1);
            % Compute alpha_j
            alpha(j) = norm(r);

            % Extended local reorthogonalization    
            if alpha(j)<gamma*beta(j) & elr & ~fro
                normold = alpha(j);
                % we iterate till r has significant V_{j-1} component
                stop = 0;
                while ~stop
                    % Component of r along V_{j-1}
                    t = V(:,j-1)'*r;
                    % Subtract it from r
                    r = r - V(:,j-1)*t;
                    % Update its norm
                    alpha(j) = norm(r);
                    % add this correction term to beta_j 
                    if beta(j) ~= 0
                        beta(j) = beta(j) + t;
                    end
                    % Check if there wasn't any significant reduction
                    if alpha(j)>=gamma*normold
                        % Not enough reduction. We stop
                        stop = 1;
                    else
                        % continue reorthogonalization
                        normold = alpha(j);
                    end
                end % while ~stop
            end % extended local reorthogonalization
            % update norm estimate for j > 1
            if est_anorm
                if j==2
                    % alpha(j-1)* beta(j-1) component not applicable for j=2
                    anorm = max(anorm,FUDGE*sqrt(alpha(1)^2+beta(2)^2+alpha(2)*beta(2)));
                else  
                    anorm = max(anorm,FUDGE*sqrt(alpha(j-1)^2+beta(j)^2+alpha(j-1)* ...
                        beta(j-1) + alpha(j)*beta(j)));
                end % j ~= 2
            end % est_anorm
        end % j > 1
        % step 2.1 a update nu
        if ~fro & alpha(j) ~= 0 & j > 1
            % Update estimates of the level of orthogonality for the
            %  columns 1 through j-1 in V.
            nu = update_nu(nu,mu,j,alpha,beta,anorm);
            % compute the maximum absolute inner product
            numax(j) =  max(abs(nu(1:j-1)));
        end
        if elr>0 & j > 1
            % TODO what's going on here? 
            % We always reorthogonalize against the previous vector
            nu(j-1) = n2*eps;
        end

        % IF level of orthogonality is worse than delta THEN 
        %    Reorthogonalize v_j against some previous  v_i's, 0<=i<j.
        if ( fro | numax(j) > delta | force_reorth ) & alpha(j)~=0
            % step 2.1 b select indices to orthogonalize against.
            % Decide which vectors to orthogonalize against:
            if fro | eta==0
                % We need to reorthogonalize against all previous v_i
                int = [1:j-1]';
            elseif force_reorth==0
                % Let's identify the indices of vectors against which to orthogonalize
                int = compute_int(nu,j-1,delta,eta,0,0,0);
            end
            % Else use int from last reorth. to avoid spillover from mu_{j-1} 
            % to nu_j.          
            % Reorthogonalize r against v_i in selected indices
            [r,alpha(j),rr] = reorth(V,r,alpha(j),int,gamma,cgs);
            % number of inner products.
            npv = npv + rr*length(int);
            % Reset nu for orthogonalized vectors.
            nu(int) = n2*eps;
            % TODO what's going on here? 
            % If necessary force reorthogonalization of u_{j+1} 
            % to avoid spillover
            if force_reorth==0 
                force_reorth = 1; 
            else
                force_reorth = 0;
            end
            nreorthv = nreorthv + 1;
        end

        % Check for convergence or failure to maintain semiorthogonality
        if alpha(j) < max(n,m)*anorm*eps & j<k, 
            % If alpha is "small" we deflate by setting it
            % to 0 and attempt to restart with a basis for a new 
            % invariant subspace by replacing r with a random starting vector:
            alpha(j) = 0;
            % a flag to be set false if we find a suitable vector orthogonal to V(:, 1:j-1)
            bailout = 1;
            for attempt=1:3
                % Try a new starting vector
                r = rand(m,1)-0.5;
                r = At*r;
                % not necessary to compute the norm accurately here.
                nrm=sqrt(r'*r);
                int = [1:j-1]';
                % Reorthogonalize r against existing V vectors
                [r,nrmnew,rr] = reorth(V,r,nrm,int,gamma,cgs);
                % Update the count of v inner products
                npv = npv + rr*length(int(:));
                % Number of V reorthogonalizations
                nreorthv = nreorthv + 1;
                % Update the current inner product estimates
                nu(int) = n2*eps;
                if nrmnew > 0
                    % A vector numerically orthogonal to span(V_k(:,1:j-1)) was found. 
                    % Continue iteration.
                    bailout=0;
                    break;
                end
            end % for attempts
            if bailout
                % We couldn't find a new vector orthogonal to invariant subspace
                % Number of iterations for which V vectors were successfully identified.
                j = j-1;
                % Indicator that we failed in j-th iteration
                ierr = -j;
                % break out of the loop of computing U and V vectors.
                break;
            else
                % Continue with new normalized r as starting vector.
                r=r/nrmnew;
                force_reorth = 1;
                if delta>0
                    % Turn off full reorthogonalization.
                    fro = 0;
                end
            end % if bailout      
        elseif  j<k & ~fro & anorm*eps > delta*alpha(j)
            ierr = j;
        end % if Check for convergence
        % Compute V_j
        if alpha(j) ~= 0
            V(:,j) = r/alpha(j);
        else
            V(:,j) = r;
        end
        %%%%%%%%%% Lanczos step to generate u_{j+1}. %%%%%%%%%%%%%
        % Compute p_j
        p = A * V(:, j) - alpha(j)*U(:, j);
        % Compute beta_{j +1}
        beta(j+1) = norm(p);
        % Extended local reorthogonalization
        if beta(j+1)<gamma*alpha(j) & elr & ~fro
            normold = beta(j+1);
            stop = 0;
            while ~stop
                t = U(:,j)'*p;
                p = p - U(:,j)*t;
                beta(j+1) = norm(p);
                if alpha(j) ~= 0 
                    alpha(j) = alpha(j) + t;
                end
                if beta(j+1) >= gamma*normold
                    stop = 1;
                else
                    normold = beta(j+1);
                end
            end
        end % extended local reorthogonalization
        if est_anorm
            % We should update estimate of ||A||  before updating mu - especially  
            % important in the first step for problems with large norm since alpha(1) 
            % may be a severe underestimate!  
            if j==1
              anorm = max(anorm,FUDGE*pythag(alpha(1),beta(2))); 
            else
              anorm = max(anorm,FUDGE*sqrt(alpha(j)^2+beta(j+1)^2 + alpha(j)*beta(j)));
            end
        end %  est_norm
        if ~fro & beta(j+1) ~= 0
            % Update estimates of the level of orthogonality for the columns of U.
            mu = update_mu(mu,nu,j,alpha,beta,anorm);
            mumax(j) = max(abs(mu(1:j)));  
        end % update mu
        % TODO what's happening here? 
        if elr>0
            mu(j) = m2*eps;
        end

        % IF level of orthogonality is worse than delta THEN 
        %    Reorthogonalize u_{j+1} against some previous  u_i's, 0<=i<=j.
        if (fro | mumax(j) > delta | force_reorth) & beta(j+1)~=0
            % Decide which vectors to orthogonalize against.
            if fro | eta==0
                int = [1:j]';
            elseif force_reorth==0
                int = compute_int(mu,j,delta,eta,0,0,0); 
            else
                int = [int; max(int)+1];
            end
            % Reorthogonalize u_{j+1} 
            [p,beta(j+1),rr] = reorth(U,p,beta(j+1),int,gamma,cgs);    
            % number of U inner products
            npu = npu + rr*length(int); 
            % Number of U reorthogonalizations 
            nreorthu = nreorthu + 1;    
            % Reset mu to epsilon.
            mu(int) = m2*eps;
            if force_reorth==0
                % Force reorthogonalization of v_{j+1}.
                force_reorth = 1;
            else
                force_reorth = 0; 
            end
        end % if Reorthogonalize


        % Check for convergence or failure to maintain semiorthogonality
        if beta(j+1) < max(m,n)*anorm*eps  & j<k,     
        % If beta is "small" we deflate by setting it
        % to 0 and attempt to restart with a basis for a new 
        % invariant subspace by replacing p with a random starting vector:
        %j
        %disp('restarting, beta = 0')
            beta(j+1) = 0;
            bailout = 1;
            for attempt=1:3
                % Try a new random vector
                p = rand(n,1)-0.5;
                % Project it
                p = A*p;
                % not necessary to compute the norm accurately here.
                nrm=sqrt(p'*p);
                % Orthogonalize against existing U vectors
                int = [1:j]';
                [p,nrmnew,rr] = reorth(U,p,nrm,int,gamma,cgs);
                % Update number of U inner products
                npu = npu + rr*length(int(:));  
                % Update number of U reorthogonalizations
                nreorthu = nreorthu + 1;
                mu(int) = m2*eps;
                if nrmnew > 0
                % A vector numerically orthogonal to span(Q_k(:,1:j)) was found. 
                % Continue iteration.
                    bailout=0;
                    break;
                end
            end % for attempts
            if bailout
                % No suitable vector could be found
                ierr = -j;
                break;
            else
                % Continue with new normalized p as starting vector.
                p=p/nrmnew;
                force_reorth = 1;
                if delta>0
                    % Turn off full reorthogonalization.
                    fro = 0;
                end
            end   % if bailout
        elseif  j<k & ~fro & anorm*eps > delta*beta(j+1) 
            %    fro = 1;
            ierr = j;
        end  % convergence check
    end
    if j<k
        % Number of iterations actually computed
        k = j;
    end
    % % last column
    % if beta(j+1) ~= 0
    %     % normalization of p and assignment as new vector
    %     U(: , j+1) = p / beta(j+1);
    % else
    %     % new left vector is 0 vector
    %     U(: , j+1) = p;
    % end
    % Form the bidiagonal matrix B_k
    % Place k elements from alpha on the main diagonal
    % Leave beta(1) and place remaining elements 2:k+1 on subdiagonal
    % Number of rows is k+1
    % Number of columns is k.
    % B = spdiags([alpha(1:k) beta(2:k+1)], [0, -1], k+1, k);
    % B = spdiags([alpha(1:k) beta(2:k+1)], [0, -1], k, k);
    % The following version is from the Larsen code
    B = spdiags([alpha(1:k) [beta(2:k); 0]], [0, -1], k, k);
    % fprintf('alpha: ');
    % spx.io.print.vector(alpha);
    % fprintf('beta: ');
    % spx.io.print.vector(beta);
    details.nreorthu = nreorthu;
    details.nreorthv = nreorthv;
    details.npu = npu;
    details.npv = npv;
    details.ierr = ierr;
end



end % methods 

end % classdef



function mu = update_mu(mu,nu,j,alpha,beta,anorm)
% UPDATE_MU:  Update the mu-recurrence for the u-vectors.
%  Adapted from Rasmus Munk Larsen, DAIMI, 1998.
    binv = 1/beta(j+1);
    eps1 = 100*eps/2;
    if j==1
        T = eps1*(pythag(alpha(1),beta(2)) + pythag(alpha(1),beta(1)));
        T = T + eps1*anorm;
        mu(1) = T / beta(2);
    else
        mu(1) = alpha(1)*nu(1) - alpha(j)*mu(1);
        %  T = eps1*(pythag(alpha(j),beta(j+1)) + pythag(alpha(1),beta(1)));
        T = eps1*(sqrt(alpha(j).^2+beta(j+1).^2) + sqrt(alpha(1).^2+beta(1).^2));
        T = T + eps1*anorm;
        mu(1) = (mu(1) + sign(mu(1))*T) / beta(j+1);
        % Vectorized version of loop:
        if j>2
            k=2:j-1;
            mu(k) = alpha(k).*nu(k) + beta(k).*nu(k-1) - alpha(j)*mu(k);
            T = eps1*(sqrt(alpha(j).^2+beta(j+1).^2) + sqrt(alpha(k).^2+beta(k).^2));
            T = T + eps1*anorm;
            mu(k) = binv*(mu(k) + sign(mu(k)).*T);
        end
        T = eps1*(sqrt(alpha(j).^2+beta(j+1).^2) + sqrt(alpha(j).^2+beta(j).^2));
        T = T + eps1*anorm;
        mu(j) = beta(j)*nu(j-1);
        mu(j) = (mu(j) + sign(mu(j))*T) / beta(j+1);
    end  
    mu(j+1) = 1;
end % function


function nu = update_nu(nu,mu,j,alpha,beta,anorm)
% Updates the estimates of inner products for right vectors <v_i , v_j>
%  Adapted from Rasmus Munk Larsen, DAIMI, 1998.
    ainv = 1/alpha(j);
    eps1 = 100*eps/2;
    if j>1
        k = 1:(j-1);
        T = eps1*(sqrt(alpha(k).^2+beta(k+1).^2) + sqrt(alpha(j).^2+beta(j).^2));
        T = T + eps1*anorm;
        nu(k) = beta(k+1).*mu(k+1) + alpha(k).*mu(k) - beta(j)*nu(k);
        nu(k) = ainv*(nu(k) + sign(nu(k)).*T);
    end
    % v_j' v_j is always 1. 
    nu(j) = 1;
end % function



function int = compute_int(mu,j,delta,eta,LL,strategy,extra)
%COMPUTE_INT:  Determine which Lanczos vectors to reorthogonalize against.
%
%      int = compute_int(mu,eta,LL,strategy,extra))
%
%   Notice: The first LL vectors are excluded since the new Lanczos
%   vector is already orthogonalized against them in the main iteration.

%  Adapted from Rasmus Munk Larsen, DAIMI, 1998.
    if (delta<eta)
      error('DELTA should satisfy DELTA >= ETA.')
    end
    switch strategy
      case 0
        %   Strategy 0: Orthogonalize vectors v_{i-r-extra},...,v_{i},...v_{i+s+extra} 
        %               with nu>eta, where v_{i} are the vectors with  mu>delta.
        I0 = find(abs(mu(1:j))>=delta);    
        if length(I0)==0
          [mm,I0] = max(abs(mu(1:j)));
        end    
        int = zeros(j,1);
        for i = 1:length(I0)
          for r=I0(i):-1:1
            if abs(mu(r))<eta | int(r)==1 
              break;
            else
              int(r) = 1;
            end
          end
          int(max(1,r-extra+1):r) = 1;
          for s=I0(i)+1:j
            if abs(mu(s))<eta | int(s)==1  
              break;
            else
              int(s) = 1;
            end
          end
          int(s:min(j,s+extra-1)) = 1;
        end
        if LL>0
          int(1:LL) = 0;
        end
        int = find(int);
      case 1
        %   Strategy 1: Orthogonalize all vectors v_{r-extra},...,v_{s+extra} where
        %               v_{r} is the first and v_{s} the last Lanczos vector with
        %               mu > eta.
        int=find(abs(mu(1:j))>eta);
        int = max(LL+1,min(int)-extra):min(max(int)+extra,j);
      case 2
        %   Strategy 2: Orthogonalize all vectors with mu > eta.
        int=find(abs(mu(1:j))>=eta);
    end
    int = int(:);
end % function


function [r,normr,nre,s] = reorth(Q,r,normr,index,alpha,method)

%REORTH   Reorthogonalize a vector r using iterated Gram-Schmidt against vectors in Q
%
%   If method==0 then iterated modified Gram-Schmidt is used.
%   If method==1 then iterated classical Gram-Schmidt is used.
%
%
%  Adapted from Rasmus Munk Larsen, DAIMI, 1998.
    if nargin<2
      error('Not enough input arguments.');
    end
    % length and number of vectors in Q
    [n k1] = size(Q);
    if nargin<3 | isempty(normr)
        normr = sqrt(r'*r);
    end
    % The indices of vectors in Q which are to be orthogonalized against.
    % k indicates the number of vectors to be orthogonalized against.
    if nargin<4 | isempty(index)
        k=k1;
        index = [1:k]';
        simple = 1;
    else
        k = length(index);
        if k==k1 & index(:)==[1:k]'
            % We need to orthogonalize against all vectors in sequence
            simple = 1;
        else
            % selective vectors in specified order to be orthogonalized against
            simple = 0;
        end
    end
    if nargin<5 | isempty(alpha)
        alpha=0.5;  % This choice guaranties that 
                    % || Q^T*r_new - e_{k+1} ||_2 <= 2*eps*||r_new||_2,
                    % cf. Kahans ``twice is enough'' statement proved in 
                    % Parletts book.
    end
    if nargin<6 | isempty(method)
        % By default, we use iterated MGS
        method = 0;
    end
    if k==0 | n==0
        % Nothing to do
        return;
    end
    if nargout>3
        % corrections made for each vector in Q
        s = zeros(k,1);
    end
    % old value of norm of r
    normr_old = 0;
    % number of reorthogonalizations
    nre = 0;
    % We iterate till norm of r keeps reducing significantly
    while normr < alpha*normr_old | nre==0
        if method==1
            % CGS
            if simple
                % Compute projections of r on vectors in Q
                t = Q'*r;
                % Subtract the projections
                r = r - Q*t;
            else
                t = Q(:,index)'*r;
                r = r - Q(:,index)*t;
            end
        else
            % MGS
            for i=index,
                % Compute projection over vector 
                t = Q(:,i)'*r;
                % subtract the projection
                r = r - Q(:,i)*t;
            end
        end
        if nargout>3
            % update the corrections
            % TODO, should be done differently for MGS
            s = s + t;
        end
        % keep old value or norm of r
        normr_old = normr;
        % compute new value of norm of r
        normr = sqrt(r'*r);
        % number of reorthogonalizations
        nre = nre + 1;
        if nre > 4
            % r is in span(Q) to full accuracy => accept r = 0 as the new vector.
            r = zeros(n,1);
            normr = 0;
            return;
        end
    end %  while
end % function
