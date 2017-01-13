function result = omp(Phi, y, K)
% dimensions
[n, d] = size(Phi);
% active indices
omega = [];
% residual
r = y;
% result
z = zeros(d, 1);
atom_index_sum = 0;
for iter=1:K
    % Compute inner products
    inner_products = abs(Phi' * r);
    inner_products(omega) = 0;
    inner_products = abs(inner_products);
    % Find the highest inner product
    [~, index] = max(inner_products);
    % Add this index to support
    omega = [omega, index];
    % track the atom index position
    atom_index_sum = atom_index_sum + index;
    % Solve least squares problem
    subdict = Phi(:, omega);
    tmp = linsolve(subdict, y);
    % Updated solution
    z(omega) = tmp;
    % Let us update the residual.
    r = y - subdict * tmp;
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
end

end
