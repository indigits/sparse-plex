classdef SPX_Prob
% functions related to probability theory

    methods(Static)
        function [ y ] = q_function( x )
        %QFUNC Computes Q(x)

        y = 1/2 - (1/2) * erf(x / sqrt(2));

        end


        function [ x ] = q_inv_function( y )
        % DESCRIPTION  y = SPX_Prob.q_function(x) 
        %  The inverse Q function
        %  If the input is outsde {0..1} Nan is delivered
        % INPUT 
        %  y --  Any real matrix
        % OUTPUT
        %  x -- Q^-1(x)
        % SEE ALSO
        %  erfc, qfunc
        % TRY
        %  SPX_Prob.q_inv_function(SPX_Prob.q_function([-inf -1 0 1 inf NaN]))
        %  plot(SPX_Prob.q_inv_function(0:0.025:1),0:0.025:1,'.-')
        %  plot(-2:0.1:2,SPX_Prob.q_inv_function(SPX_Prob.q_function(-2:0.1:2)),'.-')
        x = erfinv(1-2*y)*sqrt(2);
        end


        function result = is_pmf(pmf)
            % IS_PMF checks if the given array of probabilities 
            % is a probability mass function or not
            if ~isvector(pmf)
                result = false;
            elseif any(pmf < 0)
                result = false;
            elseif abs(sum(pmf) - 1.0) > 1e-4
                result = false;
            else
                result = true;
            end
        end 
    end
end
