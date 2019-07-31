classdef sparse
% Helper methods for working with sparse matrices

methods(Static)

function A = join_data_indices(data, omega, n1, n2)
    % Constructs a sparse matrix from the data and indices in 
    m = length(omega);
    [i, j] = ind2sub([n1,n2], omega);
    A = sparse(i,j,data,n1,n2,m);
end

function [data, indices, m, n] = split_data_indices(A)
    if ~issparse(A)
        error('A should be a sparse matrix.');
    end
    [m, n] = size(A);
    indices = find(A);
    data = A(indices);
end 

end % methods
end % classdef

