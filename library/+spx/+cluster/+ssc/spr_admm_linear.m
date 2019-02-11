function [C, details] = spr_admm_affine_outliers(Y, options)
%%% validate arguments
if nargin < 2
    options = struct;
end
%%% Import necessary support functions
import spx.opt.shrinkage;
import spx.matrix.off_diagonal_matrix;
import spx.norm.norms_l1_cw;

% ambient dimension and number of points
[M, S] = size(Y);
% The Gram matrix
G = Y' * Y;
% remove the off diagonal elements
G2 = off_diagonal_matrix(G);
% coefficient for computing lambda_z
alpha_z = 800;
if isfield(options, 'alpha_z')
    alpha_z = options.alpha_z;
end
% take row wise max of off diagonal inner products and min over all rows.
mu_z = min(max(G2, [], 1));
lambda_z = alpha_z / mu_z;
% weight for the quadratic penalty term
rho = 800;
if isfield(options, 'rho')
    rho = options.rho;
end
% Maximum number of ADMM iterations
max_iterations = 1000;
if isfield(options, 'max_iterations')
    max_iterations = options.max_iterations;
end
tolerance = 2e-4;
% verbosity
verbose = 0;
if isfield(options, 'verbose')
    verbose = options.verbose;
end

% copy this information in result
details.mu_z = mu_z;
details.alpha_z = alpha_z;
details.lambda_z = lambda_z;
details.rho = rho;
details.max_iterations = max_iterations;
details.tolerance = tolerance;

%%% Initializations of optimization variables
% coefficients
C = zeros(S, S);
% proxy for C: A = C - diag(C)
A = zeros(S, S);
% Lagrangian multiplier for the equality constraint
Delta  = zeros(S, S);
%%% Initialization of other variables
% iteration number
k = 0;
terminate = false;
F = inv(lambda_z * G + rho * eye(S));
%%% Main ADMM iterations
while ~terminate
    %%% Update A
    % A_prev = A;
    RHS = lambda_z * G + rho*C - Delta;
    A = F * RHS;
    % Remove the diagonal elements
    % A = off_diagonal_matrix(A);
    %%% update C
    J = A + Delta / rho;
    % shrinkage
    J = shrinkage(J, 1/rho);
    C = off_diagonal_matrix(J);
    %%% Update Delta
    % how close is A to C
    AC_diff = A - C; 
    Delta = Delta + rho*(AC_diff);
    % Measure the termination criteria
    max_a_c_gap = max(max(abs(AC_diff)));
    % max_a_change = max(max(abs(A-A_prev)));
    % next iteration
    k = k + 1;
    if verbose > 0
        fprintf('k: %d, gap: %e\n', k, max_a_c_gap);
    end
    %fprintf('change: %e', max_a_change);
    % termination condition
    terminate = (max_a_c_gap < tolerance);
    if k >= max_iterations
        terminate = true;
    end
end
details.iterations = k;

end

