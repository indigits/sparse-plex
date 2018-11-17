classdef SSC_OMP < handle
    % Implements sparse subspace clustering algorithm using OMP algorithm
    properties
        Quiet = false
        RepresentationMethod
        % Options to be passed on to the solver which is computing the representations
        RepSolverOptions = struct
    end


    properties(SetAccess=private)
        % Dimension of signal space
        N
        % Number of signals in the space
        S
        % A matrix of size NxS where each column is one signal vector
        Data
        % The sparsity level or the largest dimension of the sparse subspaces
        K
        % The expected number of subspaces
        NumSubspaces
        % Labels obtained through clustering
        Labels
        % Representation matrix (each column is a representation vector for one data vector)
        Representation
        % Adjacency matrix
        Adjacency
        % The spectral clusterer used in the algorithm
        Clusterer
        % Threshold for residual norm
        ResidualNormThreshold
        % Number of iterations for each vector
        Iterations
    end

    methods
        function self = SSC_OMP(X, K, NumSubspaces, ...
            ResidualNormThreshold, RepresentationMethod)
            % Constructor
            self.Data = X;
            self.K = K;
            if nargin < 3
                NumSubspaces = -1;
            end
            self.NumSubspaces = NumSubspaces;
            if nargin < 4
                ResidualNormThreshold = 1e-3;
            end
            self.ResidualNormThreshold = ResidualNormThreshold;
            if nargin < 5
                RepresentationMethod = spx.cluster.ssc.OMP_REPR_METHOD.FLIPPED_OMP_MATLAB;
            end
            self.RepresentationMethod = RepresentationMethod;
            [n, s] = size(X);
            self.N = n;
            self.S = s;
            self.Labels = ones(s, 1);
            % Each data vector is represented using other data vectors in same space
            self.Representation = zeros(s, s);
        end

        function result = solve(self)
            % prepare sparse representations
            tstart = tic;
            self.recover_coefficients();
            representation_time = toc(tstart);
            self.build_adjacency();

            % conduct spectral clustering
            tstart = tic;
            result = spx.cluster.spectral.simple.normalized_symmetric_sparse(self.Adjacency, self.NumSubspaces);
            cluster_labels = result.labels;
            result.clustering_time = toc(tstart);
            % We are disabling our version of spectral clustering for now.            
            % clusterer = spx.cluster.spectral.Clustering(self.Adjacency);
            % keep reference for debugging purposes.
            % self.Clusterer = clusterer;
            % clusterer.NumClusters = self.NumSubspaces;
            % cluster_labels = clusterer.cluster_random_walk();            
            self.Labels = cluster_labels;
            result.Labels = self.Labels;
            result.Z = self.Representation;
            result.W = self.Adjacency;
            result.representation_time = representation_time;
        end

    end

    methods(Access=private)

        function recover_coefficients(self)
            % Computes sparse representations of the data vectors
            data_matrix = self.Data;
            % Number of data vectors
            ns = self.S;
            % sparsity level
            nk = self.K;
            quiet = self.Quiet;
            rnorm_thr = self.ResidualNormThreshold;

            if self.RepresentationMethod.isClassicOMP_C()
                % Classic OMP C version
                C = spx.fast.omp_spr(data_matrix, nk, rnorm_thr);
                self.Representation = C;
            elseif self.RepresentationMethod.isBatchOMP_C()
                % Batch OMP C version
                C = spx.fast.batch_omp_spr(data_matrix, nk, rnorm_thr);
                self.Representation = C;
            elseif self.RepresentationMethod.isFlippedOMP_MATLAB()
                % flipped OMP MATLAB version
                [representations, iterations] = spx.cluster.ssc.flipped_omp(...
                    data_matrix, nk, rnorm_thr, quiet);
                self.Representation = representations;
                self.Iterations = iterations;
            elseif self.RepresentationMethod.isBatchFlippedOMP_MATLAB()
                C = spx.cluster.ssc.batch_flipped_omp(data_matrix, nk, rnorm_thr, quiet);
                self.Representation = C;
            elseif self.RepresentationMethod.isBatchFlippedOMP_C()
                C = spx.fast.batch_flipped_omp_spr(data_matrix, nk, rnorm_thr);
                self.Representation = C;
            elseif self.RepresentationMethod.isGOMP_C()
                nl  = 2;
                options.verbose = 0;
                C = spx.fast.gomp_spr(data_matrix, nk, nl, rnorm_thr, options);
                self.Representation = C;
            elseif self.RepresentationMethod.isMC_OMP()
                options = self.RepSolverOptions;
                options.quiet = quiet;
                C = spx.cluster.ssc.mc_omp(...
                    data_matrix, nk, rnorm_thr, options);
                self.Representation = C;
            else
                error('Invalid representation method.');
            end
            if ~quiet 
                fprintf('\n');
            end
        end

        function detect_outliers(self)
            % Identifies outliers in the representations
        end

        function build_adjacency(self)
            C = abs(self.Representation);
            % Normalize the matrix by column wise maximums
            C = spx.norm.normalize_linf(C);
            % disp(C(:, 1));
            % Make it symmetric
            C = C + C';
            % Keep it
            self.Adjacency = C;
            % disp(self.Adjacency(:, 1));
        end

    end

end

