classdef SPX_EquiangularTightFrame < handle
% Methods to construct equiangular tight frame

    methods(Static)

        function result = ss_to_etf(M, normalize)
            if nargin < 2
                normalize = true;
            end
            % Converts a Steiner system to an equiangular tight frame
            % We need to work with the transpose
            A = M';
            % Number of blocks and points
            [b, v] = size(A);
            % The block size (sum over any row)
            k = sum(A(1, :));
            % The number of blocks on which each vertex appears
            r = sum(A(:, 1));
            % size of the Hadamard matrix
            h_size = 1 + (v - 1) / (k -1);
            % The Hadamard matrix to be used in construction
            H = hadamard(h_size);
            hrow_perms = nchoosek(1:h_size, r);
            nperms = size(hrow_perms, 1);
            % The frame to be generated
            F = [];
            % Iterate over the columns of A
            for j=1:v
                % choose r rows of H
                % indices = 1:r;
                % indices = indices + mod(j, h_size - r + 1);
                index_row = mod(j - 1, nperms) + 1;
                indices = hrow_perms(index_row, :);
                H_k = H(indices, :);
                F_j = zeros(b, h_size);
                % Update k-rows of F_j
                A_j = find(A(:, j) ~= 0);
                F_j(A_j, :) = H_k;
                % Put it in the frame
                F = [F F_j];
            end
            % Normalize the columns
            if normalize
                F = SPX_Norm.normalize_l2(F);
            end
            [m, n] = size(F);
            % The frame
            result.F = F;
            % If columns are normalized
            result.normalized = normalize;
            % Signal dimension
            result.m = m;
            % Number of equiangular lines (dictionary size)
            result.n = n;
            % Number of blocks in corresponding Steiner system
            result.b = b;
            % Number of points in corresponding Steiner system
            result.v = v;
            % Block size
            result.k = k;
            % Number of times a point appears in different blocks
            result.r = r;
            % The size of the Hadamard matrix used
            result.h_size = h_size;
            % The used Hadamard matrix
            result.H = H;
        end

        function result = is_etf(F)
            % Verifies that F is an equiangular tight frame
            [m, n] = size(F);
            norms = SPX_Norm.norms_l2_cw(F);
            if ~isalmost(norms, ones(1, n), 1e-5)
                result = false;
                return;
            end
            % Compute the inner product of first two vectors
            f1 = F(:, 1);
            f2  = F(:, 2);
            p = abs(dot(f1, f2));
            % Verify that all vectors have same inner product
            for i=1:n
                ci = F(:, i);
                for j=i+1:n
                    p2 = abs(dot(ci, F(:, j)));
                    if ~isalmost(p2, p, 1e-5)
                        result = false;
                        return;
                    end
                end
            end
            % Verify that the rows are orthogonal to each other
            for i=1:m
                ri = F(i, :);
                for j=i+1:m
                    rj = F(j, :);
                    p = abs(dot(ri, rj));
                    if ~isalmost(p, 0, 1e-5)
                        result = false;
                        return;
                    end
                end
            end
            % Everything is verified.
            result = true;
        end

        function result = ss_etf_structure(k, v)
            %  Describes the structure of an ETF for a given Steiner System
            % Number of points
            result.v = v;
            % block size
            result.k = k;
            % Number of pairs
            result.pairs = v * (v  -1) / 2;
            % Number of pairs per block
            result.pairs_per_block =  k * (k - 1) / 2;
            % Number of blocks 
            result.b = result.pairs  / result.pairs_per_block;
            % Number of blocks in which each point must appear
            % each point must be paired with v - 1 other points
            % in one block it gets paired with k -1 other points
            % a pair cannot appear in two different block
            result.r = (v - 1) / (k - 1);
            % number of vectors
            result.N = v * ( 1 + result.r);
            % signal dimensions
            result.M = result.b;
            % frame redundancy
            result.redundancy = result.N / result.M;
            result.density = k / v;
            % size of hadamard matrix
            result.hadamard_size = 1 + result.r;

        end
    end

end
