classdef CompositeOperator < spx.dict.Operator

    properties(SetAccess=private)
        % Operators
        f
        g
    end


    methods
        function self = CompositeOperator(f, g)
            [m1, n1] = size(f);
            [m2, n2] = size(g);
            assert(n1 == m2);
            self.f = f;
            self.g = g;
        end

        function [m, n] = size(self)
            [m, _] = size(f);
            [_, n] = size(g);
        end

        function result = apply(self, vectors)
            result = f.apply(g.apply(vectors));
        end

        function result = apply_transpose(self, vectors)
            result = g.apply_transpose(f.apply_transpose(vectors));
        end

        function result = apply_ctranspose(self, vectors)
            result = g.apply_ctranspose(f.apply_ctranspose(vectors));
        end

    end
end
