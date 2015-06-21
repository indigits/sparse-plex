classdef SPX_Signals
    %SPX_SIGNALS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function [x,i] = findFirstLessEqEnergy(X, energy)
            % Returns the first signal with energy less than or equal to
            % given threshold
            s = size(X, 2);
            for i=1:s
                x = X(:,i);
                xx = x' * x;
                if xx <= energy
                    return
                end
            end
            % None could be found
            i = -1;
            x = [];
        end

        function [ indices ] = largestIndices( x, K )
            %LARGESTINDICES Returns the set of K largest indices
            N = length(x);
            tmp = zeros(N,2);
            tmp(:,1) = abs(x);
            tmp(:,2) = 1:N;
            % sort rows based on absolute value of x
            tmp = sortrows(tmp);
            % choose the last K indices
            indices = tmp(end:-1:end-K+1, 2);
        end

        function [ approxX ] = sparseApproximation( x, K )
            %SPARSEAPPROXIMATION Finds the sparse approximation of x
            %
            % Input:
            %   x: N length arbitrary column vector
            %   K: Number of terms to keep in sparse approximation
            N = length(x);
            % Let us find the K-sparse approximation of x directly
            indices = SPX_Signals.largestIndices(x, K);
            % K-sparse approximation of x
            approxX = zeros(N,1);
            approxX(indices) = x(indices);
        end

        function [ e ] = unitVector( N, i )
            %UNITVECTOR Creates a unit vector in the ith dimension of an N dimensional
            %space.
            e = zeros(N,1);
            e(i) = 1;
        end

        function [ x ] = unitNormSparseUniformVector( N, K )
            %UNITNORMSPARSEUNIFORMVECTOR Generates a K sparse vector of unit norm
            % Let us construct a zero vector
            x = zeros(N,1);
            % let us generate a random permutation of numbers from 1 to N
            q = randperm(N);
            % let us put Uniform distributed values in K randomly chosen positions 
            x(q(1:K)) = 2*rand(K,1)-1;
            % Let us measure the norm of this vector
            n = norm(x);
            % Let us normalize the vector
            x = x / n;
        end
        
    end
    
end

