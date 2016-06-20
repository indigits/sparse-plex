classdef lang
% Useful methods for extending Language core functionality

methods(Static)
    
function result = is_class(classpath)
    % Returns true if classpath points to a MATLAB class.
    result = (exist(classpath, 'class') ~= 0);
end


function varargout = noop(varargin)
    % Does nothing
    for i=1:nargout
        varargout{i} = [];
    end
end

end

end
