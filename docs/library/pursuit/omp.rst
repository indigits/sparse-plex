Orthogonal matching pursuit
===================================

.. highlight:: matlab


Constructing the solver with dictionary and expected sparsity level::


    solver  = SPX_OrthogonalMatchingPursuit(Dict, K)


Using the solver to obtain the sparse representation of one vector::

    result = solver.solve(y)

There are several ways of solving the least squares problem 
which is an intermediate step in the orthogonal matching pursuit
algorithm. Some of these are described below.

Using the solver to obtain the sparse representation of one vector
with incremental QR decomposition of the subdictionary
for the least squares step::


    result = solver.solve_qr(y)

Using the solver to obtain the sparse representations of all vectors
in the signal matrix Y independently::

    result = solver.solve_all(Y)


Using the solver to obtain the sparse representations of all vectors
in the signal matrix Y independently using the ``linsolve`` method
for least squares::

    result = solver.solve_all_linsolve(Y)


