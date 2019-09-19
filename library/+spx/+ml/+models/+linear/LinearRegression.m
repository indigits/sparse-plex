classdef LinearRegression < handle

properties(SetAccess=private)
    W
end % properties

methods

    function self = LinearRegression()
    end

    function fit(self, X, t, lambda)
        if nargin < 4
            lambda = 0;
        end
        [n, d] = size(X);
        % n is number of data points
        % d is the dimension of input data
        % compute feature wise mean eq 3.20
        x_mean = mean(X);
        % compute mean of target eq 3.20
        t_mean = mean(t);

        % Subtract feature means from features
        X = bsxfun(@minus, X, x_mean);
        % Subtract target mean from target values
        t = bsxfun(@minus, t, t_mean);

        % Check if the first column is all 0s
        first = X(:, 1);
        if all(first == 0)
            % This is a bias column
            % Remove it
            X = X(:, 2:end);
            x_mean = x_mean(2:end);
            d = d - 1;
        end

        % Compute covariance matrix d x d
        S = X' * X;
        % Identify the diagonal entries
        idx = (1:d)';
        dg = sub2ind([d,d],idx,idx);
        % Add the regularization term in diagonal entries
        S(dg) = S(dg)+lambda;
        % Compute the Cholesky decomposition of S
        % U = chol(S);
        % Correlate data with target
        y = (t' * X)';
        % Solve the normal equation
        opts.SYM = true;
        % 3.15 with mean removal
        W = linsolve(S, y, opts);
        W0 = t_mean - dot(W, x_mean);
        self.W = [W0; W];
    end

    function y = predict(self, X)
        y = X * self.W;
    end

end % methods

end % classdef