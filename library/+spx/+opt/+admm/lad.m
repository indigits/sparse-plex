%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main problem is minimize \| A x - b \|_1
% We introduce z = A x - b
% Equivalent problem
% Minimize \|z \|_1 subject to Ax - z = b
% ADMM terms
% minimize f(x) + g(z) subject to A x + B z = c
% f(x) : 0
% g(z) : \| z \|_1
% A : A
% B : -1
% c : b
% Primal residual r = A x  + B z - c :  A x - z - b
% Dual residual s = rho A^T B (z_new - z_old) = rho A^T (z_old - z_new)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x, history] = lad(A, b, options)
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
        z = zeros(M, 1);
    end
    % scaled Lagrangian variable
    if isfield(options, 'u')
        u = options.u;
    else
        u = zeros(M, 1);
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
    R = chol(A' * A);
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
        % update x
        x = R \ (R' \ (A'*(b + z - u)));
        % Ax
        Ax = A*x;
        % relaxation
        if alpha ~= 1
            Ax_hat = alpha*Ax + (1-alpha)*(z + b);
        else
            Ax_hat = Ax;
        end
        % update z
        z = shrinkage(Ax_hat - b + u, 1/rho);
        % update u
        u = u + (Ax_hat - z  - b);
        % primal residual
        r = Ax - b - z;
        r_norm = norm(r);
        % dual residual
        s = rho * A' * (z_old - z);
        s_norm = norm(s);
        % upper bound on primal residual
        eps_primal = sqrt(M) * eps_abs + eps_rel * max([norm(Ax), norm(z), norm(b)]);
        eps_dual = sqrt(N) * eps_abs + eps_rel * norm(rho*A'*u);
        if verbose
            % value of objective function
            objective_value = objective(z);
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
function obj = objective(z)
    obj = norm(z,1);
end
