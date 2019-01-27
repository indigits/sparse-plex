classdef MatrixOperator < spx.dict.Operator 

    properties(SetAccess=private)
        % The matrix as an operator
        A
        % The Hermitian of matrix
        AH
    end

    methods
        function self = MatrixOperator(A)
            self.A = A;
            self.AH = A';
        end
        
        function [mm, nn]  = get_size(self)
            [mm, nn] = size(self.A);
        end

        function result = apply(self, vectors)
            result = self.A * vectors;
        end

        function result = apply_transpose(self, vectors)
            result = transpose(self.A) * vectors;
        end

        function result = apply_ctranspose(self, vectors)
            result = self.AH * vectors;
        end

        function result = norm(self)
            result = norm(self.A);
        end

    end

    methods
        % We override some of the implementations here
        function result = apply_columns(self, vectors, columns)
            result = self.A(:, columns) * vectors;
        end

        function result = columns(self, columns)
            result = self.A(:, columns);
        end

        function result = columns_operator(self, columns)
            b = self.A(:, columns);
            result = spx.dict.MatrixOperator(b);
        end

        function result = double(self)
            result = self.A;
        end


        function result = subsref2(self, s)
            result = subsref(self.A, s);
        end
    end

end


