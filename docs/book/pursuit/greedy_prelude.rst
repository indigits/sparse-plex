.. _sec:intro_matching_pursuit_algorithms:

Prelude to greedy pursuit algorithms
===================================================

In this chapter we will review some matching pursuit algorithms which can help us
solve the sparse approximation problem and the sparse recovery problem 
discussed in :ref:`here <ch:sparse_signal_models>`.

The presentation in this chapter is based on a number of sources including
:cite:`baraniuk2011introduction,blumensath2009iterative,elad2010sparse,needell2009cosamp,tropp2004greed,tropp2007signal`.

Let us recall the definitions of sparse approximation and recovery problems from previous chapters.


From :ref:`here <def:ssm:d_k_sparse_approximation_problem>`
let :math:`\DDD` be a signal dictionary with  :math:`\Phi \in \CC^{N \times D}` being its synthesis matrix.
The :math:`(\mathcal{D}, K)`-:textsc:`sparse` approximation
can be written as


.. math:: 

    \begin{aligned}
      & \underset{\alpha}{\text{minimize}} 
      & &  \| x - \Phi \alpha \|_2 \\
      & \text{subject to}
      & &  \| \alpha \|_0 \leq K.
    \end{aligned}
    



From :ref:`here <def:ssm:d_k_exact_sparse_problem>`
with the help of synthesis matrix :math:`\Phi`, the :math:`(\mathcal{D}, K)`-:textsc:`exact-sparse` problem
can be written as


.. math:: 

    \begin{aligned}
      & \underset{\alpha}{\text{minimize}} 
      & &  \| \alpha \|_0 \\
      & \text{subject to}
      & &  x = \Phi \alpha\\
      & \text{and}
      & &  \| \alpha \|_0 \leq K
    \end{aligned}
    


From :ref:`here <def:ssm:compressed_sensing>` we recall the *sparse signal recovery from compressed measurements* problem as following.
Let :math:`\Phi \in \CC^{M \times N}` be a sensing matrix. 
Let :math:`x \in \CC^N` be an unknown signal which is assumed to be sparse or compressible. 
Let :math:`y = \Phi x` be a measurement vector in :math:`\CC^M`. 

Then the signal recovery problem is to recover :math:`x` from :math:`y` subject to


.. math:: 

    y = \Phi x

assuming :math:`x` to be  :math:`K` sparse or at least :math:`K` compressible.

We note that sparse approximation problem and sparse recovery problems have pretty much same structure. They
are in fact dual to each other. Thus we will see that the same set of algorithms can be adapted to
solve both problems.

In the sequel we will see many variations of above problems.

 
Our first problem
----------------------------------------------------


We will start with attacking a very simple version of :math:`(\mathcal{D}, K)`-:textsc:`exact-sparse`
problem.

Setting up notation


*  :math:`x \in \CC^N` is our signal of interest and it is known.
*  :math:`\DDD` is the dictionary in which we are looking for a sparse representation of :math:`x`.
*  :math:`\Phi \in \CC^{N \times D}`  is the synthesis matrix for :math:`\DDD`.
*  The sparse representation of :math:`x` in :math:`\DDD` is given by


.. math:: 

    x = \Phi \alpha.
*  It is assumed that :math:`\alpha \in \CC^D` is sparse with :math:`|\alpha|_0 \leq K`.
*  Also we assume that :math:`\alpha` is the sparsest possible solution for :math:`x` that we are looking.
*  We know :math:`x`, we know :math:`\Phi`, we don't know :math:`\alpha`. We are looking for it.



Thus we need to solve the optimization problem given by


.. math::
    :label: eq:pursuit_l0_minimization_problem

    \underset{\alpha}{\text{minimize}}\, \| \alpha \|_0 \; \text{subject to} \, x = \Phi \alpha.


For the unknown vector :math:`\alpha`, we need to find

*  the sparsest support for the solution i.e. :math:`\{ i | \alpha_i \neq 0 \}`
*  the non-zero values :math:`\alpha_i` over this support.


If we are able to find the support for the solution :math:`\alpha`, then we may assume that
the non-zero values of :math:`\alpha` can be easily computed by least squares methods.

Note that the support is discrete in nature (An index :math:`i` either belongs to the support or it does not).
Hence algorithms which will seek the support will also be discrete in nature.

We now build up a case for greedy algorithms before jumping into specific algorithms
later.

Let us begin with a much simplified version of the problem.

Let the columns of the matrix :math:`\Phi` be represented as


.. math::
    \Phi  = \begin{bmatrix}
    \phi_1 & \phi_2 & \dots & \phi_D
    \end{bmatrix}
    .


Let :math:`\spark (\Phi) > 2`. Thus no two columns in :math:`\Phi` are linearly dependent
and as per :ref:`here <thm:ssm:uniqueness_spark>`, for any :math:`x`, there
is at most only one :math:`1`-sparse explanation vector.



We now assume that such a representation exists 
and we would be looking for optimal solution vector :math:`\alpha^*` that has only one non-zero value, 
i.e. :math:`\| \alpha^*\|_0 = 1`. 

Let :math:`i` be the index at which :math:`\alpha^*_i \neq 0`. 

Thus :math:`x = \alpha^*_i \phi_i`, i.e. :math:`x` is a scalar multiple of :math:`\phi_i` (the :math:`i`-th column of :math:`\Phi`).

