classdef SPX_ConjugateDescent < handle
% Conjugate gradient algorithm implementation


    properties
        % Settable and gettable properties

        % Maximum number of iterations for which the algorithm can run
        MaxIterations
        % Threshold of norm (in terms of percentage)
        NormThreshold
    end


    properties(SetAccess=private)
        % Gettable properties

        % The sparse symmetric positive definite matrix operator
        A
        % The vectors to be solved
        B
        % Problem dimension
        N
        % Number of equations to be solved
        S
        % Number of iterations taken for solving the problem
        Iterations
        % Residual norms at the end
        ResidualNorms
        % The solution vectors
        X
        % Residual vectors
        Residuals
        % Indicates if the problems converged
        % This would be false only if the algorithm crossed max iterations
        Converged
    end

    methods
        % Public methods
        function self = SPX_ConjugateDescent(A, B)
            % Constructor
            if isa(A, 'SPX_Operator')
                self.A = A;
            elseif ismatrix(A)
                self.A = SPX_MatrixOperator(A); 
            else
                error('Unsupported operator.');
            end
            self.B = B;
            [self.N, self.S] = size(B);
            self.MaxIterations = self.N ;
            self.NormThreshold = 1e-6;
        end

        function result = solve(self)
            aa = self.A;
            bb = self.B;
            % Initial estimate vectors are all zeros
            xx = zeros(self.N, self.S);
            result = xx;
            self.Iterations = zeros(self.S, 1);
            self.ResidualNorms = zeros(self.S, 1);
            self.Converged = false(self.S, 1);
            % Initial residual vectors
            rr = bb  - aa * xx;
            self.Residuals  = rr;
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
                r = rr(:, s);
                % First estimate
                x = xx(:, s);
                % Target b
                b = bb(:, s);
                % First direction
                d = r;
                while i < imax && delta > limit
                    % Compute the intermediate variable
                    q = aa * d;
                    % the line search scale factor in current direction
                    alpha = delta / (d' * q);
                    % Update estimate in current direction
                    x = x + alpha * d;
                    if mod(i , 50) == 0
                        % In order to avoid propagation of floating point
                        % errors, we will recompute the value of residual
                        r = b - aa * x;
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
                self.ResidualNorms(s) = sqrt(delta);
                self.Residuals(:, s) = r;
                self.Converged(s) = delta <= limit;
            end
            % Maintain the result for reference
            self.X = result;
        end

        function result = hasConverged(self)
            % Returns if all the solutions have converged
            result = all(self.Converged);
        end

        function printResults(self)
            ns = self.S;
            nn = self.N;
            for s = 1:ns
                fprintf('Problem: %d\n', s);
                fprintf('Iterations: %d\n', self.Iterations(s));
                fprintf('Residual norm: %.2f, Converged: %d\n', ...
                    self.ResidualNorms(s), self.Converged(s));
                if nn < 10
                    % We will print the solutions too
                    fprintf('Solution vector: ');
                    fprintf('%.4f ', self.X(:, s));
                    fprintf('\n');
                    fprintf('Residual vector: ');
                    fprintf('%.4f ', self.Residuals(:, s));
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
