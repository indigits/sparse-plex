classdef SPX_IT
% functions related to information theory


methods(Static)


    function h = entropy(data)
        % Returns entropy H(x) of a discrete random variable x from observed data
        probabilities = SPX_Statistics.relative_frequencies(data);
        % Compute the logarithms of probabilities
        log_probabilities = log2(probabilities + eps);
        % Compute the entropy
        h = -dot(probabilities,log_probabilities);
        % Make sure that entropy is not negative
        h = max(0,h);
    end


end


end

