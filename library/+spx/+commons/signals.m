classdef signals
    %signals Helper functions for working with signals
    
    properties
    end
    
    methods(Static)
        function [x,i] = find_first_signal_with_energy_le(X, energy)
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

        function [ indices ] = largest_indices( x, K )
            %LARGESTINDICES Returns the set of K largest indices
            if isempty(x)
                indices = [];
                return
            end
            [~, idx] = sort(abs(x), 'descend');
            % choose the last K indices
            indices = idx(1:K);
        end

        function [ approxX ] = sparseApproximation( x, K )
            %SPARSEAPPROXIMATION Finds the sparse approximation of x
            %
            % Input:
            %   x: N length arbitrary column vector
            %   K: Number of terms to keep in sparse approximation
            N = length(x);
            % Let us find the K-sparse approximation of x directly
            indices = spx.commons.signals.largest_indices(x, K);
            % K-sparse approximation of x
            approxX = zeros(N,1);
            approxX(indices) = x(indices);
        end

        function [ x ] = unit_norm_sparse_uniform_signal( N, K )
            %unit_norm_sparse_uniform_signal Generates a K sparse signal of unit norm
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

        function y = resize_signals(x, n)
            % Resizes a signals via resampling
            %
            % A row vector is resampled into a row vector
            % A column vector is resampled into a column vector
            % A matrix is resampled column wise.
            y = resample(x, n, length(x));
        end
        
    end
    
end

