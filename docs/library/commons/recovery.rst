Sparse recovery
===============================

.. highlight:: matlab

Estimate for the required number of measurements for sparse signals
in ``N`` and sparsity level ``K`` based on paper by Donoho and Tanner::

    M = spx.commons.sparse.phase_transition_estimate_m(N, K);

Example::
    
    >> spx.commons.sparse.phase_transition_estimate_m(1000, 4)
    60

