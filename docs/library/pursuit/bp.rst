Basis pursuit and its variations
==========================================

.. highlight:: matlab


Basis pursuit is a way of solving the sparse recovery
problem via :math:`\ell_1` minimization. We provide
multiple implementations for different variations of
the problem. 

.. note::

    These algorithms are dependent on the CVX toolbox.
    Please make sure to install them before using
    the algorithms.


Constructing the solver with dictionary and set of
signals to be solved arranged in a signal matrix::

    solver = spx.pursuit.single.BasisPursuit(Dict, Y)


Solving using LASSO method::

    result = solver.solve_lasso(lambda)
    result = solver.solve_lasso()


Solving using  :math:`\ell_1` minimization assuming that
signals are exact sparse::

    result = solver.solve_l1_exact()

Solving using  :math:`\ell_1` minimization assuming that
signals are noisy::

    result = solver.solve_l1_noise()


