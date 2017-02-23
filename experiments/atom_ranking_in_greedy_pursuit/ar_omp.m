function result = ar_omp(Phi, K, y, matching_mode, options)
% dimensions
[n, d] = size(Phi);
% active indices
omega = [];
% residual
r = y;
% residual norm
r_norm = norm(r);
% result
z = zeros(d, 1);
atom_index_sum = 0;
matched_atoms = 0;
selected_atoms = 1:d;
if nargin == 3
    matching_mode = 4;
end
if nargin < 5
    options = struct;
end
if ~isfield(options, 'atoms_to_match')
    options.atoms_to_match = n;
end
if ~isfield(options, 'norm_factor')
    options.norm_factor = 2;
end
if ~isfield(options, 'reset_interval')
    options.reset_interval = 5;
end
if ~isfield(options, 'VERBOSE')
    options.VERBOSE = false;
end
atoms_to_match = options.atoms_to_match;
norm_factor = options.norm_factor;
DEBUG = options.VERBOSE;
reset_interval = options.reset_interval;

% array to hold inner products in the original atom order.
abs_inner_products = zeros(1, d);
for iter=1:K
    % Compute inner products with atoms arranged in the order 
    % based on their ranking [for selected atoms]
    inner_products = abs(Phi(:, selected_atoms)' * r);
    matched_atoms = matched_atoms + numel(selected_atoms);
    %inner_products(omega) = 0;
    inner_products = abs(inner_products);
    % Find the highest inner product
    [~, max_index] = max(inner_products);
    if DEBUG
        % maximum index
        fprintf('r_norm: %0.5f, num selected atoms: %d, chosen atom index: %d\n', ...
            r_norm, numel(selected_atoms), max_index);
    end
    % we need to get the original index at this point.
    original_index = selected_atoms(max_index);
    % Add this index to support
    omega = [omega, original_index];
    % store the updated inner products for the selected indices here.
    abs_inner_products(selected_atoms) = inner_products;
    % mark the inner product for the new atom added to support as 0.
    abs_inner_products(original_index) = 0;
    % track the atom index position
    atom_index_sum = atom_index_sum + max_index;
    % Solve least squares problem
    subdict = Phi(:, omega);
    tmp = linsolve(subdict, y);
    % Updated solution
    z(omega) = tmp;
    % Let us update the residual.
    r = y - subdict * tmp;
    % residual norm
    r_norm = norm(r);
    if r_norm < 1e-6
        % no point going forward. we have already recovered the signal
        break;
    end
    update_atom_order();
end
% Solution vector
result.z = z;
% Residual obtained
result.r = r;
% Solution support
result.support = omega;
% Number of iterations
result.iterations = iter;
% Average atom index
result.atom_index_average = atom_index_sum / iter;
% total number of atoms matched
result.total_matched_atoms_count = matched_atoms;
result.avg_matched_atoms_count = matched_atoms / iter;

function update_atom_order()
    [sorted_inner_products, selected_atoms] = sort(abs_inner_products, 'descend');
    switch matching_mode
        case 1
            % select all atoms in original order
            selected_atoms = 1:d;
        case 2
            % select all atoms in rank order
            % there is nothing more to do.
        case 3
            % select a percentage of atoms in rank order
           selected_atoms  = selected_atoms(1:atoms_to_match);
        case 4
            % adaptive atoms
            if 0
                fprintf('%0.2f ', sorted_inner_products);
                fprintf('\n');
            end
            if mod(iter, reset_interval) == 0
            else
                % in odd iterations we restrict to a subset of atoms.
                start = sorted_inner_products(1);
                index = find(sorted_inner_products < start/ norm_factor, 1);
                if isempty(index)
                    index = atoms_to_match;
                end
                selected_atoms = selected_atoms(1:index);
            end

        otherwise
            error('Not supported.');
    end
end

end
