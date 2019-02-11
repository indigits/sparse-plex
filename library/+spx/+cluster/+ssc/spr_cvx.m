function [C, details] = spr_cvx(Y, options)
%%% validate arguments
if nargin < 2
    options = struct;
end
% verbosity
verbose = 0;
if isfield(options, 'verbose')
    verbose = options.verbose;
end
% noise factor
noise_factor = 0.01;
if isfield(options, 'noise_factor')
    noise_factor = options.noise_factor;
end
% affine 
affine = false;
if isfield(options, 'affine')
    affine = options.affine;
end
% size of data-set
[M, S] = size(Y);
% iterate over signals
all_cols = 1:S;
% The representation matrix
C = zeros(S);
details = struct;
for s=all_cols
    if verbose > 0 
        fprintf('.');
        if mod(s, 50) == 0
            fprintf('\n');
        end
    end
    % s-th data vector
    y = Y(:, s);
    % the signal dictionary to be used for reconstruction
    cols = all_cols ~= s; % S - 1 columns
    % dimensions are D x (S - 1)
    A = Y(:, cols);
    % threshold for the noise norm
    noise_norm_threshold = noise_factor * norm(y);
    if affine
        cvx_begin quiet;
            cvx_precision high;
            variable rep(S-1,1);
            minimize( norm(rep,1) );
            subject to
                norm(A * rep  - y) <= noise_norm_threshold;
                sum(rep) == 1;
        cvx_end;
    else
        cvx_begin quiet;
            cvx_precision high;
            variable rep(S-1,1);
            minimize( norm(rep,1) );
            subject to
                norm(A * rep  - y) <= noise_norm_threshold;
        cvx_end;
    end
    % Prepare the l1 solver
    % solver = spx.pursuit.single.BasisPursuit(A, x);
    % solver.Quiet = true;
    % lambda = 2.5;
    % Run the solver to obtain sparse representation
    % rep = solver.solve_l1_noise();
    % The obtained representation is in R^{S - 1} dimensions

    % Put back the representation
    C(cols, s) = rep;
end
if verbose > 0 
    fprintf('\n');
end


end
