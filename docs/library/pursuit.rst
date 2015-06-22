Pursuit Algorithms
================================

.. highlight:: matlab





 
Tree/Cluster OMP
--------------------------------------------

::

    solver = SPX_TreeOMP(Dict, K)
    result = solver.solve(Y)




Subspace Clustering Matching Pursuit
-----------------------------------------------------

::

    solver = SPX_SCluMP(Phi, K, options)
    solver.recover(Y)
    solver.cluster(Y)

