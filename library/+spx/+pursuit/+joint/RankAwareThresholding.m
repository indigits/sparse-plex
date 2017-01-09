classdef RankAwareThresholding < handle
    % Implements Rank aware thresholding algorithm for sparse approximation
    
    properties
        % Indicates if log messages should be printed at each iteration
        Verbose = false
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
        function self  = RankAwareThresholding(Dict, K)
            % We assume that all the columns in dictionary are normalized.
            if isa(Dict, 'spx.dict.Operator')
                self.Dict = Dict;
            elseif ismatrix(Dict)
                self.Dict = spx.dict.MatrixOperator(Dict); 
            else
                error('Unsupported operator.');
            end
            [self.N, self.D] = size(Dict);
            if nargin < 2
                error('Sparsity level must be specified.');
            end
            self.K = K;
        end
        
        function result  = solve(self, Y)
            % Initialization
            % Solves approximation problem using OMP
            d = self.D;
            n = self.N;
            % The number of signals being approximated.
            s = size(Y, 2);
            dict = self.Dict;
            % Active indices 
            omega = [];
            % Estimate
            Z = zeros(d, s);
            % Orthonormalize Y
            U = orth(Y); % Y is n x s. U is n x r.
            % Verify its rank
            k = self.K;
            % Prepare the projection operator
            P = eye(n) - U*U'; % P is n x n
            % Compute the projection of each atom on 
            % orthogonal complement of R(U)
            % compute the norms of projections
            projection_norms = zeros(1, d);
            for i=1:d
                projection_norms(i) = norm(P * (dict.column(i)) );
            end
            % sort the norms
            [sorted_norms, indices] = sort(projection_norms);
            % disp(sorted_norms);
            % Pick first K indices as the solution support.
            omega = indices(1:self.K);
            % Solve least squares problem
            subdict = columns(dict, omega);
            tmp = linsolve(subdict, Y);
            % Updated solution
            Z(omega, :) = tmp;
            % Let us update the residual.
            R = Y - dict.apply(Z);
            resNorm = norm(R, 'fro');            
            % Solution vector
            result.Z = Z;
            % Residual obtained
            result.R = R;
            % Solution support
            result.support = omega;
            % residual Frobenius norm
            result.residual_frobenius_norm = resNorm;
            self.result = result;
        end                
    end
end

