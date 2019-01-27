%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main problem is minimize \| A x \|_1 subject to A x = b
% We introduce z = A x - b
% x \in R^n A \in R^{m x n} b \in R^m
% m < n
% ADMM terms
% minimize f(x) + g(z) subject to A x + B z = c
% f(x) : {x \in R^n | Ax = b}
% g(z) : \| z \|_1
% minimize f(x) + \| z \|_1 subject to x - z = 0
% A : 1
% B : -1
% c : 0
% 
% x update x  = proj (z - u) over the set {Ax = b}
% z update: z = shrinkage(x + u)
% u update : u = u + x - z
%
% Primal residual r = A x  + B z - c :  x - z
% Dual residual s = rho A^T B (z_new - z_old) = rho (z_old - z_new)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x, history] = bp(A, b, options)
    if nargin < 2 || nargin > 3
        error('Invalid arguments');
    end
    if nargin < 3
        options = struct;
    end
    % weight for the quadratic penalty term
    rho = 1;
    if isfield(options, 'rho')
        rho = options.rho;
    end
    % weight for the relaxation
    alpha = 1;
    if isfield(options, 'alpha')
        alpha = options.alpha;
    end
    % size of the matrix
    [M, N] = size(A);
    % Main optimization variable
    if isfield(options, 'x')
        x = options.x;
    else
        x = zeros(N, 1);
    end
    % Auxiliary optimization variable z = Ax - b
    % Goal of ADMM iterations is to bring z closer to Ax - b
    if isfield(options, 'z')
        z = options.z;
    else
        z = zeros(N, 1);
    end
    % scaled Lagrangian variable
    if isfield(options, 'u')
        u = options.u;
    else
        u = zeros(N, 1);
    end
    % verbosity
    verbose = 0;
    if isfield(options, 'verbose')
        verbose = options.verbose;
    end
    % Maximum number of ADMM iterations
    max_iterations = 1000;
    if isfield(options, 'max_iterations')
        max_iterations = options.max_iterations;
    end
    % absolute tolerance
    eps_abs = 1e-4;
    if isfield(options, 'absolute_tolerance')
        eps_abs = options.absolute_tolerance;
    end
    % relative tolerance
    eps_rel = 1e-2;
    if isfield(options, 'relative_tolerance')
        eps_rel = options.relative_tolerance;
    end
    %  Compute and cache factorizations
    AAt = A*A';
    P = eye(N) - A' * (AAt\A);
    % pseudo-inverse based solution of equation Ax=b
    q = A' * (AAt \b);
    % import relevant functions
    import spx.opt.shrinkage;
    if verbose
        fprintf('%3s\t%10s\t%10s\t%10s\t%10s\t%10s\n', 'iter', ...
          'r norm', 'eps pri', 's norm', 'eps dual', 'objective');
    end
    % perform ADMM iterations
    for k=1:max_iterations
        % preserve old value of z
        z_old = z;
        % update x as a projection on to the set {Ax = b}
        % we add the projection of (z-u) to the null-space of A and add
        % it to the pseudo-inverse solution of Ax = b
        x = P*(z-u) + q;
        % relaxation
        if alpha ~= 1
            x_hat = alpha*x + (1-alpha)*z;
        else
            x_hat = x;
        end
        % update z
        z = shrinkage(x_hat + u, 1/rho);
        % update u
        u = u + (x_hat - z);
        % primal residual
        r = x - z;
        r_norm = norm(r);
        % dual residual
        s = rho * (z_old - z);
        s_norm = norm(s);
        % upper bound on primal residual
        eps_primal = sqrt(N) * eps_abs + eps_rel * max([norm(x), norm(z)]);
        eps_dual = sqrt(N) * eps_abs + eps_rel * norm(rho*u);
        if verbose
            % value of objective function
            objective_value = objective(x);
            fprintf('%3d\t%10.4f\t%10.4f\t%10.4f\t%10.4f\t%10.2f\n', k, ...
            r_norm, eps_primal, s_norm, eps_dual, objective_value);
        end
        if r_norm < eps_primal && s_norm < eps_dual
            % We have achieved convergence
            break;
        end
    end
end

% objective value
function obj = objective(x)
    obj = norm(x,1);
end
