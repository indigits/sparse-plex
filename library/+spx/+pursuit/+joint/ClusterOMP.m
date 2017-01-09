classdef ClusterOMP < handle

    properties
        % Maximum number of iterations for approximation
        MaxIters
    end

    properties(SetAccess=private)
        % The dictionary
        Dict
        % Ambient signal dimensions
        N
        % Number of atoms in dictionary
        D
        % Sparsity level of representations (may be negative)
        K
    end

    methods
        function self  = ClusterOMP(Dict, K)
            % We assume that all the columns in dictionary are normalized.
            if isa(Dict, 'spx.dict.Operator')
                self.Dict = Dict;
            elseif ismatrix(Dict)
                self.Dict = spx.dict.MatrixOperator(Dict); 
            else
                error('Unsupported operator.');
            end
            [self.N, self.D] = size(Dict);
            if nargin < 2
                K = -1;
            end
            self.K = K;
            % Maximum number of iterations
            maxIter = self.N;
            if K > 0
                % We have to consider pre-specified sparsity level
                maxIter = K;
            end
            self.MaxIters = maxIter;
        end


        function result  = solve(self,Y)
            % Solves approximation problem using OMP
            d = self.D;
            n = self.N;
            [n2, ns] = size(Y);
            if n2 ~= n
                error('Y dimensions incorrect.');
            end
            R = Y;
            dict = self.Dict;
            maxIter = self.MaxIters;
            % initially there is one cluster
            num_clusters = 1;
            % number of clusters holding only one entry
            num_singletons = 0;
            % Estimate
            Z = zeros(d, ns);
            % all signals belong to same cluster
            labels = ones(1, ns);
            % the support is empty.
            supports = [];
            % number of entries in a cluster
            cluster_sizes = [];
            support_merger_time = 0;
            % reset warnings
            lastwarn('');
            y_frob_norm = norm(Y, 'fro');
            % Statistics for different iterations
            stats.avg_cluster_sizes = zeros(1, maxIter);
            % Average size of non-singleton clusters
            stats.avg_ns_cluster_sizes = zeros(1, maxIter);
            stats.std_ns_cluster_sizes = zeros(1, maxIter);
            stats.num_clusters = zeros(1, maxIter);
            stats.residual_frob_norms = zeros(1, maxIter);
            stats.num_singletons  = zeros(1, maxIter);
            for k=1:maxIter
                fprintf('.');
                % identification of new atoms for singleton clusters
                if num_singletons > 0
                    % identify the signals corresponding to singleton clusters
                    singleton_signal_indices = find(labels <= num_singletons);
                    % Corresponding residuals
                    singleton_residuals = R(:, singleton_signal_indices);
                    % Inner products with all dictionary atoms
                    products = dict.apply_ctranspose(singleton_residuals);
                    % Their absolute values
                    abs_products = abs(products);
                    % find out largest contributing atoms
                    [~, singleton_new_atoms] = max(abs_products);
                    % remap the new atoms to corresponding clusters
                    singleton_new_atoms(labels(singleton_label_indices)) = singleton_new_atoms;
                end

                new_atoms = cell(1, num_clusters);
                new_labels = cell(1, num_clusters);
                % total new clusters identified for non-singleton clusters
                total_new_clusters = 0;
                % iterate over existing non-singleton clusters
                for c=(num_singletons+1):num_clusters
                    % The signal numbers belonging to this cluster
                    cluster_signal_indices = labels == c;
                    % Corresponding residuals
                    cluster_residuals = R(:, cluster_signal_indices);
                    % Inner products with all dictionary atoms
                    products = dict.apply_ctranspose(cluster_residuals);
                    % Their absolute values
                    abs_products = abs(products);
                    % find out largest contributing atoms
                    [~, atoms] = max(abs_products);
                    % identify unique atoms for new sub-clusters
                    [cur_new_atoms, ~, cur_new_labels] = unique(atoms);
                    % store the new atoms
                    new_atoms{c} = cur_new_atoms;
                    % store the sub-cluster labels for each signal in the cluster
                    new_labels{c} = cur_new_labels;
                    % Update the counter for total new clusters
                    total_new_clusters = total_new_clusters + length(cur_new_atoms);
                end
                % Now define supports for all the clusters created so far
                % this includes the older singleton clusters and new subclusters 
                next_supports = zeros(num_singletons+total_new_clusters, k);
                % Copy older labels to new labels. 
                % This ensures that labels are copied ditto for singleton clusters
                next_labels = labels;
                if k == 1
                    % we are defining first level supports for each cluster
                    next_supports(:, end) = new_atoms{1};
                    next_labels =  new_labels{1};
                else

                    % update supports for singleton clusters
                    if num_singletons > 0
                        % Copy support for older singleton clusters
                        next_supports(1:num_singletons, 1:k-1)  = supports(1:num_singletons,:);
                        next_supports(1:num_singletons, end)  = singleton_new_atoms;
                    end

                    % we work cluster by cluster

                    % Now work cluster by cluster for introducing new subclusters and
                    % their supports
                    % The subcluster labels within a cluster will start after this index.
                    cluster_start = num_singletons;
                    % we only need to process non-singleton clusters here.
                    for c=(num_singletons+1):num_clusters
                        cur_new_atoms = new_atoms{c};
                        cur_new_labels = new_labels{c};
                        % signal numbers in this cluster
                        cluster_signal_indices = labels == c;
                        % number of new subclusters introduced
                        num_new_clusters = length(cur_new_atoms);
                        % pick the current support for this cluster
                        cur_support = supports(c,:);
                        % replicate it over supports for new subclusters
                        rows = (1:num_new_clusters) + cluster_start;
                        next_supports(rows, 1:k-1) = repmat(cur_support, num_new_clusters, 1);
                        % add the new atom for each subcluster in the corresponding support
                        next_supports(rows, end) = cur_new_atoms;
                        % update the labels of signals in this cluster with the
                        % subcluster labels
                        next_labels(cluster_signal_indices) = cur_new_labels + cluster_start;
                        % prepare the cluster start for the subclusters of next cluster
                        cluster_start = cluster_start + num_new_clusters;
                    end
                end
                % update clustering information
                supports = next_supports;
                labels = next_labels;
                num_clusters = total_new_clusters + num_singletons;


                %%  perform merging of clusters
                if k> 1 % && mod(k, 4) == 0
                    tmerger = tic;
                    % sort the supports for each cluster
                    supports = sort(supports, 2);
                    [supports,ia,ic] = unique(supports,'rows');
                    new_labels = zeros(1, ns);
                    for c=1:num_clusters
                        new_c = ic(c);
                        new_labels(labels == c) = new_c;
                    end
                    labels = new_labels;
                    num_clusters = size(supports, 1);
                    support_merger_time = support_merger_time + toc(tmerger);
                end

                %% sort clusters by their sizes

                cluster_sizes = histc(labels, 1:num_clusters);
                % sort the clusters as per sizes
                [cluster_sizes, sorted_indices] = sort(cluster_sizes);
                % relabel clusters
                label_map = zeros(1, num_clusters);
                label_map(sorted_indices) = 1:num_clusters;
                for s=1:ns
                    cur_label = labels(s);
                    labels(s) = label_map(cur_label);
                end
                supports = supports(sorted_indices, :);
                % Now find out singleton clusters in the whole set of new clusters.
                tmp = find(cluster_sizes > 1, 1);
                if  isempty(tmp)
                    num_singletons = num_clusters;
                else
                    num_singletons = tmp  - 1;
                end
                % Uncomment following line to enable singleton handling.
                % num_singletons = 0;
                if num_singletons > 0
                    % perform residual update of singleton clusters individually
                    % identify the signals corresponding to singleton clusters
                    singleton_label_indices = find(labels <= num_singletons);
                    for l=1:num_singletons
                        % signal index
                        s = singleton_label_indices(l);
                        % cluster index
                        c = labels(s);
                        assert (c <= num_singletons);
                        signal = Y(:, s);
                        % support
                        signal_support = supports(c, :);
                        % Solve least squares problem
                        subdict = dict.columns(signal_support);
                        tmp = linsolve(subdict, signal);
                        [msg, msg_id] = lastwarn;
                        %if strcmp(msg_id, 'MATLAB:rankDeficientMatrix')
                        %    lastwarn('');
                        %    fprintf('Warning during singleton processing.\n');
                        %    signal_support
                        %end
                        Z(signal_support, s) = tmp;
                        R(:, s) = signal - subdict * tmp;
                    end
                end
                % perform simultaneous residual update of each non-singleton cluster
                for c=(num_singletons+1):num_clusters
                    cluster_signal_indices = labels == c;
                    cluster_signals = Y(:, cluster_signal_indices);
                    cluster_support = supports(c, :);
                    % Solve least squares problem
                    subdict = dict.columns(cluster_support);
                    tmp = linsolve(subdict, cluster_signals);
                    Z(cluster_support, cluster_signal_indices) = tmp;
                    % Update residuals for this cluster
                    R(:, cluster_signal_indices) = cluster_signals - subdict * tmp;
                end
                res_norms = spx.commons.norm.norms_l2_cw(R);
                stats.avg_cluster_sizes(k) =  mean(cluster_sizes);
                non_singleton_sizes = cluster_sizes(num_singletons+1:end);
                if ~isempty(non_singleton_sizes)
                    stats.avg_ns_cluster_sizes(k) = mean(non_singleton_sizes);
                    stats.std_ns_cluster_sizes(k) = std(non_singleton_sizes);
                end
                stats.num_clusters(k) = num_clusters;
                r_norm = norm(R, 'fro');
                stats.residual_frob_norms(k) = r_norm;
                stats.num_singletons(k)  = num_singletons;
            end
            fprintf('\n');
            result.supports = supports;
            result.labels = labels;
            result.num_clusters = num_clusters;
            result.cluster_sizes = cluster_sizes;
            result.num_singletons = num_singletons;
            result.support_merger_time = support_merger_time;
            result.Z = Z;
            result.stats = stats;
        end
    end
end

