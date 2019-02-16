function [A, B, details] = lrsd_yy(C, options)
% Performs decomposition of C = A + B
% where A is a sparse matrix and B is a low rank matrix
% 
% solves the problem min \gamma \| A \|_1 + \| B \|_* 
% subject to C = A + B.
% 
% See the paper
% Sparse and low rank matrix decomposition via 
% alternating direction methods by
% Xiaoming Yuan and Junfeng Yang for details.

if nargin < 2
    options = struct;
end
%%% Import necessary support functions
import spx.opt.shrinkage;
import spx.opt.sv_shrinkage;


[m, n] = size(C);

% initialize algorithm parameters
% Maximum number of ADMM iterations
max_iterations = 100;
% tolerance for successful recovery
tolerance = 1e-6;
% verbosity
verbose = 0;
% weight for the quadratic penalty term
rho = .25/mean(abs(C(:)));
% The balancing parameter between sparse and low rank parts
gamma = 0.1;


% Initialize the sparse and low rank matrices
% sparse matrix
A = zeros(m, n);
% low rank matrix
B = zeros(m, n);
% The Lagrangian multipliers
Lambda = zeros(m, n);


% Override values if provided by caller
if isfield(options, 'max_iterations')
    max_iterations = options.max_iterations;
end
if isfield(options, 'tolerance')
    tolerance = options.tolerance;
end
if isfield(options, 'verbose')
    verbose = options.verbose;
end
if isfield(options, 'rho')
    rho = options.rho;
end
if isfield(options, 'gamma')
    gamma = options.gamma;
end
% initial values of optimization variables
if isfield(options, 'A0')
    A = options.A0;
end
if isfield(options, 'B0')
    B = options.B0;
end
if isfield(options, 'Lambda0')
    Lambda = options.Lambda0;
end

shrinkage_amount = gamma/rho;

for iter=1:max_iterations
    % norm of A,B before update
    norm_ab = norm([A, B], 'fro');

    %%% update A
    % temp variables X and Y are useful later
    X = Lambda / rho + C;
    Y = X - B;
    % keep the previous value of A
    dA = A;
    A = shrinkage(Y, shrinkage_amount);
    % Compute the relative change
    dA  = A - dA;

    %%% update B
    Y = X  - A;
    % keep the previous value
    dB  = B;
    B = sv_shrinkage(Y, 1/rho);
    % compute the relative change
    dB = B - dB;

    %%% check for termination
    % norm of change
    norm_change = norm([dA, dB ], 'fro') ;
    % relative change value
    relative_change = norm_change/ (1 + norm_ab);
    if relative_change < tolerance
        % the updates have converged
        break;
    end

    %%% update Lambda
    Lambda = Lambda - rho * (A + B - C);

end
% number of iterations
details.iterations = iter;
end


