classdef SPX_MatchedFilter < handle

    properties(SetAccess=private)
        % The signals to be used by the filter
        Signals
    end

    methods
        function self  = SPX_MatchedFilter(signals)
            self.Signals  = signals;
        end

        function [ matchedFilterStatistic ] = apply(self, receivedSequence)
            %APPLY Computes matched filter based statistic on sequence
            signals = self.Signals;

            % Length of each signal to compare (N) and number of signals to compare (L)
            % Each signal is stored in one column
            % There are S such columns
            [N, S] = size(signals); % NxS
            % Number of received samples
            numReceivedSamples = length(receivedSequence);
            % Number of received bits
            B = round(numReceivedSamples/N);
            % We initialize output data
            % Number of rows = number of received bits
            % Each row contains results for each of the signals
            % Number of columns = number of signals
            % We reshape the received sequence
            % each column contains received sequence for one sample
            receivedSequence = reshape(receivedSequence, N, B); % NxB
            matchedFilterStatistic = receivedSequence' * signals;
        end
    end

    methods(Static)
        function [ matchedFilterStatistic ] = filter( receivedSequence,...
            signals )
            mf = SPX_MatchedFilter(signals);
            matchedFilterStatistic = mf.apply(receivedSequence);
        end
    end
end
