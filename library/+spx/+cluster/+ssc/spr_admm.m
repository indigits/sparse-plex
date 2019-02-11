function [C, details] = spr_admm(Y, options)
%%% validate arguments
if nargin < 2
    options = struct;
end
%%% Import necessary support functions
import spx.opt.shrinkage;
import spx.matrix.off_diagonal_matrix;
import spx.norm.norms_l1_cw;
% whether data is affine
affine = false;
if isfield(options, 'affine')
    affine = options.affine;
end
% coefficient for computing lambda_z
alpha_z = 800;
if isfield(options, 'alpha_z')
    alpha_z = options.alpha_z;
end
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
if isfield(options, 'tolerance')
    tolerance = options.tolerance;
end
% verbosity
verbose = 0;
if isfield(options, 'verbose')
    verbose = options.verbose;
end
% ambient dimension and number of points
[M, S] = size(Y);
% The Gram matrix
G = Y' * Y;
% remove the off diagonal elements
G2 = off_diagonal_matrix(G);
% take row wise max of off diagonal inner products and min over all rows.
mu_z = min(max(G2, [], 1));
lambda_z = alpha_z / mu_z;

% copy this information in result
details.affine = affine;
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
if affine
    delta = zeros(S, 1);
end
%%% Initialization of other variables
% iteration number
k = 0;
terminate = false;
% identity matrix
I_S = speye(S);
if affine
RHO_MAT_S = rho*ones(S);
ONE_VEC_S = ones(S, 1);
end
% LHS for A update
F = lambda_z * G + rho * I_S;
if affine
F = F + RHO_MAT_S;
end
% Invert the LHS
F = inv(F);
%%% Main ADMM iterations
while ~terminate
    %%% Update A
    % A_prev = A;
    RHS = lambda_z * G + rho*C - Delta;
    if affine
        RHS = RHS + RHO_MAT_S - ONE_VEC_S*delta';
    end
    A = F * RHS;
    % Remove the diagonal elements
    A = off_diagonal_matrix(A);
    %%% update C
    J = A + Delta / rho;
    % shrinkage
    J = shrinkage(J, 1/rho);
    C = off_diagonal_matrix(J);
    %%% Update Delta
    % how close is A to C
    AC_diff = A - C; 
    Delta = Delta + rho*(AC_diff);
    if affine
        A_affine_gap = A'*ONE_VEC_S - ONE_VEC_S;
        delta = delta + rho*A_affine_gap;
    end
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
    if affine
        max_affine_gap = max(abs(A_affine_gap));
        terminate = terminate && (max_affine_gap < tolerance);
    end
    if k >= max_iterations
        terminate = true;
    end
end
details.iterations = k;

end

