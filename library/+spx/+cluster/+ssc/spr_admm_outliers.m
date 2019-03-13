function C = spr_admm_affine_outliers(Y, options)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% SSC implementation using ADMM iterations
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% validate arguments
if nargin < 2
    options = struct;
end

%%% Import necessary support functions
import spx.opt.shrinkage;
import spx.matrix.off_diagonal_matrix;
import spx.norm.norms_l1_cw;


% ambient dimension and number of points
[D, N] = size(Y);
% The Gram matrix
G = Y' Y;
% remove the off diagonal elements
G2 = off_diagonal_matrix(G);

%%% Computation of algorithm
% take row wise max of off diagonal inner products and min over all rows.
mu_z = min(max(G2, [], 1));

% computation of mu_e
% compute column wise l1-norms
y_l1_norms = norms_l1_cw(Y);
max_norms = zeros(N, 1);
for i=1:N
    y_l1_norms_copy = y_l1_norms;
    y_l1_norms_copy(i) = 0;
    max_norms = max(y_l1_norms_copy);
end

mu_e  = min(max_norms);

alpha_z = 4;
alpha_e = 4;

lambda_z = alpha_z / mu_z;
lambda_e = alpha_e / mu_e;

rho = 20;

terminate = false;
max_iterations = 10^4;
tolerance = 1e-4;

%%% Initializations of optimization variables
% coefficients
C = zeros(N, N);
% proxy for C: A = C - diag(C)
A = zeros(N, N);
% sparse errors matrix
E = zeros(D, N);
delta = zeros(N, 1);
Delta  = zeros(N, N);

%%% Initialization of other variables
% iteration number
k = 0;

I_N = eye(N);
ONE_MAT_N = ones(N);
ONE_VEC_N = ones(N, 1);

F = inv(lambda_z * G + rho * I_N + rho * ONE_MAT_N);

%%% Main ADMM iterations
while ~terminate
    %%% Update A
    A_prev = A;
    RHS = lambda_z * Y'(Y - E) + rho*(ONE_MAT_N + C) - ONE_VEC_N*delta' - Delta;
    A = F * RHS;
    %%% update C
    J = A + Delta / rho;
    % shrinkage
    J = shrinkage(J, 1/rho);
    C = off_diagonal_matrix(J);
    %%% Update E
    E_prev = E;
    E = Y - Y*A;
    % shrinkage
    E = shrinkage(E, lambda_e/lambda_z);
    %%% Update delta
    % How close are A entries to being affine entries
    A_affine_gap = A'ONE_VEC_N - ONE_VEC_N;
    delta = delta + rho*(A_affine_gap);
    %%% Update Delta
    % how close is A to C
    AC_diff = A - C; 
    Delta = Delta + rho*(AC_diff);
    % Measure the termination criteria
    max_affine_gap = max(abs(A_affine_gap));
    max_a_c_gap = max(abs(AC_diff));
    max_a_change = max(max(abs(A-A_prev)));
    max_e_change = max(max(abs(E-E_prev)));
    % next iteration
    k = k + 1;
    % termination condition
    terminate = (max_affine_gap < tolerance) ...
        && (max_a_c_gap < tolerance) && (max_a_change < tolerance)...
        &&(max_e_change < tolerance) && k >= max_iterations;
end

end