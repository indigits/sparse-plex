classdef L1_ADMM_YZ < handle
% Solver for various L1 minimization problems
% based on the 2011 paper by 
% Junfeng Yang and Yin Zhang

properties
    % weight for the quadratic penalty term
    rho
     % verbosity
    verbose    
    % Maximum number of ADMM iterations
    max_iterations
    % relative tolerance
    tolerance
    % additional scaling factor for x updates
    gamma
end % properties

properties(SetAccess=private)
    % The sensing operator
    A
    % The signals being recovered
    B
    % The solution representation vectors
    X 
    % The dimension of signal space
    M
    % The dimension of representation space
    N
    % Details of execution (intermediate values)
    details
end % properties

% Following properties are meant for implementation only
properties(Access=private)
    X0
    Y0
    Z0
end


methods

function self = L1_ADMM_YZ(A, options)
    if nargin < 1
        error('A must be specified.');
    end
    if isa(A, 'spx.dict.Operator')
        self.A = A;
    elseif ismatrix(A)
        self.A = spx.dict.MatrixOperator(A); 
    else
        error('Unsupported operator.');
    end
    [self.M, self.N] = size(self.A);
    if nargin < 2
        options = struct;
    end
    self.init_options();
    self.process_options(options);
end % function

function [X] = solve_bp(self, B, options)
    % Solves the problem min ||x||_1 s.t. Ax = b
    if nargin < 2
        error('B must be specified.');
    end
    if nargin < 3
        options = struct;
    end
    self.process_options(options);
    num_problems = size(B, 2);
    if self.verbose > 0
        fprintf('Solving l1 minimization problem: BP.\n');
    end
    self.init_details(num_problems);
    max_iterations = self.max_iterations;
    A  = self.A;
    X = zeros(self.N, num_problems);
    % import relevant functions from other modules
    import spx.opt.projections.proj_linf_ball;
    % iterate over problems
    for prob=1:num_problems
        tstart = tic;
        b = B(:, prob);
        b_max = norm(b, 'inf');
        terminated = false;
        % Check for zero solution condition
        if b_max < self.tolerance
            % There is no need to proceed further
            % zero solution is best solution
            self.details.terminated(prob) = true;
            self.details.iterations(prob) = 0;
            self.details.elapsed_times(prob) = toc(tstart);
            X(:, prob) = zeros(self.N, 1);
            continue;
        end
        if self.rho > 0
            % we will use user defined quadratic term weight
            rho = self.rho;
        else
            rho = mean(abs(b));
        end
        gamma = self.gamma;
        % scale the problem
        b = b / b_max;
        % Initialize solution
        x = A.adjoint(b);
        z = zeros(self.N, 1);
        y = zeros(self.M, 1);
        % compute current primary residual
        r_primal = A.apply(x) - b;
        for iter=1:max_iterations
            % check if we need to iterate further
            if terminated; break; end;
            % update z
            z_prev = z;
            z = proj_linf_ball(A.adjoint(y) + (x / rho));
            % update y
            y_prev = y;
            Az = A.apply(z);
            y = (Az - r_primal / rho);
            % update dual residual
            Aty = A.adjoint(y);
            r_dual =  Aty - z;
            % update x
            x_prev = x;
            x = x + (gamma * rho)*r_dual; 
            % update primary residual
            r_primal = A.apply(x) - b;
            % primal objective
            primal_obj = sum(abs(x));
            % dual objective
            dual_obj = real(b' * y);
            terminated = self.check_termination(x, x_prev, y, z, ...
                r_primal, r_dual, primal_obj, dual_obj, iter, prob);
        end % iteration loop
        self.details.terminated(prob) = terminated;
        self.details.iterations(prob) = iter-1;
        self.details.elapsed_times(prob) = toc(tstart);
        % put the final solution back in result
        X(:, prob) = x * b_max;
    end % problem loop
end % function

function [X] = solve_bpic(self, B, delta, options)
    % Solves the problem min ||x||_1 s.t. ||Ax - b||_2 <= delta
    if nargin < 4
        options = struct;
    end
    self.process_options(options);
end % function

function [X] = solve_bpdn_l2(self, B, mu, options)
    % Solves the problem min ||x||_1  + ||Ax - b||_2 / (2 mu)
    if nargin < 2
        error('B must be specified.');
    end
    if nargin < 3
        error('mu must be specified.');
    end
    if nargin < 4
        options = struct;
    end
    self.process_options(options);
    num_problems = size(B, 2);
    if self.verbose > 0
        fprintf('Solving l1-l2 unconstrained minimization problem: BPDN l2.\n');
    end

    self.init_details(num_problems);
    max_iterations = self.max_iterations;
    A  = self.A;
    X = zeros(self.N, num_problems);
    % import relevant functions from other modules
    import spx.opt.projections.proj_linf_ball;
    % iterate over problems
    for prob=1:num_problems
        tstart = tic;
        b = B(:, prob);
        %  Compute A' b
        Atb = A.adjoint(b);
        terminated = false;
        % Check for zero solution condition
        if norm(Atb, 'inf') <= mu
            % There is no need to proceed further
            % zero solution is best solution
            self.details.terminated(prob) = true;
            self.details.iterations(prob) = 0;
            self.details.elapsed_times(prob) = toc(tstart);
            X(:, prob) = zeros(self.N, 1);
            continue;
        end
        if self.rho > 0
            % we will use user defined quadratic term weight
            rho = self.rho;
        else
            rho = mean(abs(b));
        end
        gamma = self.gamma;
        % scale the problem
        b_max = norm(b, 'inf');
        b = b / b_max;
        mu = mu / b_max;
        % Initialize solution
        x = A.adjoint(b);
        z = zeros(self.N, 1);
        y = zeros(self.M, 1);
        % compute current primary residual
        r_primal = A.apply(x) - b;
        for iter=1:max_iterations
            % check if we need to iterate further
            if terminated; break; end;
            % update z
            z_prev = z;
            z = proj_linf_ball(A.adjoint(y) + (x / rho));
            % update y
            y_prev = y;
            Az = A.apply(z);
            y = (rho/(mu +  rho)) * (Az - r_primal / rho);
            % update dual residual
            Aty = A.adjoint(y);
            r_dual =  Aty - z;
            % update x
            x_prev = x;
            x = x + (gamma * rho)*r_dual; 
            % update primary residual
            r_primal = A.apply(x) - b;
            % primal objective
            primal_obj = sum(abs(x)) + (1/(2*mu))*(r_primal'*r_primal);
            % dual objective
            dual_obj = real(b' * y) - (mu / 2) * (y' * y);
            terminated = self.check_termination(x, x_prev, y, z, ...
                r_primal, r_dual, primal_obj, dual_obj, iter, prob);
        end % iteration loop
        self.details.terminated(prob) = terminated;
        self.details.iterations(prob) = iter-1;
        self.details.elapsed_times(prob) = toc(tstart);
        % put the final solution back in result
        X(:, prob) = x * b_max;
    end % problem loop
end % function

function [X] = solve_bpdn_l1(self, B, nu, options)
    % Solves the problem min ||x||_1  + ||Ax - b||_1 / (nu)
end % function

end % methods

methods(Access=private)

function init_options(self)
    self.rho = 0;
    self.verbose = 0;
    self.max_iterations = 100;
    % self.eps_abs = 1e-4;
    self.tolerance = 1e-2;
    self.gamma = 1;
end % function

function process_options(self, options)
    % weight for the quadratic penalty term
    if isfield(options, 'rho')
        self.rho = options.rho;
    end
    % verbosity
    if isfield(options, 'verbose')
        self.verbose = options.verbose;
    end
    % Maximum number of ADMM iterations
    if isfield(options, 'max_iterations')
        self.max_iterations = options.max_iterations;
    end
    % gamma for primal variable update
    if isfield(options, 'gamma')
        self.gamma = options.gamma;
    end
    % relative tolerance
    if isfield(options, 'tolerance')
        self.tolerance = options.tolerance;
    end
end % function

function init_xyz(self, num_problems, options)
    if isfield(options, 'X0')
        self.X0 = X0;
    else
        self.X0 = zeros(self.N, num_problems);
    end
    if isfield(options, 'Y0')
        self.Y0 = Y0;
    else
        self.Y0 = zeros(self.N, num_problems);
    end
    if isfield(options, 'Z0')
        self.Z0 = Z0;
    else
        self.Z0 = zeros(self.N, num_problems);
    end
end % function

function init_details(self, num_problems)
    max_iterations = self.max_iterations;
    self.details.iterations = zeros(1, num_problems);
    self.details.terminated = zeros(1, num_problems);
    self.details.elapsed_times = zeros(1, num_problems);
    self.details.x_norms = zeros(max_iterations, num_problems);
    self.details.z_norms = zeros(max_iterations, num_problems);
    self.details.r_primal_norms = zeros(max_iterations, num_problems);
    self.details.r_dual_norms = zeros(max_iterations, num_problems);
    self.details.primal_objectives = zeros(max_iterations, num_problems);
    self.details.dual_objectives = zeros(max_iterations, num_problems);
end % function

function terminate = check_termination(self, x, x_prev, y, z, ...
    r_primal, r_dual, primal_obj, dual_obj, iter, prob)
    terminate = false;
    % norm of primal variable x
    x_norm = norm(x);
    % norm of change in x
    x_diff_norm = norm(x - x_prev);
    % relative change in x
    x_rel_change = x_diff_norm / x_norm;
    % norm of dual variable z
    z_norm = norm(z);
    % primal residual norm
    r_primal_norm  = norm(r_primal);
    % dual residual norm
    r_dual_norm = norm(r_dual);
    % relative change in dual norm
    r_dual_rel_change = r_dual_norm / z_norm;
    % gap in objectives
    gap = abs(primal_obj  - dual_obj);
    relative_gap = gap / abs(primal_obj);

    self.details.x_norms(iter, prob) = x_norm;
    self.details.z_norms(iter, prob) = z_norm;
    self.details.r_primal_norms(iter, prob) = r_primal_norm;
    self.details.r_dual_norms(iter, prob) = r_dual_norm;
    self.details.primal_objectives(iter, prob) = primal_obj;
    self.details.dual_objectives(iter, prob) = dual_obj;


    if self.verbose > 1
        fprintf('Objective primal: %.4f, dual: %.4f\n', primal_obj, dual_obj);
    end

    tolerance = self.tolerance;
    if x_rel_change < tolerance
        terminate = true;
    end
    if x_rel_change >= tolerance*1.1
        % we will continue for a while
        return;
    end
    if relative_gap < tolerance
        terminate = true;
    end
    if r_dual_rel_change < tolerance
        terminate = true;
    end
end % function

end % methods

end % class


