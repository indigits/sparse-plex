classdef SPX_Operator < handle
% Skeleton for any operator in CSF

     methods (Abstract)
        result = size(self)
        result = apply(self, vectors)
        result = apply_transpose(self, vectors)
        result = apply_ctranspose(self, vectors)
        result = norm(self)
     end

     methods
        function result = double(self)
            % Converts the operator into a MATRIX
            [~, n] = self.size();
            result = self.apply(speye(n, n));
        end

        function result = mtimes(self, other)
            result = self.apply(other);
        end

        function result = transpose(self)
            [m, ~] = self.size();
            result = SPX_MatrixOperator(self.apply_transpose(speye(m, m)));
        end

        function result = ctranspose(self)
            [m, ~] = self.size();
            result = SPX_MatrixOperator(self.apply_ctranspose(speye(m, m)));
        end

        function result = columns(self, columns)
            [~, n] = size(self);
            nc = length(columns);
            is = columns;
            js = 1:nc;
            vals = ones(nc, 1);
            post = sparse(is, js, vals, n, nc);
            result = self.apply(post);
        end

        function result = apply_columns(self, vectors, columns)
            [m, n] = self.size();
            [k, s] = size(vectors);
            full_vectors = zeros(n, s);
            full_vectors(columns, :) = vectors;
            result = self.apply(full_vectors);
        end

        function result = columns_operator(self, columns)
            % Returns an operator which applies only specific
            % columns from this operator
            [~, n] = size(self);
            nc = length(columns);
            is = columns;
            js = 1:nc;
            vals = ones(nc, 1);
            post = sparse(is, js, vals, n, nc);
            tmp = self.apply(post);
            result  = SPX_MatrixOperator(tmp);
        end

        function result = column(self, index)
            % Returns one column from the operator
            [~, n] = size(self);
            mask = zeros(n, 1);
            mask(index) = 1;
            result = self.apply(mask);
        end

        function display(self)
            disp(self);
        end

        function result = subsref2(self, s)
            % TODO: . should map to calling a method
            % This has optimization issues too
            % If only few rows with all columns are asked for
            % Then this computes all columns first and then
            % drops most of the rows.
            [m, n] = size(self);
            switch s(1).type
                case '()'
                    rows = s(1).subs{1};
                    cols = s(1).subs{2};
                    if strcmp(rows, ':')
                        pre = speye(m);
                    else
                        nr = length(rows);
                        pre = speye(nr, m);
                        for r=1:nr
                            pre(rows(r), r) = 1;
                        end
                    end
                    if strcmp(cols, ':')
                        post = speye(n);
                    else
                        nc = length(cols)
                        post = sparse(n, nc);
                        for c=1:nc
                            post(cols(c), c) = 1;
                        end
                    end
                    tmp = self.apply(post);
                    result = pre * tmp;
                otherwise
                    error('Only matrix subscript references are supported');
            end
        end

     end
end
