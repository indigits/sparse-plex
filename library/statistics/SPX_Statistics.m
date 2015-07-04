classdef SPX_Statistics < handle

    methods(Static)

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

    end

end

