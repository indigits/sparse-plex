classdef SPX_BinaryHypothesisTest < handle
    methods (Static)
function [ result ] = performance(...
    original, detected, previousResult)
        %PERFORMANCE Measures the performance of a
        % binary hypothesis testing algorithm. 
        %
        % It computes following metrics as a measure
        % of performance.
        % 
        % PD - Estimated detection probability or detection rate
        % PF - Estimated false alarm probability or false alarm rate
        % PM - Estimated miss probability or miss rate
        % Accuracy - Accuracy of test
        % Precision - precision of test for alternate hypothesis
        % Recall - recall of test for alternate hypothesis
        % F1 - The F1 figure (which combines precision and recall
        %
        % Input:
        %   input: Sequence of source bits
        %   detected: Sequence of detected bits
        %   previousResult: results from previous cycle for accumulation if
        %   required.

        % We map 00,01,10,11 to 0,1,2,3 from the two sequences
        prsum = detected * 2 + original;
        % We get the counts of 0,1,2,3 in the summed data
        table = tabulate(prsum);
        [r,~] = size(table);
        % There should be only 4 rows in table
        if r > 4
            disp(table);
            error('Invalid data');
        end
        % detected false + original false (true negative)
        index = find(table(:, 1) == 0);
        if index
            result.FF = table(index, 2);
        else
            result.FF = 0;
        end
        % detected false when original true ( miss or false negative)
        index = find(table(:, 1) == 1);
        if index
            result.FT = table(index, 2);
        else
            result.FT = 0;
        end
        % detected true when original false ( false alarm or false positive)
        index = find(table(:, 1) == 2);
        if index
            result.TF = table(index, 2);
        else
            result.TF = 0;
        end
        % detected true when original true ( detection or true positive)
        index = find(table(:, 1) == 3);
        if index
            result.TT = table(index, 2);
        else
            result.TT = 0;
        end
        % At this point, we might accumulate previous results if any
        prevTotal = 0;
        if exist('previousResult', 'var') && isstruct(previousResult)
            result.FF  = result.FF + previousResult.FF;
            result.FT  = result.FT + previousResult.FT;
            result.TF  = result.TF + previousResult.TF;
            result.TT  = result.TT + previousResult.TT;
            prevTotal = previousResult.Total;
        end
        % Total number of observations
        result.Total = result.FF + result.FT + result.TF + result.TT;

        if result.Total - prevTotal ~= length(original)
            disp(table);
            error('Invalid data');
        end

        % We now compute the performance metrics
        % Number of times 0 was sent
        result.H0 = result.TF + result.FF;
        % Number of times 1 was sent
        result.H1 = result.FT + result.TT;
        % Number of times 0 was detected
        result.D0 = result.FT + result.FF;
        % Number of times 1 was detected
        result.D1 = result.TF + result.TT;
        % A priority probabilities
        result.P0 = result.H0 / result.Total;
        result.P1 = result.H1 / result.Total;
        % Probability of detections given that source has sent 1
        if result.TT > 0
            result.PD = result.TT / result.H1;
        else
            result.PD = 0;
        end
        % Probability of false alarms given that source has sent 0
        if result.TF > 0
            result.PF = result.TF / result.H0;
        else
            result.PF = 0;
        end
        % Probability of misses given that source has sent 1
        if result.FT > 0
            result.PM = result.FT / result.H1;
        else
            result.PM = 0;
        end
        % Probability of correct decisions
        result.Accuracy = (result.TT  + result.FF) / result.Total;
        % Probability of error
        result.Pe = (result.TF + result.FT) / result.Total;
        % Probability of being right when saying that alternate hypothesis is true
        if result.TT > 0
            result.Precision = result.TT / (result.D1);
        else
            result.Precision = 0;
        end
        % Recall is same as probability of detection
        if result.TT > 0
            result.Recall = result.TT / (result.H1);
        else
            result.Recall = 0;
        end
        prsum = result.Precision + result.Recall;
        % F1 rate combines precision and recall
        if prsum > 0
            result.F1 = 2 * result.Precision * result.Recall / prsum;
        else
            result.F1 = 0;
        end
        end
    end
end
