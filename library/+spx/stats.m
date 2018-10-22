classdef stats

methods(Static)


    function [frequencies, labels] = relative_frequencies(data)
        % Returns the frequencies of values of a discrete random variable in the dataset
        n = length(data);
        % Reshape data to a row vector
        data = spx.vector.reshape_as_row_vec(data);
        % Identify unique labels in the data set and their frequencies
        [labels, ~, label_map] = unique(data);
        % Lets get the number of unique labels
        nl = numel(labels);
        % Let's construct an n x nl sparse matrix in which
        % each column identifies c-th label
        % each row identifies the r-th data point
        % each row contains only one 1 and rest of the entries are 0.
        % The column in which 1 is stored identifies the label of the data entry
        % We store this information as the sparse matrix.
        % We already know that the matrix will have n non-zero entries
        non_zero_max = n;
        rows = 1:n;
        columns = label_map;
        index_to_label_matrix = sparse(rows, columns,  1,    n, nl,    non_zero_max);
        % Take mean over each column to obtain the frequencies
        frequencies = full(mean(index_to_label_matrix,1));
    end

    function [ statistic ] = compute_statistic_per_vector(...
        receivedSequence, N, statisticFunc)
        %COMPUTE_STATISTIC_PER_VECTOR Computes a statistic for each vector
        %   Detailed explanation goes here

        % Number of samples
        L = length(receivedSequence);
        % Number of vectors
        M = round(L / N);
        % Each row now represents one vector
        receivedSequence = reshape(receivedSequence, N, M)';
        statistic = zeros(M, 1);
        for i=1:M
            data = receivedSequence(i, :);
            statistic(i) = statisticFunc(data);
        end
    end

    function result = format_descriptive_statistics(x)
        mu = mean(x);
        med = median(x);
        rng = range(x);
        r = iqr(x);
        sigma = std(x);
        [m1, min_idx] = min(x);
        [m2, max_idx] = max(x);
        m3 = mad(x);
        result = sprintf('Min: %.2f (%d), Max: %.2f (%d), Mean: %.2f, Median: %.2f, Range : %.2f, IQR: %.2f, Deviation: %.2f, MAD: %.2f', m1, min_idx, m2, max_idx, mu, med, rng, r, sigma, m3);
    end

end

end

