classdef SPX_Support
    %SUPPORTUTIL Provides functions for working with support sets
    properties
    end
    
    methods (Static)
        function result = support(x)
            result = find(x ~= 0);
        end
        
        function result = l0norm(x)
            result = sum(x ~= 0);
        end
        
        function result = intersectionRatio(s1, s2)
            s = intersect(s1, s2);
            result = length(s) / max(length(s1),length(s2));
        end
        
        function [result, ratios]  = supportSimilarity(X, reference)
            % Number of signals
            s = size(X, 2);
            ratios = zeros(s,1);
            refSupport = find(reference ~= 0);
            nr = length(refSupport);
            for i=1:s
                x = X(:, i);
                xSupport = find(x ~= 0);
                common = intersect(refSupport, xSupport);
                nc = length(common);
                nx = length(xSupport);
                ratios(i) = nc / max(nx, nr);
            end
            result = mean(ratios);
        end
        
        function [largest, rest] = dominantSupportMerged(data, K)
            % Returns the K dominant indices over multiple signals.
            
            % We sum over each row absolute values
            d = sum(abs(data), 2);
            % We sort in descending order and identify the indices
            [~, indices] = sort(d, 'descend');
            % We return the indices of largest K entries
            largest = indices(1:K);
            rest = indices(K+1:end);
        end
        
        function result = supportSimilarities(X, Y)
            % Compares support similarities for two sets of vectors
            XSupport = X ~= 0;
            YSupport = Y ~= 0;
            Common = and(XSupport, YSupport);
            xSizes = sum(XSupport);
            ySizes = sum(YSupport);
            commonSizes = sum(Common);
            result  = commonSizes ./ (max(xSizes, ySizes));
        end
        
        function result = supportDetectionRate(X, trueSupport)
            XSupport = X ~= 0;
            S = size(X, 2);
            Common = and(XSupport, repmat(trueSupport, 1, S));
            commonSizes = sum(Common);
            trueSupportSize = sum(trueSupport);
            result = commonSizes / trueSupportSize;
        end

        function [ result ] = sortedNonZeroElements( x )
        %SORTEDNONZEROELEMENTS Returns the nonzero components of x sorted
        %descending order based on their magnitude.
        % Number of elements in x
        N = length(x);
        % Identify the number of non-zero elements
        K = sum(x ~= 0);
        % Create a matrix of size Kx3 to hold non-zero elements
        nonZeroElements = zeros(K, 3);
        k = 0;
        % Iterate over all  elements in x
        for i=1:N
            tmp = x(i);
            % Check if  element at this index is non-zero
            if tmp
                k = k +1;
                % store the magnitude, actual value and the index for the
                % nonzero  element
                nonZeroElements(k, :)  = [abs(tmp), tmp, i];
            end
        end
        % Sort the rows in non-zero elements matrix
        nonZeroElements = sortrows(nonZeroElements);
        % Finally return the sorted values in descending magnitude order
        result = nonZeroElements(end:-1:1,3:-1:2)';
        end


    end
    
end

