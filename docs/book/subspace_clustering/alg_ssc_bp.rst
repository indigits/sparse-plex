SSC by Basis Pursuit
============================

.. highlight:: matlab


.. contents::
    :local:



Hands-on SSC-BP with Synthetic Data
---------------------------------------

In this example, we will select a set of random subspaces
in an ambient space and pick random points within those
subspaces. We will make the data noisy and then
use sparse subspace clustering by basis pursuit to solve the
clustering problem.

Configure the random number generator for repeatability of experiment::

    rng default;


Let's choose the ambient space dimension::

    M = 50;

The number of subspaces to be drawn in this ambient space::

    K = 10;

Dimension of each of the subspaces::

    D = 20;


Choose random subspaces (by choosing bases for them)::

    bases = spx.data.synthetic.subspaces.random_subspaces(M, K, D);

See :ref:`sec:sc:synthetic:random-subspaces` for details.

Compute the smallest principal angles between them::

    >> angles_matrix = spx.la.spaces.smallest_angles_deg(bases)
    angles_matrix =

             0   13.7806   21.2449   12.6763   18.2977   14.5865   19.0584   14.1622   20.4491   15.9609
       13.7806         0   12.7650   14.3358   15.5764   12.5790   18.1699   14.8446   19.3907   13.2812
       21.2449   12.7650         0   14.7511   13.2121   10.7509   16.1944   11.7819   15.3850   19.7930
       12.6763   14.3358   14.7511         0   14.1313   15.6603   14.1016   13.4738   13.1950   19.8852
       18.2977   15.5764   13.2121   14.1313         0   13.1154   18.3977   15.4241   12.2688   16.7764
       14.5865   12.5790   10.7509   15.6603   13.1154         0    7.6558   13.6178   13.3462   10.5027
       19.0584   18.1699   16.1944   14.1016   18.3977    7.6558         0   12.6955   13.8088   17.2580
       14.1622   14.8446   11.7819   13.4738   15.4241   13.6178   12.6955         0   13.8851   17.1396
       20.4491   19.3907   15.3850   13.1950   12.2688   13.3462   13.8088   13.8851         0    8.4910
       15.9609   13.2812   19.7930   19.8852   16.7764   10.5027   17.2580   17.1396    8.4910         0

See :ref:`sec:la:principal_angles:hands-on` for details.

Let's quickly look at the minimum angle between any of the pairs
of subspaces::

    >> angles = spx.matrix.off_diag_upper_tri_elements(angles_matrix)';
    >> min(angles)
    ans =

        7.6558

Some of the subspaces are indeed very closely aligned.

Let's choose the number of points we will draw for each subspace::

    >> Sk = 4 * D

    Sk =

        80



Number of points that will be drawn in each subspace::

    cluster_sizes = Sk * ones(1, K);

Total number of points to be drawn::

    S = sum(cluster_sizes);

Let's generate these points on the unit sphere in each subspace::

    points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
    X0 = points_result.X;

See :ref:`sec:sc:synthetic:uniform-points-subspaces` for more details.

Let's add some noise to the data points::

    % noise level
    sigma = 0.5;
    % Generate noise
    Noise = sigma * spx.data.synthetic.uniform(M, S);
    % Add noise to signal
    X = X0 + Noise;

See :ref:`sec:sc:synthetic:uniform-points` for
the ``spx.data.synthetic.uniform`` function details.

Let's normalize the noisy data points::

    X = spx.norm.normalize_l2(X); 


Let's create true labels for each of the data points::

    true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);

See :ref:`sec:clustering:utility-functions` for 
``labels_from_cluster_sizes`` function.

It is time to apply the sparse subspace clustering 
algorithm. There are following steps involved:

#. Compute the sparse representations using basis pursuit.
#. Convert the representations into a Graph adjacency matrix.
#. Apply spectral clustering on the adjacency matrix.

.. rubric:: Basis Pursuit based Representation Computation

Let's allocate storage for storing the representation 
of each point in terms of other points::

    Z = zeros(S, S);

Note that there are exactly S points and each has
to have a representation in terms of others. The
diagonal elements of Z must be zero since a data
point cannot participate in its own representation.

We will use CVX to construct the sparse representation
of each point in terms of other points using basis pursuit::

    start_time = tic;
    fprintf('Processing %d signals\n', S);
    for s=1:S
        fprintf('.');
        if (mod(s, 50) == 0)
            fprintf('\n');
        end
        x = X(:, s);
        cvx_begin
        % storage for  l1 solver
        variable z(S, 1);
        minimize norm(z, 1)
        subject to
        x == X*z;
        z(s) == 0;
        cvx_end
        Z(:, s)  = z;
    end
    elapsed_time  = toc(start_time);
    fprintf('\n Time spent: %.2f seconds\n', elapsed_time);


The constraint ``x == X*z`` is forcing each
data point to be represented in terms of other 
data points.

The constraint ``z(s) == 0`` ensures that a
data point cannot participate in its own
representation. In other words, the diagonal 
elements of the matrix Z are forced to be zero.

The output of this loop looks like::

    Processing 800 signals
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................
    ..................................................

     Time spent: 313.70 seconds

CVX based basis pursuit is indeed a slow algorithm.

.. rubric:: Graph adjacency matrix

The sparse representation matrix Z is not symmetric. 
Also, the sparse representation coefficients are not
always positive. 

We need to make it symmetric and positive so that
it can be used as an adjacency matrix of a graph::

    W = abs(Z) + abs(Z).';

.. rubric:: Spectral Clustering

See :ref:`clustering-handson-spectral-clustering` about
detailed intro to spectral clustering.

We can now apply spectral clustering on this matrix.
We will choose normalized symmetric spectral clustering::

    clustering_result = spx.cluster.spectral.simple.normalized_symmetric(W);


The labels assigned by the clustering algorithms::

    cluster_labels = clustering_result.labels;

.. rubric:: Performance of the Algorithm

Time to compare the clusterings and measure clustering
accuracy and error. We will use the Hungarian mapping
trick to map between original cluster labels and
estimated cluster labels by clustering algorithm::

    comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);


See :ref:`sec:clustering:clustering-error` for Hungarian 
mapping based clustering error.

The clustering accuracy and error::

    clustering_error_perc = comparsion_result.error_perc;
    clustering_acc_perc = 100 - comparsion_result.error_perc;

Let's print it::

    >> fprintf('\nclustering error: %0.2f %%, clustering accuracy: %0.2f %% \n'...
        , clustering_error_perc, clustering_acc_perc);
    clustering error: 7.00 %, clustering accuracy: 93.00 % 


We have achieved pretty good accuracy despite very closely
aligned subspaces and significant amount of noise.

.. rubric:: Subspace Preserving Representations 

Let's also get the subspace preserving representation 
statistics::

    spr_stats = spx.cluster.subspace.subspace_preservation_stats(Z, cluster_sizes);
    spr_error = spr_stats.spr_error;
    spr_flag = spr_stats.spr_flag;
    spr_perc = spr_stats.spr_perc;


See :ref:`sec:sc:ssc:performance_metrics` for more details.

Print it::

    >> fprintf('mean spr error: %0.2f, preserving : %0.2f %%\n', spr_stats.spr_error, spr_stats.spr_perc);
    mean spr error: 0.68, preserving : 0.00 %

Complete example code can be downloaded
:download:`here <demo_ssc_bp_random_subspaces.m>`.

.. disqus::

