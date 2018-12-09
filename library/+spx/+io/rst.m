classdef rst

properties
end

methods(Static)
    function print_list_table(data, headers)
        if istable(data)
            data = table2cell(data);
        end
        if ~iscell(data)
            data = num2cell(data);
        end
        [rows, cols] = size(data);
        fprintf('.. list-table::\n');
        fprintf('    :header-rows: 1\n\n');
        if nargin > 1
            % headers are to be printed
            for c=1:cols
                if c == 1
                    fprintf('    * - ');
                else
                    fprintf('      - ');
                end
                fprintf('%s\n', headers{c});
            end
        end
        for r=1:rows
            for c=1:cols
                if c == 1
                    fprintf('    * - ');
                else
                    fprintf('      - ');
                end
                value = data{r, c};
                if isinteger(value)    
                    fprintf('%d', value);
                elseif isfloat(value)
                    if round(value) == value
                        fprintf('%d', value);
                    else
                        fprintf('%.2f', value);
                    end
                elseif islogical(value)
                    if value
                        fprintf('true');
                    else
                        fprintf('false');
                    end
                else
                    fprintf('%s', value);
                end
                fprintf('\n');
            end
        end
    end

    function print_data_table(tbl)
        spx.io.rst.print_list_table(tbl, tbl.Properties.VariableDescriptions)
    end
end

end

