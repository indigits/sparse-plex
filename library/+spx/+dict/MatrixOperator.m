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
        
        function [m, n] = size(self, dim)
            [mm, nn]  = size(self.A);
            if nargin == 2
                if dim == 1
                    m = mm;
                    return;
                elseif dim == 2
                    m = nn;
                    return;
                else
                    error('Invalid dimension');
                end
            end
            if nargout <= 1
                % Return both parts of size in an array
                m = [mm, nn];
            elseif nargout == 2
                % Return the rows and cols separately
                m = mm;
                n = nn;
            else
                % What is this?
                error('Invalid output arguments');
            end
        end

        function result = apply(self, vectors)
            result = self.A * vectors;
        end

        function result = apply_transpose(self, vectors)
            result = self.A.' * vectors;
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


