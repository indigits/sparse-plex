function y = mex_partial_svd_compose(U, V, I, J, transpose)
    % warning('Using slow version of mex_partial_svd_compose');
    y = zeros(size(I));
    for k=1:length(I)
        % Pick the I(k)-th row of U
        % Pick the J(k)-th row of V
        if ~transpose
            y(k) = U(I(k), :) * (V(J(k), :)');
        else
            y(k) = U(:, I(k))' * (V(:, J(k)));
        end
    end
end
