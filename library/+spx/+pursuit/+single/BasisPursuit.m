classdef BasisPursuit < handle
    % Various ways to solve the under-determined problem of A * x - b
    % one or more signals can be approximated. Each signal is approximated 
    % separately, one by one


    properties
        Quiet = false
    end
    properties(SetAccess=private)
        % read-only properties

        % The over-complete signal dictionary
        A
        % The signals being approximated
        B
        % The solution vectors in representation space
        X
        % The dimension of signal space
        M
        % The dimension of representation space
        N
        % The number of signals being approximated
        S
    end

    methods
        function self = BasisPursuit(A, B)
            % Constructor
            self.A = A;
            self.B = B;
            [m, n] = size(A);
            self.M = m;
            self.N = n;
            [mb, sb] = size(B);
            assert(mb == m);
            self.S = sb;
            self.X  = zeros(self.N, self.S);
        end

        function result = solve_lasso(self, lambda)
            if (nargin < 2)
                % lambda varies between 0.01 and 0.001.
                lambda = 0.1;
            end
            n = self.N;
            A = self.A;
            B = self.B;
            for i=1:self.S
                if ~self.Quiet 
                    fprintf('.');
                end
                b = B(:, i);
                cvx_begin quiet;
                    cvx_precision high;
                    variable x(n,1);
                    minimize( norm(x,1) + lambda * norm(A * x  - b) );
                cvx_end;
                self.X(:, i) = x;
            end
            if ~self.Quiet 
                fprintf('\n');
            end
            result = self.X;
        end


        function result = solve_l1_exact(self)
            n = self.N;
            A = self.A;
            B = self.B;
            for i=1:self.S
                if ~self.Quiet 
                    fprintf('.');
                end
                b = B(:, i);
                cvx_begin quiet;
                    cvx_precision high
                    variable x(n,1);
                    minimize( norm(x,1) );
                    subject to
                        A * x  == b;
                cvx_end;
                self.X(:, i) = x;
            end
            if ~self.Quiet 
                fprintf('\n');
            end
            result = self.X;
        end


        function result = solve_l1_noise(self, noise_norm_factor)
            if (nargin < 2)
                % We assign a 40 dB SNR by default
                noise_norm_factor = 0.01;
            end
            norms = spx.commons.norm.norms_l2_cw(self.B);
            noise_norm_threshold = noise_norm_factor * mean(norms);
            n = self.N;
            A = self.A;
            B = self.B;
            for i=1:self.S
                if ~self.Quiet 
                    fprintf('.');
                end
                b = B(:, i);
                cvx_begin quiet;
                    cvx_precision high
                    variable x(n,1);
                    minimize( norm(x,1) );
                    subject to
                        norm(A * x  - b) <= noise_norm_threshold;
                cvx_end;
                self.X(:, i) = x;
                if ~self.Quiet && mod(i, 100) == 0
                    fprintf('\n');
                end
            end
            if ~self.Quiet 
                fprintf('\n');
            end
            result = self.X;
        end


    end

end


