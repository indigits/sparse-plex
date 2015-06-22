Compressive sampling matching pursuit
==============================================

.. highlight:: matlab



Constructing the solver with dictionary and expected sparsity level::

    solver = SPX_CoSaMP(Dict, K)


Using the solver to obtain the sparse representation of one vector::

    result = solver.solve(y)

Using the solver to obtain the sparse representations of all vectors
in the signal matrix Y independently::

    result = solver.solve_all(Y)
