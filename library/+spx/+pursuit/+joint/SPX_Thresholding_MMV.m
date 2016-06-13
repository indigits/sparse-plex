classdef SPX_Thresholding_MMV < handle
    % Implements Thresholding-MMV algorithm for sparse approximation
    
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
        % The norm to be chosen for rows
        P
        % Result of a solver
        result
    end
    
    methods
        function self  = SPX_Thresholding_MMV(Dict, K, P)
            if nargin < 3
                % By default we apply l_1 norm on rows
                P = 1;
            end
            if P ~= 1 &&  P ~= 2
                error('Only l_1 and l_2 norms are supported.');
            end
            self.P = P;
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
            % Initial residual
            R = Y;
            dict = self.Dict;
            % Active indices 
            omega = [];
            % Estimate
            Z = zeros(d, s);
            P = self.P;
            % Compute inner products (DxN  * NxS = DxS )
            innerProducts = apply_ctranspose(dict, R);
            % Compute absolute values of inner products
            innerProducts = abs(innerProducts);
            if P == 1
                % Compute sum of inner products over each row
                innerProducts = sum(innerProducts, 2);
            elseif P == 2
                % Compute l2 norm inner products over each row
                innerProducts = SPX_Norm.norms_l2_rw(innerProducts);
            else
                error('Impossible');
            end
            [sortedInnerProducts,Indices] = sort(innerProducts,1,'descend');
            % Pick first K indices as the solution support.
            omega = Indices(1:self.K);
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

