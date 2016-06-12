classdef SPX_CGLeastSquare < handle
% Conjugate gradient algorithm for least squares  or
% normal equations implementation
% We are solving the problem minimize \| A x - b \|_2^2.
% A is of size M x N. 
% M > N.
% A^T A is of size N x N.
% b is of size M x 1.
% x is of size N x 1.
% A is full rank. Rank(A) = N.
% We assume that A is well conditioned.
% We can simultaneously solve S problems.


    properties
        % Settable and gettable properties

        % Maximum number of iterations for which the algorithm can run
        MaxIterations
        % Threshold of norm (in terms of percentage)
        NormThreshold
    end


    properties(SetAccess=private)
        % Gettable properties

        % The full rank tall matrix operator M x N
        A
        % The vectors to be solved M x S
        B
        % Measurements dimension
        M
        % Problem dimension
        N
        % Number of equations to be solved
        S
        % Number of iterations taken for solving the problem
        Iterations
        % The solution vectors
        X
        % Residual vectors in the CG algorithm
        CGResiduals
        % Residual norms at the end of the corresponding CG problem.
        CGResidualNorms
        % Residual vectors of the LS problem
        LSResiduals
        % Norms of the LS residuals at the end
        LSResidualNorms
        % Indicates if the problems converged
        % This would be false only if the algorithm crossed max iterations
        Converged
    end

    methods
        % Public methods
        function self = SPX_CGLeastSquare(A, B)
            % Constructor
            if isa(A, 'SPX_Operator')
                self.A = A;
            elseif ismatrix(A)
                self.A = SPX_MatrixOperator(A); 
            else
                error('Unsupported operator.');
            end
            [self.M, self.N] = size(A);
            if self.M < self.N
                error('Only over-determined systems are supported')
            end
            % Ideally we should check the rank too.
            % But that would be too time consuming.
            [bm, self.S] = size(B);
            if bm ~= self.M
                error('Dimensions mismatch.');
            end
            self.B = B;
            self.MaxIterations = self.N ;
            self.NormThreshold = 1e-6;
        end

        function result = solve(self)
            aa = self.A; % M x N
            % We compute A' B in advance.
            atbb = self.A.apply_ctranspose(self.B); % N x S
            % Initial estimate vectors are all zeros
            xx = zeros(self.N, self.S); % N x S
            result = xx;
            self.Iterations = zeros(self.S, 1);
            self.CGResidualNorms = zeros(self.S, 1);
            self.Converged = false(self.S, 1);
            % Initial residual vectors
            rr = atbb  - aa.apply_ctranspose(aa.apply(xx)); % N x S
            self.CGResiduals  = rr;
            % Norm squared of initial residual vectors
            deltas = SPX_Norm.inner_product_cw(rr, rr);
            % The factor with which the norm needs to be reduced
            epsilon = self.NormThreshold;
            % Target limits on norm squared of residuals
            limits = epsilon^2 * deltas;
            % Maximum number of iterations for which the algorithm 
            % is allowed to run
            imax = self.MaxIterations;
            % Number of problems being solved
            ns = self.S;
            for s=1:ns
                % Initialize iteration counter
                i = 0;
                % The quantities for this problem
                limit = limits(s);
                delta = deltas(s);
                % First residual
                r = rr(:, s); % N x 1.
                % First estimate
                x = xx(:, s); % N x 1.
                % Target b
                atb = atbb(:, s); % N x 1.
                % First direction
                d = r;
                while i < imax && delta > limit
                    % Compute the intermediate variable
                    p = aa.apply(d); % M x 1
                    q = aa.apply_ctranspose(p); % N x 1
                    % the line search scale factor in current direction
                    % Note that d' * q = p' * p.
                    alpha = delta / (p' * p);
                    % Update estimate in current direction
                    x = x + alpha * d;
                    if mod(i , 50) == 0
                        % In order to avoid propagation of floating point
                        % errors, we will recompute the value of residual
                        r = atb - aa.apply_ctranspose(aa.apply(x));
                    else
                        % Otherwise we use a shortcut
                        r = r  - alpha * q;
                    end
                    % hold the current residual norm squared
                    delta_old = delta;
                    % Update residual norm squared
                    delta = r' * r;
                    % Compute the ratio
                    beta = delta / delta_old;
                    % choose the new direction
                    d = r + beta * d;
                    % Increase iteration counter
                    i = i + 1;
                end
                % The problem has been solved
                result(:, s) = x;
                % Number of iterations taken to solve this problem
                self.Iterations(s) = i;
                self.CGResidualNorms(s) = sqrt(delta);
                self.CGResiduals(:, s) = r;
                self.Converged(s) = delta <= limit;
            end
            % Maintain the result for reference
            self.X = result;
            % Compute the corresponding LS residuals
            self.LSResiduals = self.B - aa.apply(self.X);
            self.LSResidualNorms = SPX_Norm.norms_l2_cw(self.LSResiduals);
        end

        function result = hasConverged(self)
            % Returns if all the solutions have converged
            result = all(self.Converged);
        end

        function printResults(self)
            ns = self.S;
            nn = self.N;
            mm = self.N;
            for s = 1:ns
                fprintf('Problem: %d\n', s);
                fprintf('Iterations: %d\n', self.Iterations(s));
                fprintf('CG Residual norm: %.2f, LS Residual norm: %.2f, Converged: %d\n', ...
                    self.CGResidualNorms(s), self.LSResidualNorms(s), self.Converged(s));
                if nn < 10
                    % We will print the solutions too
                    fprintf('Solution vector: ');
                    fprintf('%.4f ', self.X(:, s));
                    fprintf('\n');
                    fprintf('CG Residual vector: ');
                    fprintf('%.4f ', self.CGResiduals(:, s));
                    fprintf('\n');
                end
                if mm < 10
                    fprintf('LS Residual vector: ');
                    fprintf('%.4f ', self.LSResiduals(:, s));
                    fprintf('\n');
                end
            end
        end
    end


    methods(Access=private)
        % Private methods

    end



    methods(Static)
        % Public static methods


    end


end
