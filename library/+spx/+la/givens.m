classdef givens

methods(Static)

function [c,s] = rotation(a,b)
    % Givens rotation computation
    % Determines cosine-sine pair (c,s) so that [c s;-s c]'*[a;b] = [r;0]
    % G = [c  s; -s c]
    % x = [a; b]
    % G' x = [r; 0]
    % GVL4: algorithm 5.1.3
    if b==0
        % No rotation needed
        c = 1; s = 0;
    else
        if abs(b)>abs(a)
            tau = -a/b; 
            s = 1/sqrt(1+tau^2); 
            c = s*tau;
        else
            tau = -b/a; 
            c = 1/sqrt(1+tau^2); 
            s = c*tau;
        end
    end
end % function

function G = planerot(x)
    % Mimics the planerot function of MATLAB
    a = x(1);
    b = x(2);
    if b==0
        % No rotation needed
        c = 1; s = 0;
    else
        sa = sign(a);
        sb = sign(b); 
        if abs(b)>abs(a)
            tau = -a/b; 
            s = -sb/sqrt(1+tau^2); 
            c = s*tau;
        else
            tau = -b/a; 
            c = sa/sqrt(1+tau^2); 
            s = c*tau;
        end
    end
    G = [c, -s; s c];
end % function

function theta = theta(c, s)
    theta = atan(s/c);
end


end % methods 

end % classdef