Of course we don't know what is the value of index :math:`i`.

We can find this by comparing :math:`x` with each column of :math:`\Phi` and find the column which best matches it.

Consider the least squares minimization problem:


.. math::
    \epsilon(j) = \underset{z_j}{\text{minimize}}\, \|  \phi_j z_j  - x \|_2.


where :math:`z_j \in \CC` is a scalar.

From linear algebra, it attempts to find the projection of  :math:`x`  over :math:`\phi_j` and :math:`\epsilon(j)` 
represents the magnitude of error between :math:`x` and the projection of :math:`x` over :math:`\phi_j`. 

Optimal solution is given by


.. math::
    z_j^* = \frac{\phi_j^H x }{\| \phi_j \|_2^2} = \phi_j^H x

since columns of a dictionary are assumed to be unit norm.

Plugging it back into the expression of minimum squared error we get


.. math:: 

    \epsilon^2(j) &= \underset{z_j}{\text{minimize}}\, \| \phi_j z_j - x \|_2^2\\
    &=\left \| \phi_j \phi_j^H x   - x \right \|_2^2\\
    &= \| x\|_2^2 - |\phi_j^H x |^2.


Now since :math:`x` is a scalar multiple of :math:`\phi_i`, hence :math:`\epsilon(i) = 0`, thus if we look at
:math:`\epsilon(j)` for :math:`j = 1, \dots, D`, the minimum value :math:`0` will be obtained for :math:`j = i`.

And :math:`\epsilon(i) = 0` means


.. math::
     \| x\|_2^2 - |\phi_i^H x |^2 = 0
     \implies \| x\|_2^2 = |\phi_i^H x |^2.


This is a special case of Cauchy-Schwartz inequality when :math:`x` and :math:`\phi_i` are collinear. 

The sparse representation is given by


.. math:: 

    \alpha = \begin{bmatrix}
    0 \\
    \vdots \\
    z_i^* \\
    \vdots \\
     0
    \end{bmatrix}


Since :math:`x \in \CC^N` and :math:`\phi_j \in \CC^N`, hence computation of :math:`\epsilon(j)` requires
:math:`\bigO{N}` time.

Since we may need to do it for all :math:`D` columns, hence finding the index :math:`i` takes
:math:`\bigO{ND}` time.


.. _fig:single_sparse_vector_recovery:

.. comment:: 

    At this point it is interesting to implement this algorithm and see it in action.
    
    \lstinputlisting[caption=demoSingleSparseVectorRecovery.m]{greedy/demoSingleSparseVectorRecovery.m}
    
    The results are plotted in \autoref{fig:single_sparse_vector_recovery}.
    

    
    .. code-block:: 
    
        \centering
        \includegraphics[width = 0.9\textwidth]{greedy/singleSparseRecovery}
        \caption{Recovery of a sparse vector with single nonzero value}
    
    
    Some comments are in order.
    
    *  The sensing matrix :math:`\Phi` was randomly generated.
    *  The one sparse vector :math:`x` was also randomly generated.
    *  We can clearly see that error becomes 0 exactly at the correct index and is much higher at other places.
    



Now let us make our life more complex. We now suppose that :math:`\spark(\Phi) > 2 K`.  Thus
a sparse representation :math:`\alpha` of :math:`x` with up to :math:`K` non-zero values is unique 
if it exists(see again :ref:`here <thm:ssm:uniqueness_spark>`). 
We assume it exists.
Since :math:`x=\Phi \alpha`, :math:`x` is a linear combination of up to :math:`K` columns of :math:`\Phi`.

One approach could be to check out all :math:`\binom{D}{K}` possible subsets of :math:`K` columns 
from :math:`\Phi`. 

But :math:`D \choose K` is :math:`\bigO{D^{K}}` and for each subset of :math:`K` columns solving the
least squares problem will take :math:`\bigO{N K^2}` time. Hence overall complexity 
of the recovery process would be :math:`\bigO{D^{K} N K^2}`. This is prohibitively expensive.


A way around is by adopting a greedy strategy in which we abandon the hopeless exhaustive search
and attempt a series of single term updates in the solution vector :math:`\alpha`.

Since this is an iterative procedure, let us call the approximation at each iteration
as :math:`\alpha^k` where :math:`k` is the iteration index.


*  We start with :math:`\alpha^0 = 0`.
*  At each iteration we choose one new column in :math:`\Phi` and fill in 
   a value at corresponding index in :math:`\alpha^k`.
*  The column and value are chosen such that it maximally reduces 
   the :math:`l_2` error  between :math:`x` and the approximation. i.e.


   .. math::
      \| x -\Phi \alpha^{k + 1} \|_2 <  \| x -\Phi \alpha^{k} \|_2

   and the error reduction is as high as possible.
*  We stop when the :math:`l_2` error reduces below a specific threshold.

Many variations to this scheme are possible.

* We can choose more than one atom in each iteration.
* In fact we can choose even K atoms in each iteration.
* We can drop some previously chosen atoms in an iteration too
  if they seem to be incorrect choices.

Not every chosen atom may be a correct one. Some algorithms
have mechanisms to identify atoms which are more likely to
be part of the support than others and thus drop the 
unlikely ones. 

We are now ready to explore different greedy algorithms.
