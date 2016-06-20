classdef affine
% Methods related to affine subspaces

methods(Static)

    function X = homogenize(X)
        % number of columns
        n = size(X, 2);
        % add one more row
        X(end+1, :) = ones(1, n);
    end

end

end
