classdef spaces
% Utility functions to work with vector spaces

    methods(Static)

        function result  = insersection_space(A, B)
            % Let A and B represent vector spaces
            % The function returns basis for their intersection
            if size(A, 1) ~= size(B, 1)
                error('The ambient space must be same.');
            end

            % Orthogonalize the two bases
            A = orth(A);  % A is n x a
            B = orth(B);  % B is n x b
            % Count the rank of each of them
            % After orthogonalization number of columns may have reduced
            rank_a = size(A, 2);  
            rank_b = size(B, 2);
            % Combine them
            C = [A B]; % C is n x (ra + rb)
            % Compute the null space of the whole thing
            D = null(C); % C * D = 0. D is (ra + rb) x  m
            % m is the nullity of C
            % Pick up the first rank_a rows from D
            D2 = D(1:rank_a, :); % ra * m
            % Multiply with A
            result = A * D2 ; % n * m.
            % We get the basis we were looking for
        end

        function result = orth_complement(A, B)
            % Find orthogonal complement of A in B.
            if size(A, 1) ~= size(B, 1)
                error('The ambient space must be same.');
            end
            % Orthogonalize A to make sure that it is full rank.
            A  = orth(A);
            rank_a = size(A,2);
            C = [A B];
            [Q, R] = qr(C, 0);
            % Leave the first rank_a columns from A
            result = Q(:, rank_a+ 1:end);
        end

        function result = principal_angles_orth_cos(A, B)
            % assumes that A and B are orthonormal bases
            % Compute the matrix of inner products of bases of A and B.
            M = A' * B;
            % Compute the SVD of M. The singular values are the cosine of principal angles
            result = svd(M);
        end

        function result = principal_angles_cos(A, B)
            % Finds the principal angles between the subspaces spanned by A and B
            % References
            % - http://in.mathworks.com/matlabcentral/newsreader/view_thread/284282            
            if size(A, 1) ~= size(B, 1)
                error('The ambient space must be same.');
            end
            A = orth(A);
            B = orth(B);
            result = spx.la.spaces.principal_angles_orth_cos(A, B);
        end

        function result = principal_angles_radian(A, B)
            % Returns the principal angles in radians
            s = spx.la.spaces.principal_angles_cos(A, B);
            % Return the angles as cos inverse of singular values
            result = acos(s);
        end

        function result = principal_angles_degree(A, B)
            % Returns the principal angles in degrees
            radians = spx.la.spaces.principal_angles_radian(A, B);
            % Return the angles as cos inverse of singular values
            result = rad2deg(radians);
        end

        function result = smallest_angle_cos(A, B)
            % Returns the smallest angle between two subspaces as cos(theta)
            s = spx.la.spaces.principal_angles_cos(A, B);
            result = s(1);
        end

        function result = smallest_angle_orth_cos(A, B)
            % Returns the smallest angle between two subspaces as cos(theta)
            % assumes A and B are orthonormal bases
            s = spx.la.spaces.principal_angles_orth_cos(A, B);
            result = s(1);
        end

        function result = smallest_angle_rad(A, B)
            % Returns the smallest angle between two subspaces in radians
            cos_theta = spx.la.spaces.smallest_angle_cos(A, B);
            result = acos(cos_theta);
        end

        function result = smallest_angle_deg(A, B)
            % Returns the smallest angle between two subspaces in degree
            theta = spx.la.spaces.smallest_angle_rad(A, B);
            result = rad2deg(theta);
        end

        function result = smallest_angles_cos(subspaces, d)
            % subspaces is either a cell array of bases or a concatenated matrix.
            % d is the dimension of each subspace [needed only if all bases are concatenated]
            if iscell(subspaces)
                bases = subspaces;
                % number of subspaces
                s = numel(subspaces);
                % the ambient dimension
                m = size(bases{1}, 1);
            else
                if nargin < 2
                    error('Dimension of each subspace must be specified.');
                end
                [m, n] = size(subspaces);
                if mod(n, d) ~= 0
                    error('n must be multiple of d');
                end
                % number of subspaces
                s = n /d;
                % create the cell array for bases
                bases = cell(s, 1);
                for i=0:s-1
                    %i-th subspace basis
                    si = subspaces(:, i*d + (1:d));
                    bases{i+1} = si;
                end
            end
            % Orthogonalize all subspaces
            for i=1:s
                bases{i} = orth(bases{i});
            end
            % The smallest angles result matrix
            result = eye(s);
            for i=1:s
                si = bases{i};
                for j=i+1:s
                    % j-th subspace
                    sj = bases{j};
                    result(i, j) = spx.la.spaces.smallest_angle_orth_cos(si, sj);
                    result(j, i) = result(i, j);
                end
            end
        end

        function result = smallest_angles_rad(subspaces, d)
            if nargin < 2
                % subspace dimensions are unspecified
                d = -1;
            end
            result = spx.la.spaces.smallest_angles_cos(subspaces, d);
            result = acos(result);
        end

        function result = smallest_angles_deg(subspaces, d)
            if nargin < 2
                % subspace dimensions are unspecified
                d = -1;
            end
            result = spx.la.spaces.smallest_angles_rad(subspaces, d);
            result = rad2deg(result);
        end

        function result = subspace_distance(A, B)
            % The distance between two subspaces based on Grassmannian
            % References
            % - http://math.stackexchange.com/questions/198111/distance-between-real-finite-dimensional-linear-subspaces
            if size(A, 1) ~= size(B, 1)
                error('The ambient space must be same.');
            end
            A = orth(A);
            B = orth(B);
            if size(A, 2) ~= size(B, 2)
                error('The two subspaces must be of same dimensions');
            end
            % Compute the projection matrices for the two spaces
            PA = A*A';
            PB = B*B';
            D = PA  - PB;
            % We return the operator norm of D as the distance between the two subspaces.
            result = norm(D);
        end

        function result = is_in_range_orth(v, U)
            % Returns if v is in the range of U where U is a unitary matrix
            nv = norm(v);
            if nv == 0
                % zero vector is always in the column space of U
                result = true;
                return;
            end
            % Compute the projection of v into the space spanned by U.
            pv = U (U' * v);
            % Compute the difference [projection to the orthogonal complement of U]
            d = v - pv;
            % Compute it's norm
            nd = norm(d);
            % Verify that the norm of difference is indeed very small
            result = nd <= 1e-6 * nv;
        end

        function result = is_in_range(v, A)
            % Returns if v is in the range of an arbitrary matrix A
            result = is_in_range_orth(v, orth(A)); 
        end

        function result = find_basis(A)
            % Returns a (not necessarily orthogonal) basis of A from columns of A
            [R, pivot_cols] = rref(A);
            [m, n] = size(A);
            i = 1;
            %pivot_cols = false(n, 1);
            %for j=1:n
            %    if R(i, j) == 1
            %        % Add the column containing the leading one
            %        pivot_cols(j) = true;
            %        % Move on to find the 1 in next row
            %        i = i + 1;
            %    end
            %end
            % Return a basis
            result = A (:, pivot_cols);
        end

        function [E, R] = elim(A)
            % References
            % - http://web.mit.edu/18.06/www/Course-Info/Mfiles/elim.m
            % Factorize: E R  = A 
            % where E is a product of elementary matrices and 
            % R is the row reduced echelon form
            [m, n] = size(A);
            I = eye(m);
            RE = rref([A I]);
            R = RE(:, 1:n);
            E = RE(:, (n+1):m+n);
        end

        function N = null_basis(A)
            % Returns a null basis for A
            % References
            % - http://web.mit.edu/18.06/www/Course-Info/Mfiles/nulbasis.m
            [m, n] = size(A);
            [R, pivot_cols] = rref(A, sqrt(eps));
            r = length(pivot_cols);
            % The columns of A which are not part of pivots
            freecol = 1:n;
            freecol(pivot_cols) = [];
            % Create space for storing the null basis
            N = zeros(n, n-r);
            N(freecol, : ) = eye(n-r);
            N(pivot_cols,  : ) = -R(1:r, freecol);
        end


        function [col_space, null_space, row_space, left_null_space] = four_bases(A)
            % Returns bases for the four spaces associated with the matrix A
            % These are not necessarily orthonormal bases
            [m, n] = size(A);
            [R, pivot_cols] = rref(A, sqrt(eps));
            rank_a = length(pivot_cols);
            % The first rank_a rows of the echelon matrix form the row space
            row_space = R(1:rank_a, :)'; 
            % The columns of A indexed by the pivot columns form the column space
            col_space = A(:, pivot_cols);
            
            % Computation of the null space
            % The columns of A which are not part of pivots
            freecol = 1:n;
            freecol(pivot_cols) = [];
            % Allocate memory for the null space basis
            null_space = zeros(n, n-r);
            null_space(freecol, : ) = eye(n-r);
            null_space(pivot_cols,  : ) = -R(1:r, freecol);

            left_null_space = E((r+1):m, :)';
        end

        function [col_space, null_space, row_space, left_null_space] = four_orth_bases(A)
            % Prepares the four bases using SVD
            [U, S, V] = svd(A);
            % Finding the rank of A
            s = diag(S);
            tol = max(size(A))*eps(max(s));
            r = sum(s > tol);
            col_space = U(:, 1:r);
            null_space = U(:, r+1:m);
            row_space = V(:, 1:r);
            left_null_space = V(:, r+1:n);
        end

        function [A, B] = two_spaces_at_angle(N, theta)
            if ~mod(N, 2) == 0
                error('N must be divisible by 2');
            end
            % First create two random orthonormal vectors
            X = orth(randn(N, 2));
            % Then tilt the second one w.r.t. first
            a1 = X(:, 1);
            a2 = X(:, 2);
            p = cos(theta);
            b1 = sqrt(1 - p^2) * a2 + p * a1;
            X = [a1 b1];
            % Find the orthogonal complement of X
            [U S V] = svd(X);
            Y = U(:, 3:end);
            [~, n] = size(Y);
            % Distribute vectors from Y into A and B
            A = [a1 Y(:, 1:n/2)];
            B = [b1 Y(:, n/2 + 1:end)];
        end

        function Y = k_dim_to_n_dim(X, n, indices)
            % Maps the data in K dimensions to N-dimensions.
            [k, d] = size(X);
            if nargin < 2
                error('Target dimension must be specified');
            end
            if n < k
                error('n must be larger than k');
            end
            if nargin < 3
                indices = 1:k;
            end
            if ~isvector(indices)
                error('indices must be a vector.');
            end
            if numel(indices) > k
                error('Number of indices must be k');
            end
            if length(unique(indices))<length(indices)
                error('There must be exactly k unique entries in indices');
            end
            if max(indices) > n || min(indices) < 1
                error('Indices cannot point outside 1:n ');
            end
            Y = zeros(n, d);
            Y(indices, :) = X;
        end


        function [A, B, C] = three_spaces_at_angle(N, theta)
            if ~mod(N, 3) == 0
                error('N must be divisible by 3');
            end
            % First create two random orthonormal vectors
            X = orth(randn(N, 3));
            % Then tilt the second one w.r.t. first
            a1 = X(:, 1);
            a2 = X(:, 2);
            a3 = X(:, 3);
            p = cos(theta);
            % first vector for second space
            b1 = sqrt(1 - p^2) * a2 + p * a1;
            % first vector for third space
            c1_1 = p;
            c1_2 = p * (1 - p) / sqrt(1 - p^2);
            c1_3 = sqrt(1 - c1_1^2 - c1_2^2);
            c1 = c1_1 * a1 + c1_2 * a2 + c1_3 * a3;
            X = [a1 b1 c1];
            % Find the orthogonal complement of X
            [U S V] = svd(X);
            Y = U(:, 4:end);
            [~, n] = size(Y);
            % Distribute vectors from Y into A and B
            A = [a1 Y(:, 1:n/3)];
            B = [b1 Y(:, n/3 + (1:n/3))];
            C = [c1 Y(:, 2*n/3 + (1:n/3))];
        end

        function [A, B, C] = three_disjoint_spaces_at_angle(N, theta)
            X = eye(4);
            R1 = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            a1 = [1 ; 0];
            a2 = R1*a1;
            a3 = R1*a2;
            theta2 = deg2rad(59);
            R2 = [cos(theta2) -sin(theta2); sin(theta2) cos(theta2)];
            b1 = [1 ; 0];
            b2 = R2*b1;
            b3 = R2*b2;
            z = zeros(2, 1);
            A = [a1 z; z b1];
            B = [a2 z; z b2];
            C = [a3 z; z b3];
            A =kron(A , eye(N / 2));
            B =kron(B , eye(N / 2));
            C =kron(C , eye(N / 2));
        end


        function describe_three_spaces(A, B, C)
            % Compute principal angles between the subspaces
            fprintf('Ranks: [A]: %d, [B]: %d, [A]: %d\n', ...
                rank(A), rank(B), rank(C));
            fprintf('Cols: [A]: %d, [B]: %d, [A]: %d\n', ...
                size(A, 2), size(B, 2), size(C, 2));
            fprintf('Ranks: [A B]: %d, [B C]: %d, [A C]: %d, \n', ...
                rank([A B]), rank([B C]), rank([A C]));
            D = [A B C];
            fprintf('Rank [A B C]: %d\n', rank(D));
            fprintf('Angle between A and B: %.4f deg\n', spx.la.spaces.smallest_angle_deg(A, B));
            fprintf('Angle between B and C: %.4f deg\n', spx.la.spaces.smallest_angle_deg(B, C));
            fprintf('Angle between A and C: %.4f deg\n', spx.la.spaces.smallest_angle_deg(A, C));
            fprintf('Column wise norms: \n');
            fprintf(' %.2f', spx.commons.norm.norms_l2_cw(A));
            fprintf('\n');
            fprintf(' %.2f', spx.commons.norm.norms_l2_cw(B));
            fprintf('\n');
            fprintf(' %.2f', spx.commons.norm.norms_l2_cw(C));
            fprintf('\n');
        end

        function [A, B, C] = abc_spaces_junk_1(N, theta)
            if ~mod(N, 2) == 0
                error('N must be divisible by 2');
            end
            d = N / 2;
            % First create three random orthonormal vectors
            X = orth(randn(N, 2));
            % Then tilt the second one w.r.t. first
            a1 = X(:, 1);
            a2 = X(:, 2);
            p = cos(theta);
            % first vector for second space
            b1 = sqrt(1 - p^2) * a2 + p * a1;
            X = [a1 b1];
            % Find the orthogonal complement of X
            [U S V] = svd(X);
            Y = U(:, 3:end);
            [~, n] = size(Y);
            % Distribute vectors from Y into A and B
            A = [a1 Y(:, 1:n/2)];
            B = [b1 Y(:, n/2 + 1:end)];

            % choose a vector a3 which is orthogonal to A and b1
            X = [A B(:, 1:d-1)];
            [U S V] = svd(X);
            a3 = U(:, size(X, 2) + 1);
            % first vector for third space
            c1_1 = p;
            c1_2 = p * (1 - p) / sqrt(1 - p^2);
            c1_3 = sqrt(1 - c1_1^2 - c1_2^2);
            c1 = c1_1 * a1 + c1_2 * a2 + c1_3 * a3;

            X = [A c1];
            % Find the orthogonal complement of X
            [U S V] = svd(X);
            Y = U(:, size(X, 2)+1:end);
            C = [c1 Y];
        end


        function result = have_same_column_spans(A, B)
            % Checks if the column spans of two matrices are same.
            r1 = rank(A);
            r2 = rank(B);
            if r1 ~= r2 
                result = false;
                return;
            end
            r3 = rank([A B]);
            if r3 ~= r1
                result = false;
                return;
            end
            result = true;
        end



    end

end