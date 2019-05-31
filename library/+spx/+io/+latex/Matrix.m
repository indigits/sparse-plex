classdef Matrix < handle

properties
    hide_zeros = true
    show_nonzero_as_x = false
end

properties(SetAccess=private)
    % The matrix to be printed
    A
    % colors for individual cells
    cell_colors
    % colors for individual rows
    row_colors
    % colors for individual columns
    col_colors
end

methods

function self = Matrix(A)
    self.A = A;
    [m, n] = size(A);
    self.cell_colors = sparse(m, n);
    self.row_colors = sparse(m, 1);
    self.col_colors = sparse(n, 1);
end % function

function print(self)
    [M,N] = size(self.A);
    fprintf('\\begin{bmatrix}\n');
    for r=1:M
        self.print_row(r, M, N);
        if r == M
            fprintf('\n');
        else
            fprintf('\\\\\n');
        end
    end
    fprintf('\\end{bmatrix}\n');
end % function

function set_cell_color(self, r, c, color)
    self.cell_colors(r, c) = color;
end

function set_row_color(self, r, color)
    self.row_colors(r) = color;
end
function set_col_color(self, c, color)
    self.col_colors(c) = color;
end

end % methods

methods(Access=private)
    function print_row(self, r, M, N)
        % iterate over cells
        for c=1:N-1
            self.print_cell(r, c, M, N);
            fprintf(' & ');
        end
        % print the last cell
        self.print_cell(r, N, M, N);
    end

    function print_cell(self, r, c, M, N)
        % get the value for the cell
        value = self.A(r, c);
        if value == 0 
            if self.hide_zeros
                fprintf(' ');
                return;
            end
        else
            if self.show_nonzero_as_x
                value = '\\times';
            else
                value = sprintf('%g', value);
            end
        end
        % print it
        color = self.get_cell_color(r, c);
        if color == ""
            fprintf(value);
        else
            fprintf('\\color{%s}{%s}', color, value);
        end
    end

    function color = get_cell_color(self, r, c)
        colors = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black'};
        color = self.cell_colors(r, c);
        if color == 0
            color = self.row_colors(r);
        end
        if color == 0
            color = self.col_colors(c);
        end
        if color == 0
            color = '';
        else
            color = colors{color};
        end
    end
end % methods


end % classdef

