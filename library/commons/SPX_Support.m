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
    end
    
end

