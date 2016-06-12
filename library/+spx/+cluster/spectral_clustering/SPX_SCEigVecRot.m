classdef SPX_SCEigVecRot < handle
% Rotation of eigen vectors for detection of number of 
% clusters and identification of clusters in spectral clustering
% Implements identification of rotation matrix in terms of
% a product of Givens rotations. The Givens parameters are estimated
% using stochastic gradient descent.
% see self tuning clustering.

    properties
        % Eigen vectors
        X
        % Eigen values
        S
        MaxClusters = -1
        Debug = false
    end

    properties(SetAccess=private)
        N
        C
        NumRotations
        Is
        Js
        Thetas
        % Current eigen vectors
        XCurr = []
        BestQualities
        Labels
    end

    methods

        function self = SPX_SCEigVecRot(X, S)
            self.X = X;
            self.S = S;
            self.N = size(X, 1);
        end

        function [num_clusters, labels] = estimate_clusters(self)
            % Estimates the number of clusters by analyzing eigen-vectors
            % one by one.
            if self.MaxClusters < 0 || self.MaxClusters > self.N
                singular_values = self.S;
                curve_knee_idx = knee_pt(singular_values);
                self.MaxClusters = length(singular_values) - curve_knee_idx;
                % self.MaxClusters = floor(self.N / 10);
                fprintf('Choosing maximum number of clusters as: %d\n', self.MaxClusters);
            end
            x = self.X;
            n = self.N;
            self.XCurr = x(:, end);
            cur_column = n - 1;
            qualities = [0];
            clusters_for_size = {};
            for c=2:self.MaxClusters
                if self.Debug
                    fprintf('Working with %d vectors\n', c);
                else
                    fprintf('.');
                end
                % add the new eigen vector while keeping the old rotated ones.
                self.XCurr = [x(:, cur_column), self.XCurr];
                % initialize the algorithm for finding out the
                % best rotation for c clusters
                self.init_c_clusters(c);
                % rotate these vectors, estimate quality and assign clusters
                [clusters, quality] = self.search_optimal_rotation(c);
                % maintain quality number for future reference
                qualities = [qualities, quality];
                clusters_for_size{c} = clusters;
                % move on to next eigen vector
                cur_column = cur_column - 1;
            end
            % identify the cluster numbers for which quality was at peak.
            best_qualities = find(max(qualities)-qualities <= 0.001);
            if self.Debug
                fprintf('Best qualities: \n');
                disp(qualities);
            end
            % pick up the largest number of clusters amongst them.
            num_clusters = best_qualities(length(best_qualities));
            if self.Debug
                fprintf('Estimated number of clusters: %d\n', num_clusters);
            end
            % pick the corresponding clustering assignment.
            labels = clusters_for_size{num_clusters};
            self.Labels = labels;
            fprintf('\n');
        end

        function init_c_clusters(self, c)
            % Initializes variables for c clusters
            self.C = c;
            % number of Givens rotations to be computed
            n_rotations  = c * (c -1) / 2;
            self.NumRotations = n_rotations;
            % create memory for storing the angles
            self.Thetas = zeros(1, n_rotations);
            % prepare a mapping from k to (i, j) in Givens rotations
            is = zeros(1, n_rotations);
            js = zeros(1, n_rotations);
            k = 0;
            n = self.N;
            for i=1:c-1
                for j=i+1:c
                    k = k + 1;
                    is(k) = i;
                    js(k) = j;
                end
            end
            self.Is = is;
            self.Js = js;
        end

        function [clusters, quality]  = search_optimal_rotation(self, c)
            % Rotates first c vectors
            n_rotations = self.NumRotations;
            thetas = self.Thetas;
            curr_x = self.XCurr;
            old_quality = SPX_SCEigVecRot.quality(curr_x);
            cur_quality = old_quality;
            if self.Debug
                fprintf('Quality at the beginning: %f\n', cur_quality);
            end
            is = self.Is;
            js = self.Js;
            % number of iterations to try the gradient.
            max_iter = 200;
            alpha  = 0.1;
            trials = 0;
            improvements = 0;
            for iter=1:max_iter
                % iterate over each (i, j) pair for which
                % a Givens rotation will be generated.
                for k=1:n_rotations
                    i = is(k);
                    j = js(k);
                    trials = trials + 1;
                    rot_x_up = SPX_SCEigVecRot.rotate_from_right(curr_x, alpha, i, j);
                    quality_up = SPX_SCEigVecRot.quality(rot_x_up);
                    rot_x_down = SPX_SCEigVecRot.rotate_from_right(curr_x, -alpha, i, j);
                    quality_down = SPX_SCEigVecRot.quality(rot_x_down);
                    if quality_up > cur_quality || quality_down > cur_quality
                        improvements = improvements + 1;
                        % fprintf('Success for: (i, j) = (%d, %d), iter: %d\n', i, j, iter);
                        if quality_up > quality_down
                            thetas(k) = thetas(k) + alpha;
                            cur_quality = quality_up;
                            curr_x = rot_x_up;
                        else
                            thetas(k) = thetas(k) - alpha;
                            cur_quality = quality_down;
                            curr_x = rot_x_down;
                        end
                    end
                end
                if (cur_quality - old_quality) < 1e-3
                    % no updates needed now.
                    break;
                end
                old_quality = cur_quality;
            end
            self.XCurr = curr_x;
            quality = cur_quality;
            if self.Debug
                fprintf('Quality at the end: %f, iterations: %d, trials: %d, successes: %d\n', ...
                    quality, iter, trials, improvements);
            end
            clusters = self.clusters();
        end

        function result = clusters(self)
            % Assigns clusters to each row
            x = self.XCurr;
            y = x.*x;
            [max_values, max_indices] = max(y, [], 2);
            result = max_indices;
        end

        function result = build_u_ab(self, thetas, a, b)
            c = self.C;
            result = eye(c);
            if b < a
                % nothing more to do
                return;
            end
            is = self.Is;
            js = self.Js;
            for k=a:b
                % iterate over the angles
                theta = thetas(k);
                c = cos(theta);
                s = sin(theta);
                % Create a Givens rotation matrix for this theta.
                G = [c -s; s c];
                % Identify the columns which will be affected.
                i = is(k);
                j = js(k);
                % Apply the Givens matrix to the result from right.
                % Thus modify i-th and j-th columns.
                result(:, [i, j]) = result(:, [i, j]) * G;
            end
        end


    end

    methods(Static)
        function G = givens_rot_mat(theta)
            c = cos(theta);
            s = sin(theta);
            G = [c -s; s c];
        end

        function GV = givens_rot_mat_grad(theta)
            c = cos(theta);
            s = sin(theta);
            GV = [-s -c; c -s];
        end

        function X = rotate_from_right(X, theta, i, j)
            c = cos(theta);
            s = sin(theta);
            X(:, [i, j]) =  X(:, [i, j]) * [c -s; s c];
        end

        function result = cost(X)
            % Evaluates the cost of a given matrix
            % Minimum value of cost is n. 
            % This occurs when each row has exactly one non-zero entry. 
            % Then each row contributes 1 to total cost.
            % maximum cost is c*n. This occurs when all entries in X(:, 1:c)
            % are equal. 
            y = X.*X;
            [max_values, max_indices] = max(y, [], 2);
            % avoid zero division
            max_values(max_values == 0) = 1;
            % divide rows of y by maximum values
            y = bsxfun(@rdivide, y, max_values);
            % compute the overall cost
            result = sum(sum(y));
        end

        function result = quality(X)
            % Computes the quality of rotation
            % When the cost is minimum, the quality is maximum = 1.0.
            % When the cost is maximum (c n), then quality is 1 / c.
            cur_cost = SPX_SCEigVecRot.cost(X);
            [n, c] = size(X);
            result = 1.0 - ((cur_cost / n)  - 1.0) / c;
        end


    end


end
