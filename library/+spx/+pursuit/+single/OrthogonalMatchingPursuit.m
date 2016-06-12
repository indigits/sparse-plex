classdef OrthogonalMatchingPursuit < handle
    %CSOMPAPPROX Implements OMP algorithm for sparse approximation
    
    properties
        % Boolean flag indicates if approximations have to be saved at each
        % iteration.
        SaveAllApproximations = false
        % Maximum residual norm
        MaxResNorm = 1e-4
        % Indicates if we should stop on exceeding residual norm
        StopOnResidualNorm = true
        % Indicates if we should stop when residual norm stops improving
        StopOnResNormStable = true
        % Maximum number of iterations for approximation
        MaxIters
        Verbose = false
        % Minimum Sparsity
        MinK = 4
        % Ignored atom (which won't be considered in identification step)
        IgnoredAtom = -1
    end
    
    properties(SetAccess=private)
        % The dictionary
        Dict
        % Ambient signal dimensions
        N
        % Number of atoms in dictionary
        D
        % Sparsity level of representations (may be negative)
        K
        % Result of a solver
        result
    end
    
    methods
        function self  = OrthogonalMatchingPursuit(Dict, K)
            % We assume that all the columns in dictionary are normalized.
            if isa(Dict, 'spx.dict.Operator')
                self.Dict = Dict;
            elseif ismatrix(Dict)
                self.Dict = spx.dict.MatrixOperator(Dict); 
            else
                error('Unsupported operator.');
            end
            [self.N, self.D] = size(Dict);
            if ~exist('K', 'var')
                % No sparsity level has been pre-specified.
                K = -1;
            end
            self.K = K;
            % Maximum number of iterations
            maxIter = self.N;
            if K > 0
                % We have to consider pre-specified sparsity level
                maxIter = K;
            end
            self.MaxIters = maxIter;
            if K > 0 && self.MinK >= K
                self.MinK = 0;
            end
        end
        
        function result  = solve(self,y)
            % Initialization
            % Solves approximation problem using OMP
            d = self.D;
            n = self.N;
            r = y;
            dict = self.Dict;
            % Active indices 
            omega = [];
            % Estimate
            z = zeros(d, 1);
            if self.SaveAllApproximations
                ZZ = zeros(d, n);
            end
            if self.StopOnResNormStable
                oldResNorm = norm(r);
            end
            maxIter = self.MaxIters;
            ignored_atom = self.IgnoredAtom;
            for iter=1:maxIter
                % Compute inner products
                innerProducts = apply_ctranspose(dict, r);
                % Mark the inner products of already selected columns as 0.
                innerProducts(omega) = 0;
                if ignored_atom > 0
                    % forcefully ignore this atom
                    innerProducts(ignored_atom) = 0;
                end 
                innerProducts = abs(innerProducts);
                % Find the highest inner product
                [~, index] = max(innerProducts);
                % Add this index to support
                omega = [omega, index];
                % Solve least squares problem
                subdict = columns(dict, omega);
                tmp = linsolve(subdict, y);
                % Updated solution
                z(omega) = tmp;
                if self.SaveAllApproximations
                    % We need to keep track of all approximations
                    ZZ(omega, iter) = tmp;
                end
                % Let us update the residual.
                r = y - subdict * tmp;
                if self.StopOnResidualNorm || self.StopOnResNormStable
                    resNorm = norm(r);
                    if resNorm < self.MaxResNorm
                        break;
                    end
                    if self.StopOnResNormStable
                        change = abs(oldResNorm  - resNorm);
                        if change/oldResNorm < .01
                            % No improvement
                            break;
                        end
                    end
                end
            end
            % Solution vector
            result.z = z;
            % Residual obtained
            result.r = r;
            % Number of iterations
            result.iterations = iter;
            % Solution support
            result.support = omega;
            % Iterative solutions
            if self.SaveAllApproximations
                % Remove extra 0s
                result.Z = ZZ(:, 1:iter);
            end
            self.result = result;
        end
        


        function result  = solve_qr(self,y)
            % Uses QR factorization to implement the OMP 

            % Initialization
            % Solves approximation problem using OMP
            d = self.D;
            n = self.N;
            r = y;
            min_k  = self.MinK;
            dict = self.Dict;
            % Active indices 
            omega = [];
            if self.SaveAllApproximations
                ZZ = zeros(d, n);
            end
            if self.StopOnResNormStable
                oldResNorm = norm(r);
            end
            maxIter = self.MaxIters;
            % Create space for storing the Q R factors
            Q = zeros(n, maxIter);
            R = zeros(maxIter);
            % zr stores projections of y along the directions
            % in Q. 
            % Since vectors in Q are orthonormal, 
            % hence computing projections is as easy as 
            % taking inner product.
            % This also simplifies the process of updating
            % the residual as the residual is orthogonal 
            % to the vectors selected in Q so far.
            zr = [];

            ignored_atom = self.IgnoredAtom;

            for iter=1:maxIter
                % Compute inner products
                innerProducts = apply_ctranspose(dict, r);
                % Mark the inner products of already selected columns as 0.
                innerProducts(omega) = 0;
                innerProducts = abs(innerProducts);
                if ignored_atom > 0
                    % forcefully ignore this atom
                    innerProducts(ignored_atom) = 0;
                end 
                % Find the highest inner product
                [~, index] = max(innerProducts);
                % Add this index to support
                omega = [omega, index];
                % Pick the new atom
                new_atom = dict.column(index);
                % Orthogonalize the new atom
                %Compute projections to previously selected vectors in Q
                projections = Q(:, 1:iter-1)'* new_atom;
                % Remove the projection
                new_q = new_atom - Q(:, 1:iter-1) * projections;
                % Normalize
                norm_q = norm(new_q);
                new_q = new_q / norm_q;
                % Place it 
                Q(:, iter) = new_q;
                % Update R
                R(1:iter-1, iter) = projections;
                R(iter, iter) = norm_q;
                % Compute the projection of y on new q.
                zr(iter) = new_q' * y;
                % Let us update the residual.
                r = r - zr(iter) * new_q;
                if self.StopOnResidualNorm || self.StopOnResNormStable
                    resNorm = norm(r);
                    if resNorm < self.MaxResNorm && iter > min_k
                        break;
                    end
                    if self.StopOnResNormStable
                        change = abs(oldResNorm  - resNorm);
                        if change/oldResNorm < .01  && iter > min_k
                            % No improvement
                            break;
                        end
                    end
                end
            end
            % Estimate
            z = zeros(d, 1);
            % We need to use back-substitution  with R to get z from zr.
            opts.UT = true;
            tmp = linsolve(R(1:iter,1:iter), zr(1:iter)', opts);
            z(omega)= tmp;
            % Solution vector
            result.z = z;
            % Residual obtained
            result.r = r;
            % residual norm
            result.rnorm = resNorm;
            % Number of iterations
            result.iterations = iter;
            % Solution support
            result.support = omega;
            % Iterative solutions
            if self.SaveAllApproximations
                % Remove extra 0s
                result.Z = ZZ(:, 1:iter);
            end
            self.result = result;
        end
        



        function result  = solve_all(self,Y)
            % Initialization
            % Solves approximation problem using OMP
            d = self.D;
            % Residuals at each stage
            R = Y;
            % Number of signals
            s = size(Y,2);
            dict = self.Dict;
            % Active indices 
            omegas = zeros(d, s);
            % Estimate
            Z = zeros(d, s);
            if self.StopOnResNormStable
                oldResNorm = columnWiseNorm(R);
            end
            maxIter = self.MaxIters;
            for iter=1:maxIter
                % Compute inner products
                innerProducts = abs(dict' * R);
                % Find the highest inner product
                [~, indices] = max(innerProducts);
                % We now handle each signal separately
                for i=1:s
                    % The new active index for ith signal
                    index = indices(i);
                    omegas(index, i) = 1;
                    % Solve least squares problem
                    omega = find(omegas(:,i));
                    dd = dict(:, omega);
                    y = Y(:, i);
                    tmp = dd \ y;
                    % Updated solution
                    Z(omega, i) = tmp;
                end
                % Let us update the residual.
                R = Y - dict * Z;
                if self.StopOnResidualNorm || self.StopOnResNormStable
                    resNorm = columnWiseNorm(R);
                    if resNorm < self.MaxResNorm
                        break;
                    end
                    if self.StopOnResNormStable
                        change = abs(oldResNorm  - resNorm);
                        if change/oldResNorm < .01
                            % No improvement
                            break;
                        end
                    end
                end
            end            
            % Solution vector
            result.Z = Z;
            % Residual obtained
            result.R = R;
            % Number of iterations
            result.iterations = iter;
            % Solution support
            result.Supports = omegas;
            self.result = result;
        end

        function result  = solve_all_linsolve(self,Y)
            % Initialization
            % Solves approximation problem using OMP
            d = self.D;
            % Residuals at each stage
            R = Y;
            % Number of signals
            ns = size(Y,2);
            dict = self.Dict;
            % Active indices 
            omegas = zeros(d, ns);
            % Estimate
            Z = zeros(d, ns);

            for s=1:ns
                if self.Verbose
                    fprintf('.');
                end
                y = Y(:, s);
                result = self.solve(y);
                Z(:, s) = result.z;
                R(:, s) = result.r;
                omegas(result.support, s) = true;
                if self.Verbose && mod(s, 100) == 0
                    fprintf('\n');
                end
            end
            % Solution vector
            result.Z = Z;
            % Residual obtained
            result.R = R;
            % Solution support
            result.Supports = omegas;
            self.result = result;
            if self.Verbose
                fprintf('\n');
            end
        end

    end
end

