classdef io

methods(Static)

function result = yes_no(flag)
    if flag == 0
        result = 'No';
    else
        result = 'Yes';
    end
end

function result = true_false(flag)
    if flag == 0
        result = 'false';
    else
        result = 'true';
    end
end

function result = true_false_short(flag)
    if flag == 0
        result = 'F';
    else
        result = 'T';
    end
end

function result = success_failure(flag)
    if flag == 0
        result = 'Failure';
    else
        result = 'Success';
    end
end

function result = success_failure_short(flag)
    if flag == 0
        result = 'F';
    else
        result = 'S';
    end
end

function result = bytes2str(bytes)
    % Identify the scale of number of bytes
    scale = floor(log(bytes)/log(1024));
    switch scale
        case 0
            result = sprintf('%d Bytes', bytes);
        case 1
            result = sprintf('%.2f KB', bytes / (1024^1));
        case 2
            result = sprintf('%.2f MB', bytes / (1024^2));
        case 3
            result = sprintf('%.2f GB', bytes / (1024^3));
        case 4
            result = sprintf('%.2f TB', bytes / (1024^4));
        case -inf
            result = 'Not available';
        otherwise
            result = 'Too big';
    end

end

end

end
