classdef SPX_BP_MMV < handle
    % Implements BP-MMV algorithm for sparse approximation

    properties
    end

    properties(SetAccess=private)
        % The dictionary
        Dict
        % Ambient signal dimensions
        N
        % Number of atoms in dictionary
        D
        % Result of a solver
        result
    end

    methods
        function self  = SPX_BP_MMV(Dict)
            % We assume that all the columns in dictionary are normalized.
            if isa(Dict, 'SPX_Operator')
                self.Dict = Dict;
            elseif ismatrix(Dict)
                self.Dict = SPX_MatrixOperator(Dict); 
            else
                error('Unsupported operator.');
            end
            [self.N, self.D] = size(Dict);
        end

        function result  = solve_l1_l1(self, Y)
            % Solves using l_1 l_1 row column norm

            % Initialization
            % Solves approximation problem using basis pursuit.
            d = self.D;
            n = self.N;
            % The number of signals being approximated.
            s = size(Y, 2);
            Phi = self.Dict;
            cvx_begin quiet
                variable Z(d, s);
                minimize( sum( sum(abs(Z), 2) )  )
                subject to 
                    Phi * Z == Y
            cvx_end
            result.Z = Z;
        end

        function result  = solve_l2_l1(self, Y)
            % Solves using l_2 l_1 row column norm

            % Initialization
            % Solves approximation problem using basis pursuit.
            d = self.D;
            n = self.N;
            % The number of signals being approximated.
            s = size(Y, 2);
            Phi = self.Dict;
            cvx_begin quiet
                variable Z(d, s);
                minimize( sum(norms(Z,2, 2)) )
                subject to 
                    Phi * Z == Y
            cvx_end
            result.Z = Z;
        end

        function result  = solve_l2_l1_complex(self, Y)
            % Solves using l_2 l_1 row column norm for complex variables

            % Initialization
            % Solves approximation problem using basis pursuit.
            d = self.D;
            n = self.N;
            % The number of signals being approximated.
            s = size(Y, 2);
            Phi = self.Dict;
            cvx_begin quiet
                variable Z(d, s) complex;
                minimize( sum(norms(Z,2, 2)) )
                subject to 
                    Phi * Z == Y
            cvx_end
            result.Z = Z;
        end

        function result  = solve_linf_l1(self, Y)
            % Solves using l_{\infty} l_1 row column norm

            % Initialization
            % Solves approximation problem using basis pursuit.
            d = self.D;
            n = self.N;
            % The number of signals being approximated.
            s = size(Y, 2);
            Phi = self.Dict;
            cvx_begin quiet
                variable Z(d, s);
                minimize( sum( max(abs(Z), [], 2) )  )
                subject to 
                    Phi * Z == Y
            cvx_end
            result.Z = Z;
        end

    end
end

