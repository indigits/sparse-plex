
.. _sec:handson:cluster:comparing:clusterings:

Comparing Clusterings
==============================

In :ref:`sec:clustering:performance:measure:intro`,
we looked at the theoretical aspects of comparing
two different clusterings. 

In this section, we will learn the tools available
in `sparse-plex` library for comparing clusterings.


.. example::

    In this example, we will consider a set of
    14 objects which are clustered into 4 different
    clusters by two different algorithms,
    algorithm A and B. Algorithm A could be
    human annotations themselves, in which case
    the labels are the ground truth against which
    we will compare the results of B.

    We assume that the number of clusters is known
    in advance to be 4 and the two algorithms are 
    generating the labels 1, 2, 3, 4.

    The algorithm A outputs following labels::

        A  = [2 1 3 2 4 2 1 1 1 1 4 3 3 3];

    It puts 5 objects into cluster 1, 3 into cluster 2,
    4 into cluster 3, and 2 in cluster 4.


    The algorithm B outputs following labels::

        B  = [4 2 3 4 2 4 2 2 3 2 1 3 3 3];


    It puts only 1 object in cluster 1, 5 in
    cluster 2, 5 in cluster 3 and 3 in cluster 4.

    An easy way to determine this is the `tabulate`
    function::

        >> tabulate(A)
          Value    Count   Percent
              1        5     35.71%
              2        3     21.43%
              3        4     28.57%
              4        2     14.29%


    By inspection, we can see that the two 
    algorithms are assigning different
    labels in most cases. 

    We need to figure out the label mapping
    between two clusters.  
    It describes how the labels between
    two clusterings are related to each
    other. e.g. when A assigns a label 1
    to some object, what is the most likely
    label assigned by B.

    `sparse-plex` provides a cluster 
    comparison tool::

        >> cc = spx.cluster.ClusterComparison(A, B);


    In order to compare the two clusterings,
    the first tool is the confusion matrix::

        >> cm = cc.confusionMatrix(); cm

        cm =

             0     4     1     0
             0     0     0     3
             0     0     4     0
             1     1     0     0

    In the confusion matrix, the rows 
    represent the labels assigned by A 
    and columns represent the labels assigned by B.

    e.g. for the 5 objects assigned to cluster 1
    by A, 4 of them were assigned to cluster 2
    by B and 1 was assigned to cluster 3 by B.

    Confusion matrix is a very useful tool
    to identify label mapping. In this case,
    cluster 1 of algorithm A and 
    cluster 2 of algorithm B are likely to be
    similar.


    From :ref:`sec:clustering:performance:measure:intro`,
    we would like to get the precision,
    recall and f1-measure numbers between
    the two clusterings. 

    ``ClusterComparison`` provides a method
    to get all of these metrics::

        >> fm = cc.fMeasure();
        >> fm.precisionMatrix

        ans =

                 0    0.8000    0.2000         0
                 0         0         0    1.0000
                 0         0    0.8000         0
            1.0000    0.2000         0         0

        >> fm.recallMatrix

        ans =

                 0    0.8000    0.2000         0
                 0         0         0    1.0000
                 0         0    1.0000         0
            0.5000    0.5000         0         0

        >> fm.fMatrix

        ans =

                 0    0.8000    0.2000         0
                 0         0         0    1.0000
                 0         0    0.8889         0
            0.6667    0.2857         0         0

        >> fm.precision

        ans =

            0.8571

        >> fm.recall

        ans =

            0.8571

        >> fm.fMeasure

        ans =

            0.8492

    A label map is also computed using the
    f1 matrix::

        >> fm.labelMap'

        ans =

             2     4     3     1

    The map suggests a mapping from 
    labels of A to labels of B as 
    follows: 1->2, 2->4, 3->3, 4->1.

    It also provides you the new B labels
    after remapping::

        >> fm.remappedLabels'

        ans =

             2     1     3     2     1     2     1     1     3     1     4     3     3     3


    We can look at the number of places the
    remapped labels of B differ from the original A labels::

        >> fm.remappedLabels' ~= A

        ans =

          1×14 logical array

           0   0   0   0   1   0   0   0   1   0   0   0   0   0

    We see that after remapping of labels, A and B differ 
    in only 2 places. The clustering done by B is actually
    very close to the clustering done by A.

    The ``ClusterComparison`` class provides a helpful
    method for printing the results in ``fm`` object::

        >> spx.cluster.ClusterComparison.printF1MeasureResult(fm)
        F1-measure: 0.85, Precision: 0.86, Recall: 0.86, Misclassification rate: 0.14, Clusters: A: 4, B: 4, Clustering ratio: 1.00
        Label map: 
        1=>2, 2=>4, 3=>3, 4=>1,     


Label mapping using Hungarian method
----------------------------------------

Label mapping is essentially an assignment problem.
We want to assign labels by the two different
algorithms in such a way that the clustering
error is minimized.

The Hungarian algorithm is used in assignment problems
when we want to minimize cost.

``sparse-plex`` includes an implementation of
hungarian mapping by Niclas Borlin. 


.. example::

    We can perform the assignment as follows::

        >> C = bestMap(A, B)'; C

        ans =

             2 1 3 2 1 2 1 1 3 1 4 3 3 3

        >> C ~= A

        ans =

          1×14 logical array

           0   0   0   0   1   0   0   0   1   0   0   0   0   0

    In this case the mapping given by Hungarian method
    is same as mapping generated by :math:`f_1` measure method.
    Sometimes, it is not so.


The ``bestMap`` method is easy to use.


.. _sec:clustering:clustering-error:

Clustering Error
-----------------------

If two clusterings have same number of labels, then 
a simpler clustering error metric is quite useful.

We start with an example set of true labels A
and estimated labels B::

    A  = [2 1 3 2 4 2 1 1 1 1 4 3 3 3];
    B  = [4 2 3 4 2 4 2 2 3 2 1 3 3 3];


Total number of labels::

    num_labels = numel(A);
    num_labels =

        14


Let's use the Hungarian mapping technique to find the mapping
of labels between A and B::

    mapped_B = bestMap(A, B)'
    mapped_B =

         2 1 3 2 1 2 1 1 3 1 4 3 3 3

After this mapping, the mapped B labels are looking
pretty much like A. The difference between these two
labels is where the algorithm has made some mistakes::

    mistakes =

      1×14 logical array

       0   0   0   0   1   0   0   0   1   0   0   0   0   0


Total number of mistakes::

    num_mistakes = sum(mistakes)
    num_mistakes =

         2

Clustering error is nothing but the ratio of mistakes made
and total number of data points::

    clustering_error  = num_mistakes / num_labels
    clustering_error =

        0.1429

In percentage::

    clustering_error_perc = clustering_error * 100
    clustering_error_perc =

       14.2857


Accuracy can be computed from error::

    clustering_acc_perc = 100 -clustering_error_perc


Sparse-Plex provides a function which does 
all of this together::

    >> spx.cluster.clustering_error_hungarian_mapping(A, B)

    ans = 

      struct with fields:

               num_labels: 14
        num_missed_points: 2
                    error: 0.1429
               error_perc: 14.2857
            mapped_labels: [2 1 3 2 1 2 1 1 3 1 4 3 3 3]
                   misses: [0 0 0 0 1 0 0 0 1 0 0 0 0 0]


