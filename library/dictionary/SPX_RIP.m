classdef SPX_RIP < handle

    methods(Static)
        function [ delta] = estimate_delta( Phi, KMax )
        %ESTIMATERIPDELTA Estimates delta for the sensing matrix Phi
        [M, N] = size(Phi);
        if nargin == 1
            KMax  = N;
        end
        % the value of K for this test
        K =  0;
        delta = zeros(KMax, 2);
        tic;
        while K < KMax
            K = K + 1;
            [estimatedMaxDelta, estimatedMinDelta, trials] = estimateRIPKDelta(Phi, N, K);
            elapsedTime = toc;
            % Store the estimated value of delta for current value of K
            delta(K, 1) = estimatedMaxDelta;
            % Store the number of trials conducted for this value of K
            delta(K, 2) = trials;
            % Display results for current value of K
            fprintf('K:%d, estimated max delta: %f, min delta:%f, trials: %d, elapsed time: %0.2f seconds.\n', ...
                K, estimatedMaxDelta, estimatedMinDelta, trials, elapsedTime);
            if  estimatedMaxDelta >= 0.4142
                % We don't need to consider RIP property for higher values of K
                break;
            end
        end
        % Finally we keep only K rows from delta
        delta = delta(1:K,:);
        end

    end

end


function [estimatedMaxDelta, estimatedMinDelta, totalTrials] = estimateRIPKDelta(Phi, N, K)
% helper function for estimating delta for a specific value of K using
% Monte carlo simulations
% Number of trials.
trials = 10*N;
totalTrials = 0;
estimatedMaxDelta = 0;
estimatedMinDelta = 1;
% We want delta to converge upto certain number of decimal digits
accuracy = 1e-8;
while true
    % We will improve our estimate further
    newEstimatedMaxDelta = estimatedMaxDelta;
    newEstimatedMinDelta = estimatedMinDelta;
    for i=1:trials;
        % generate a unit norm Cauchy random vector
        x = SPX_Signals.unit_norm_sparse_uniform_signal(N, K);
        % generate a unit norm Gaussian random vector
        %x = unitNormSparseGaussianVector(N, K);
        % Compute the projection
        y = Phi * x;
        % Compute the norm squared of projection
        normYSquared = y'*y;
        % Compute the value of delta
        if normYSquared < 1
            currentDelta = 1 - normYSquared;
        else
            currentDelta = normYSquared - 1;
        end
        % Update delta estimate
        newEstimatedMaxDelta = max(newEstimatedMaxDelta, currentDelta);
        newEstimatedMinDelta = min(newEstimatedMinDelta, currentDelta);
    end
    totalTrials = totalTrials + trials;
    %disp(newEstimatedDelta);
    % Measure difference between current and previous estimate
    difference = abs(newEstimatedMaxDelta  - estimatedMaxDelta);
    estimatedMaxDelta = newEstimatedMaxDelta;
    estimatedMinDelta = newEstimatedMinDelta;
    % Check if we have stabilized
    if difference < accuracy
        % We are done
        break;
    end
    % We need more trials
    trials = round(1.5*trials);
end
end
