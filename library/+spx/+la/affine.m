classdef affine
% Methods related to affine subspaces

methods(Static)

    function X = homogenize(X, value)
        if nargin < 2
            value = 1
        end
        % number of columns
        n = size(X, 2);
        % add one more row
        X(end+1, :) = value * ones(1, n);
    end

end

end
