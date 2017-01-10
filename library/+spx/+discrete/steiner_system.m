classdef steiner_system
% Functions to create Steiner systems

    methods(Static)

        function M = ss_2(v)
            % Computes a Steiner system where each block is of size 2
            % v - number of points
            % M - the incidence matrix of the generated Steiner system

            % number of pairs
            b = v * (v - 1) / 2;
            M = zeros(v, b);
            c = 0;
            for i=1:v
                for j=i+1:v
                    % Move on to the next block
                    c = c + 1;
                    % Add i-th and j-th element to the block
                    M(i, c) = 1;
                    M(j, c) = 1;
                end
            end
        end


        
        function M = ss_3(v)
            % Computes a Steiner system where each block is of size 3
            % Also known as Steiner triple system (STS)
            if mod(v, 6) ~= 3
                error('Only v = 6n + 3 supported at the moment');
            end
            M = spx.discrete.steiner_system.ss_3_bose(v);
        end

        function M = ss_3_bose(v)
            % Uses Bose construction for STS system for v = 6n + 3
            v2 = v /3 ;
            % number of blocks
            b = v * ( v - 1) / 6;
            % The incidence matrix
            M = zeros(v, b);
            % Construct the commutative idempotent Latin square
            addition_table = spx.discrete.steiner_system.commutative_idempotent_latin_square(v2);
            % The column number in M
            c = 0;
            % Insert type 1 triplets
            for i=0:v2-1
                c = c + 1;
                M(3*i + 0 + 1, c) = 1;
                M(3*i + 1 + 1, c) = 1;
                M(3*i + 2 + 1, c) = 1;
            end
            for i=0:v2-1
                for j=i+1:v2 -1
                    for k=0:2
                        c = c + 1;
                        i_j_sum = addition_table(i + 1, j + 1);
                        M(3*i + k + 1, c) = 1;
                        M(3*j + k + 1, c) = 1;
                        M(3*i_j_sum + mod(k+1,3) + 1, c) = 1;
                    end
                end
            end
        end


        function result = is_ss(M, k)
            % Verifies that a given incidence matrix is a Steiner system or not
            [v, b] = size(M);
            pairs = v * (v -1) / 2;
            pair_per_block = k * (k - 1) /2;
            if b ~= pairs / pair_per_block
                result = false;
                return;
            end
            % verify that the matrix consists of only ones and zeros
            one_zero_count = sum(sum( (M == 0) + (M == 1)));
            if one_zero_count ~= v * b
                result = false;
                return;
            end
            % verify that each column contains exactly k 1s
            if sum(M) ~= k*ones(1, b)
                result = false;
                return;
            end
            % each point can appear only in (v - 1) / (k - 1) blocks
            blocks_per_point = (v - 1) / (k - 1);
            if sum(M, 2) ~= blocks_per_point*ones(v, 1)
                result = false;
                return;
            end
            result = true;
        end

        function table = commutative_idempotent_latin_square(n)
            % Check if n is odd
            if mod(n, 2) == 0
                error('Commutative idempotent Latin square is supported only for odd numbers');
            end
            % Compute the z_n addition table first
            table = spx.discrete.steiner_system.z_n_addition_table(n);
            % Prepare a mapping of numbers
            d = diag(table);
            mapping = zeros(n, 1);
            for i=1:n
                v = d(i);
                mapping(v + 1) = i; 
            end
            for i=1:n
                for j=1:n
                    cur_value = table(i, j);
                    mapped_value = mapping(cur_value + 1) - 1;
                    table(i, j) = mapped_value;
                end
            end            
        end

        function table = z_n_addition_table(n)
            table = zeros(n);
            for i=0:n-1
                for j=0:n-1
                    table(i+1, j+1) = mod(i + j, n);
                end
            end
        end

        function result = is_latin_square(table)
            % This tests whether the table is a latin square
            % This is a rough test. Not a complete test.
            [m , n] = size(table);
            if m ~= n
                result = false;
                return;
            end
            % sum of rows / columns is known
            expected_sum = n * (n - 1)/2;
            a = sum(table);
            if a ~= expected_sum * ones(1, n)
                result = false;
                return;
            end
            a = sum(table, 2);
            if a ~= expected_sum * ones(n, 1)
                result = false;
                return;
            end
            result = true;
        end

    end

end

