Sparse recovery pursuit algorithms
==================================================


Contents:

.. toctree::
   :maxdepth: 1

   mp
   omp
   bp
   cosamp
   joint/index

Introduction
--------------------

This section focuses on methods which solve the
sparse recovery or sparse approximation problems
for one vector at a time. A subsection on
joint recovery algorithms focuses on solving problems
where multiple vectors which have largely common supports
can be solved jointly.

For each algorithm, there is a solver. The solver 
should be constructed first with the dictionary / sensing matrix
and some other parameters like sparsity level as needed by
the algorithm.

The solver can then be used for solving one problem at a time.

