classdef log

methods(Static)

function display(message)
    % compute current time string
    curtime = datestr(now, 'HH:MM:SS');
    disp([curtime, ' ', message]);
end

end

end