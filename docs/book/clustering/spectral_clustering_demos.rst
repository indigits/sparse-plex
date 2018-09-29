Hands-on spectral clustering
======================================

.. highlight:: matlab

.. example:: Clustering rings

    In this example, we will cluster 2D data
    which form three different rings in
    the plane.

    Sample data is available in the `data` directory.


    Let us load the data::

        dataset_file = fullfile(spx.data_dir, 'clustering', ...
            'self_tuning_paper_clustering_data');
        data = load(dataset_file);
        datasets = data.XX;
        raw_data = datasets{1};
        num_clusters = data.group_num(1);

    The raw data is organized in a matrix where
    each row represents one 2D point. Number of
    data points is the number of rows in the dataset.
    Let's plot the data to get a better understanding::

        X = raw_data(:, 1);
        Y = raw_data(:, 2);
        figure;
        axis equal;
        plot(X, Y, '.', 'MarkerSize',16);

    .. figure:: images/demo_sc_1_unscaled.png

    We can see that the data is organized in three
    different rings. This data set is unlikely to 
    be clustered properly by K-means algorithm.

    It is good practice to scale the data before
    clustering it::

        raw_data = raw_data - repmat(mean(raw_data),size(raw_data,1),1);
        raw_data = raw_data/max(max(abs(raw_data)));
        X = raw_data(:, 1);
        Y = raw_data(:, 2);
        figure;
        axis equal;
        plot(X, Y, '.', 'MarkerSize',16);

    .. figure:: images/demo_sc_1_scaled.png


    The next step is to compute pairwise distances 
    between the points in the dataset::

        sqrt_dist_mat = spx.commons.distance.sqrd_l2_distances_rw(raw_data);

    We convert the distances into a Gaussian 
    similarity. To compute the similarity, we will
    need to provide the scale value::

        scale = 0.04;
        % Compute the similarity matrix
        sim_mat = spx.cluster.similarity.gauss_sim_from_sqrd_dist_mat(sqrt_dist_mat, scale);

    We are now ready to perform spectral clustering on the data. 

    Create the spectral clustering algorithm instance::

        clusterer = spx.cluster.spectral.Clustering(sim_mat);

    Inform it about the expected number of clusters::

        clusterer.NumClusters = num_clusters;

    There are two different spectral clustering 
    algorithms available. We will use the random walk 
    version::

        cluster_labels = clusterer.cluster_random_walk();

    We can summarize the results of clustering::

        >> tabulate(cluster_labels)
          Value    Count   Percent
              1       99     33.11%
              2      139     46.49%
              3       61     20.40%


    Let's plot the data points in different colors
    depending on which cluster they belong to::

        figure;
        colors = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0];
        hold on;
        axis equal;
        for c=1:num_clusters
            % Identify points in this cluster
            points = raw_data(cluster_labels == c, :);
            X = points(:, 1);
            Y = points(:, 2);
            plot(X, Y, '.','Color',colors(c,:), 'MarkerSize',16);
        end

    .. figure:: images/demo_sc_1_clustered.png

    Complete example code can be downloaded
    :download:`here <demo_spectral_clustering_1.m>`.