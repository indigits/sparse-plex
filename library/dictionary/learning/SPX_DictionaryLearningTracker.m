classdef SPX_DictionaryLearningTracker < handle
% Tracks the progress of dictionary learning process

properties
    % True dictionary (if available then error w.r.t. true dictionary
    % is captured)
    TrueDictionary = []
    % Shows progress if set
    DisplayProgress = true
    % Capture dictionaries in each iteration
    CaptureDictionaries = false
end

properties (SetAccess=private)
    Counter = 0
    % Current dictionary
    CurrentDictionary = []
    % Current representations
    CurrentRepresentations = []
    % Current residuals
    CurrentResiduals = []
    % start time
    TimeStart
    % Time in each iteration
    IterationTimes
    % Total dictionary learning time
    TotalLearningTime
    % Ratio of atoms which got matched in each iteration
    MatchedAtomRatios
    % Dictionaries obtained in each iteration
    Dictionaries
    % Coherence of each dictionary
    Coherences
    % Iteration by iteration error
    TotalErrors
    % Iteration by iteration non zero entries
    NumNonZeroEntries
end

methods
    function self = SPX_DictionaryLearningTracker()
        if self.CaptureDictionaries
            self.Dictionaries = cell(self.MaxIterations, 1);
        end
        self.TimeStart = tic;
        self.TotalLearningTime = 0;
    end

    function  dictionary_update_callback(self, ...
        new_dict, new_representations, new_residuals)
        % This method is called whenever dictionary has been updated
        self.CurrentDictionary = new_dict;
        self.CurrentRepresentations = new_representations;
        self.CurrentResiduals = new_residuals;
        self.Counter = self.Counter + 1;
        % We capture time spent so far in learning
        newTimeSpent = toc(self.TimeStart);
        self.IterationTimes(self.Counter) =  newTimeSpent - self.TotalLearningTime;
        self.TotalLearningTime = newTimeSpent;
        % Number of signals
        S = size(new_residuals, 2);
        self.TotalErrors(self.Counter) = sqrt(sum(sum(new_residuals.^2))/numel(new_residuals));
        self.NumNonZeroEntries(self.Counter) = length(find(new_representations)) / S;
        self.Coherences(self.Counter) = SPX_DictProps(new_dict).coherence();
        self.print_progress();
    end
end

methods(Access=private)

    function print_progress(self)
        c = self.Counter;
        true_dict  = self.TrueDictionary;
        cur_dict = self.CurrentDictionary;
        if ~isempty(true_dict)
            ratio = SPX_DictionaryComparison.matching_atoms_ratio(true_dict, cur_dict);
            self.MatchedAtomRatios(c) = ratio;
        end
        if self.CaptureDictionaries
            self.Dictionaries{c} = cur_dict;
        end
        reps = self.CurrentRepresentations;
        % Number of signals
        S = size(reps, 2);
        averageCardinality =  length(find(reps))/S;
        fprintf('Iteration: %d, Time (total): %.2f sec, (iteration): %.2f: , Error=%f'...
            , c - 1, self.TotalLearningTime, self.IterationTimes(c), self.TotalErrors(c));
        if ~isempty(true_dict)
            fprintf(', Matched atoms: %.2f%%', self.MatchedAtomRatios(c)*100);
        end
        fprintf(', cardinality: %d', averageCardinality);
        fprintf(', Rank: %d', rank(cur_dict));
        fprintf('\n');
    end

end


end