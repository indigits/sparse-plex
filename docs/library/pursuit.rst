Pursuit Algorithms
================================

.. highlight:: matlab




CoSaMP
---------

::

    solver = CS_CoSaMP(Dict, K)
    result = solver.solve(y)
    result = solver.solve_all(Y)

MP
-------

::

    solver = CS_MatchingPursuit(Dict, K)
    result = solver.solve(y)
    result = solver.solve_all(Y)


OMP
------

::

    solver  = CS_OMPApprox(Dict, K)
    result = solver.solve(y)
    result = solver.solve_qr(y)
    result = solver.solveAll(Y)
    result = solver.solve_all_linsolve(Y)

L1
----------------


::

    solver = CS_L1SparseRecovery(A, B)
    result = solver.solve_lasso(lambda)
    result = solver.solve_lasso()
    result = solver.solve_l1_exact()
    result = solver.solve_l1_noise()



Tree/Cluster OMP
--------------------------------------------

::

    solver = CS_TreeOMP(Dict, K)
    result = solver.solve(Y)




Subspace Clustering Matching Pursuit
-----------------------------------------------------

::

    solver = CS_SCluMP(Phi, K, options)
    solver.recover(Y)
    solver.cluster(Y)

