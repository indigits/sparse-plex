classdef la

methods(Static)

function no = nonorthogonality(U)
    % Computes the deviation from orthogonality of a basis
    [m, k] = size(U);
    gap = U' * U - eye(k);
    no = norm(gap);
end


end % methods

end % classdef
