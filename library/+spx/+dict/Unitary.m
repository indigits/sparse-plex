classdef unitary
    % Ways to create unitary matrices
    properties
    end
    
    methods(Static)

        function Q = uniform_normal_qr(n)
            % Generates a uniformly distributed orthogonal matrix
            % from a random matrix of standard normal variables
            % using QR decomposition
            % see - 1985_generation_of_random_orthogonal_matrices.pdf
            % - how_to_generate_random_unitary_matrix.pdf
            X = randn(n);
            [Q, R] = qr(X);
        end

        function [rotations, reflections] = analyze_rr(O)
            % Splits a given orthogonal matrix into 
            % rotations and reflections
            [m, n] = size(O);
            if m ~= n
                error('Matrix must be square');
            end
            % Number of rotations
            K = n * (n -1) / 2;
            rotations = zeros(1, K);
            k = 0;
            for i=1:n
                for j=i+1:n
                    % identify the (i, j)-th rotation
                    [c, s] = spx.dict.unitary.givens_rot(O(i, i), O(j, i));
                    G = [c -s
                        s c];
                    % x = [O(i, i); O(j, i)];
                    % G = planerot(x);
                    % apply the rotation on i-th and j-th rows
                    O([i, j], :) = G * O([i, j], :);
                    k = k + 1;
                    theta = atan(G(2,1) / G(1,1));
                    rotations(k) = theta;
                end
            end
            reflections = diag(O)';
        end

        function O = synthesize_rr(rotations, reflections)
            O = diag(reflections);
            n = length(reflections);
            K = length(rotations);
            k = K;
            for i=n:-1:1
                for j=n:-1:i+1
                    theta = rotations(k);
                    k = k - 1;
                    c = cos(theta);
                    s = sin(theta);
                    % apply the rotation in reverse direction
                    G = [c s; -s c];
                    O([i, j], :) = G * O([i, j], :);
                end
            end
        end

        function [c, s] = givens_rot(a, b)
            % this code ensures that cos(theta) is always non-negative.
            % thus the angle is in between [-pi/2, pi/2].
            % see http://en.wikipedia.org/wiki/Givens_rotation 
            if b == 0
                c = 1;
                s = 0;
                return;
            end
            if a == 0
                c = 0;
                s = 1;
            end
            % both a and b are non-zero
            r = hypot(a, b);
            if a > 0
                c = a / r;
                s = -b / r;
            else
                c = -a / r;
                s = b / r;
            end
        end
    end

end
