classdef SPX_Latex < handle

    properties
    end

    methods(Static)
        function printVector(x)
            n = length(x);
            fprintf('\\begin{pmatrix}\n');
            for i=1:n-1
                fprintf('%g & ', x(i));
                if mod(i,10) == 0
                    fprintf('\n');
                end
            end
            fprintf('%g\n', x(n));
            fprintf('\\end{pmatrix}\n');
        end

        function printMatrix(Phi)
            [M,N] = size(Phi);
            fprintf('\\begin{bmatrix}\n');
            for i=1:M
                % Pick up ith row
                x = Phi (i, :);
                for j=1:N-1
                    fprintf('%g & ', x(j));
                end
                fprintf('%g', x(N));
                if i == M
                    fprintf('\n');
                else
                    fprintf('\\\\\n');
                end
            end
            fprintf('\\end{bmatrix}\n');
        end

        function [] = printSet( x )
        %PRINTSET Prints a set suitable for LaTeX
        n = length(x);
        if n == 0
            fprintf('\\EmptySet \n');
            return;
        end
        fprintf('\\{ ');
        for i=1:n-1
            fprintf('%g , ', x(i));
            if mod(i,10) == 0
                fprintf('\n');
            end
        end
        fprintf('%g \\} \n', x(n));
        end

        function printTabular(cells, headers)
            [rows, cols] = size(cells);
            fprintf('\\begin{table}[ht]\n');
            fprintf('\\centering\n');
            fprintf('\\caption{Caption here}\n');
            fprintf('\\label{tbl:mytable_label}\n');

            fprintf('\\begin{tabular}');
            % column positions
            fprintf('{|');
            for c=1:cols
                fprintf('c|');
            end
            fprintf('}\n');
            fprintf('\\hline\n');
            if nargin > 1
                % headers are to be printed
                for c=1:cols-1
                    fprintf('%s & ', headers{c});
                end
                fprintf('%s \\\\\n', headers{cols});
                fprintf('\\hline\n');
            end
            for r=1:rows
                for c=1:cols
                    value = cells{r, c};
                    if c ~= cols
                        term = '&';
                    else
                        term = '\\';
                    end
                    if isinteger(value)    
                        fprintf('%d  %s ', value, term);
                    elseif isfloat(value)
                        fprintf('%.2f  %s ', value, term);
                    else
                        fprintf('%s  %s ', value, term);
                    end
                end
                fprintf('\n');
            end
            fprintf('\\hline\n');
            fprintf('\\end{tabular}\n');
            fprintf('\\end{table}\n');
        end
    end

end

