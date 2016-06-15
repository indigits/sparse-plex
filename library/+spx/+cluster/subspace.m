classdef subspace

methods(Static)

function result = ssc_l1_mahdi(X, options)
    if nargin > 1
    else
        % empty options
        options = struct;
    end
    cvx_solver sdpt3
    cvx_quiet(true);
    [M, S] = size(X);
    % M is ambient dimension 
    % S is number of signals
    % storage for coefficients
    Z = zeros(S, S);
    for s=1:S
        fprintf('.');
        if (mod(s, 50) == 0)
            fprintf('\n');
        end
        x = X(:, s);
        cvx_begin
        % storage for  l1 solver
        variable z(S, 1);
        minimize norm(z, 1)
        subject to
        x == X*z;
        z(s) == 0;
        cvx_end
        Z(:, s)  = z;
    end
    fprintf('\n');
    W = abs(Z) + abs(Z).';
    result = spx.cluster.spectral.simple.normalized_symmetric(W, options);
    result.Z = Z;
    result.W = W;
end



end


end
