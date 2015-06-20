classdef SPX_SparseRecovery < handle

    methods(Static)
        function [ M ] = phase_transition_estimate_m( N,K )
        %PHASE_TRANSITION_ESTIMATE_M Estimates the value of M based on
        %Phase transition analysis by Donoho
        % We estimate M based on Phase transition analysis by Donoho
        M = 2* K * log(N);
        M = (fix(M /10) + 1)*10;
        end
    end

end