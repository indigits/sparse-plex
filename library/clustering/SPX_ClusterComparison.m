classdef SPX_ClusterComparison < handle
    %SPX_CLUSTERCOMPARISON Compares two clusterings
    % See comparing_clusterings_overview_wagner-06.pdf
    % INPUT 
    % A - a list of labels for items assigned by one Clustering algorithm
    % B - a list of labels for items assigned by another Clustering algorithm
    % Sometimes either A or B can be ground truth data itself.
    % Each cluster has a label and consists of items in the cluster.
    % The labels are simply integers (1,2,3,4)
    % Even if the number of labels are same for both clusterings, and even
    % if the items in corresponding clusters are also the same, the labels
    % could be very different. 
    % A naive algorithm would try out all possible permutations of labels
    % to find out if the clusterings are identical or not. Here we take
    % advantage of working with the confusion matrix to measure the
    % similarity between the two clusterings.
    
    properties(SetAccess=private)
        % First clustering labels
        A
        % Second clustering labels
        B
        % A: mapping from label to items
        ALabelToItems
        % A: Number of items for each label
        ALabelCounts
        % B: mapping from label to items
        BLabelToItems
        % B: Number of items for each label
        BLabelCounts
        % Total number of clustered items
        N
    end
    
    methods
        % Initializes the comparison algorithm
        function self = SPX_ClusterComparison(A, B)
            self.A = A;
            self.B = B;
            % labels must start from 1.
            if any(A == 0) || any (B == 0)
                error('Invalid clustering');
            end
            % We group items by their labels
            [self.ALabelToItems, self.ALabelCounts] = ...
                SPX_ClusterComparison.groupLabelToItems(A);
            [self.BLabelToItems, self.BLabelCounts] = ...
                SPX_ClusterComparison.groupLabelToItems(B);
            % We don't allow missing labels. i.e.
            % if labels are in the range [1..n] then every label
            % i between 1 and n (inclusive) must have at least one item in
            % the corresponding cluster.
            if any(self.ALabelCounts == 0)
                error('Missing LabelToItems in A');
            end
            if any(self.BLabelCounts == 0)
                error('Missing LabelToItems in B');
            end
            % Total number of items in clustering A
            n = sum(self.ALabelCounts);
            % Total number of items in clustering B
            if n ~= sum(self.BLabelCounts)
                % Both must be identical
                error('Number of clustered items is not same.');
            end
            % Store it for future reference
            self.N = n;
        end
    end
    
    methods
        function M = confusionMatrix(self)
            % Computes the confusion matrix
            % the i,j-th entry in the matrix is number of elements common
            % to the i-th cluster in A and j-th cluster in B.
            na = length(self.ALabelToItems);
            nb = length(self.BLabelToItems);
            M = zeros(na, nb);
            for r=1:na
                % items in the r-th cluster of A
                a = self.ALabelToItems{r};
                for c=1:nb
                    % items in the c-th cluster of B
                    b = self.BLabelToItems{c};
                    % common items
                    common = intersect(a,b);
                    % count of common items
                    M(r,c) = length(common);
                end
            end
        end
        
        function [randIndex, breakup] = randIndex(self)
            % Computes rand index for the clusterings
            % for each pair of items in A, find if they are in same cluster
            mapA = self.clusteringPairMap(self.A);
            % for each pair of items in B, find if they are in same cluster
            mapB = self.clusteringPairMap(self.B);
            % pairs in same cluster in A and same cluster in B
            a = sum(mapA .* mapB);
            % pairs in different clusters in A and different clusters in B
            b = sum((1 - mapA) .* (1 - mapB));
            % pairs in same cluster in A and different clusters in B
            c = sum(mapA .* (1 - mapB));
            % pairs in different clusters in A and same cluster in B
            d = sum((1-mapA) .* mapB);
            randIndex = (a+b) / (a+b+c+d);
            breakup = [a,b,c,d];
        end
        
        function result =  fMeasure(self)
            % Computes the F1 measure of cluster similarity
            na = length(self.ALabelToItems);
            nb = length(self.BLabelToItems);
            fMatrix = zeros(na,nb);
            precisionMatrix = zeros(na,nb);
            recallMatrix = zeros(na,nb);
            for r=1:na
                a = self.ALabelToItems{r};
                for c=1:nb
                    b = self.BLabelToItems{c};
                    common = intersect(a,b);
                    precision = length(common) / length(b);
                    recall = length(common) / length(a);
                    if precision == 0 || recall == 0
                        f1 = 0;
                    else
                        f1 = 2 * precision * recall / (precision + recall);
                    end
                    precisionMatrix(r,c) = precision;
                    recallMatrix(r,c) = recall;
                    fMatrix(r,c) = f1;
                end
            end
            % Total number of items
            n = self.N;
            % find out the maximum precisions for each cluster in B
            maxPrecisions = max(precisionMatrix);
            precision = maxPrecisions * self.BLabelCounts / n;
            % find out the maximum f1 scores for each cluster in A
            [maxF1s, labelMap] = max(fMatrix, [], 2);
            fMeasure = sum(self.ALabelCounts .* maxF1s) / n;
            % find out the maximum recalls for each cluster in A
            maxRecalls = max(recallMatrix, [], 2);
            recall = sum(self.ALabelCounts .* maxRecalls) / n;
            result.fMeasure = fMeasure;
            result.fMatrix = fMatrix;
            result.precisionMatrix = precisionMatrix;
            result.precision = precision;
            result.recallMatrix  = recallMatrix;
            result.recall  = recall;
            result.misclassificationRate  = 1 - recall;
            result.labelMap = labelMap;
            result.smartLabelMap = SPX_ClusterComparison.createLabelMap(fMatrix);
            [clustering_error, remapped_labels] = SPX_ClusterComparison.computeClusteringError(self.A, self.B, result.smartLabelMap);
            result.clusteringError = clustering_error;
            result.remappedLabels = remapped_labels;
            % Number of A labels
            result.numALabels = na;
            % Number of B labels
            result.numBLabels = nb;
            % Indicates if we have over or under clustering
            result.clusteringRatio = nb / na;
        end
    end
    
    methods(Static)
        % Taks a list of labels and returns 
        % 
        % - a map (cell array) from label to list of items for the label
        % - a map from label to number of items for the label.
        function [LabelToItemsByGroup, labelCounts] = groupLabelToItems(LabelToItems)
            % Labels are integers (1, 2, 3, etc.)
            % Find the largest label
            maxLabel = max(LabelToItems);
            % Create a cell array for mapping from label to item list
            LabelToItemsByGroup = cell(maxLabel, 1);
            % Create an array to maintain how many items are there for each
            % label
            labelCounts = zeros(maxLabel, 1);
            % Go over all the labels
            for i=1:maxLabel
                % Find out all items with i-th label
                indices = find(LabelToItems == i);
                % Put the list in the cell array entry for this label
                LabelToItemsByGroup{i} = indices;
                % Also store the number of items for this label
                labelCounts(i) = length(indices);
            end
        end
        function map = clusteringPairMap(labels)
            % Creates a map showing which pairs are in same cluster which
            % are in different
            n = length(labels);
            % Number of pairs
            sz = nchoosek(n,2);
            map = zeros(sz, 1);
            k = 1;
            for i=1:n
                % i-th label
                labelI = labels(i);
                for j=i+1:n
                    % j-th label
                    labelJ = labels(j);
                    % Flag if they are in same cluster or not.
                    map(k) = labelI == labelJ;
                    k = k+1;
                end
            end
        end

        function [label_map, max_scores] = createLabelMap(fMatrix)
            % This function works well only if the number of original and cluster labels are same.
            [n, m] = size(fMatrix);
            if n ~= m
                % We fall back to default implementation
                [max_scores, label_map] = max(fMatrix, [], 2);
                return;
            end
            max_scores = zeros(n, 1);
            label_map  = zeros(n, 1);
            for i=1:n
                f_scores  = fMatrix(i, :);
                [max_score, label] = max(f_scores);
                % check if the label is unused.
                if any(label_map == label)
                    % sort the f score array
                    [sorted_scores, sorted_indices] = sort(f_scores, 'descend');
                    for ii=2:n
                        label = sorted_indices(ii);
                        if ~any(label_map == label)
                            label_map(i) = label;
                            max_scores(i) = sorted_scores(ii);
                            break;
                        end
                    end
                else
                    label_map(i) = label;
                    max_scores(i) = max_score;
                end
            end
        end
        
        function [clustering_error, remapped_labels] = computeClusteringError(true_labels, cluster_labels, label_map)
            num_labels = numel(label_map);
            num_points = numel(true_labels);
            % change the labels in cluster_labels to original
            remapped_labels = zeros(size(cluster_labels));
            for label=1:num_labels
                mapped_label = label_map(label);
                if mapped_label == 0
                    warning('Mapped label should not be zero.');
                end
                remapped_labels(cluster_labels == mapped_label) = label;
            end
            % time to compute clustering error
            clustering_error = sum(true_labels ~= remapped_labels) / num_points;
        end

        function printF1MeasureResult(result)
            fprintf('F1-measure: %.2f, Precision: %.2f, Recall: %.2f, Misclassification rate: %.2f, Clusters: A: %d, B: %d, Clustering ratio: %.2f\n', ...
                result.fMeasure, result.precision, result.recall, result.misclassificationRate, ...
                result.numALabels, result.numBLabels, result.clusteringRatio);
            fprintf('Label map: \n');
            for i=1:length(result.labelMap)
                fprintf('%d=>%d, ', i, result.labelMap(i));
            end
            fprintf('\n');
        end
    end
end

