Matching pursuit
=======================================

.. highlight:: matlab

.. figure:: images/alg_matching_pursuit.png

    Matching Pursuit

The matching pursuit algorithm is a 
very simple iterative approach to 
solve the sparse recovery problem.
We are given the signal :math:`y`
and the dictionary :math:`\Phi` 
and we are to recover the sparse
representation :math:`x` satisfying
:math:`y = \Phi x`.


In each iteration of matching pursuit:

* A current estimate of the
  representation vector :math:`x` is maintained 
  in the variable :math:`z`.
* Current residual :math:`r = y - \Phi z` is 
  maintained.
* The inner product of the residual with
  all the atoms in :math:`\Phi` is computed.
* We look for the atom which has the largest
  inner product in magnitude.
* Contribution from this atom is added to
  the representation.
* Residual is reduced accordingly.

Note that it is guaranteed that the norm of residual 
decreases monotonically in each iteration till it
converges.


The algorithm can be motivated as follows.

Let :math:`\Lambda` be the support of 
the representation vector :math:`x`.
Then

.. math::

    y = \sum_{j \in \Lambda} \phi_{j} x_{j}.

For some :math:`k \in \Lambda`

.. math::

    \langle y, \phi_k \rangle = \sum_{j \in \Lambda} \langle \phi_{j} , \phi_k \rangle x_{j}.


If the atoms formed an orthonormal set, this would have reduced to
:math:`x_{k} =  \langle y, \phi_k \rangle` and picking the largest
inner product would give us the largest non-zero entry in :math:`x`.

In fact, if :math:`\Phi` was an orthonormal basis, then matching
pursuit recovers the representation of :math:`y` in
exactly :math:`K` iterations where :math:`K = |\Lambda|`
by successively picking up nonzero coefficients in :math:`x`
in the order of descending magnitude. We hope that
the algorithm is useful even when the atoms in 
:math:`\Phi_{\Lambda}` are not orthogonal.


Now, let us look at the iterative structure. Assume that
the current estimate :math:`z` satisfies 
:math:`\supp(z) \subseteq \Lambda`. Then
:math:`\Phi z \in \Range(\Phi_{\Lambda})`.
Since :math:`y \in \Range(\Phi_{\Lambda})`, hence
the residual :math:`r \in \Range(\Phi_{\Lambda})` also holds.

Finally, if the atoms in :math:`\Phi` are nearly 
orthogonal to each other, then the largest inner
product of :math:`r` will be for one of the atoms
in :math:`\Lambda`. This atom is indexed by
the variable :math:`k`. Then :math:`h_k`
is the projection of the residual :math:`r` on 
the atom :math:`\phi_k`.

We add this projection coefficient to :math:`z_k` and remove
the projection from the residual.  The support
of :math:`z` continues to be within :math:`\Lambda`.


Since the atoms are not orthogonal, matching pursuit
typically takes much larger number of iterations
than the sparsity level :math:`K`. However, 
under suitable conditions, it does converge
to the correct solution.


Matching pursuit on a 2-sparse vector
----------------------------------------------

In this example, we will reconstruct a 2-sparse
representation vector :math:`x` from a signal
:math:`y = \Phi x`. We will develop the basic
implementation of matching pursuit along-with.

From :ref:`this example <ex:ssm:spark:partial-hadamard>`, we know of a way to construct a dictionary with high spark::

    rng default;
    N = 20;
    M = 10;
    K = 2;
    PhiA = hadamard(N);
    rows = randperm(N, M);
    PhiB = PhiA(rows, :);

Let's print its contents::

    >> PhiB

    PhiB =

         1 -1 -1 -1 -1  1 -1  1 -1  1  1  1  1 -1 -1  1 -1 -1  1  1
         1 -1 -1  1 -1 -1  1  1 -1 -1 -1 -1  1 -1  1 -1  1  1  1  1
         1 -1 -1 -1  1 -1  1 -1  1  1  1  1 -1 -1  1 -1 -1  1  1 -1
         1  1  1 -1 -1  1 -1 -1  1  1 -1 -1 -1 -1  1 -1  1 -1  1  1
         1  1 -1  1  1  1  1 -1 -1  1 -1 -1  1  1 -1 -1 -1 -1  1 -1
         1 -1  1  1  1  1 -1 -1  1 -1 -1  1  1 -1 -1 -1 -1  1 -1  1
         1 -1  1  1 -1 -1 -1 -1  1 -1  1 -1  1  1  1  1 -1 -1  1 -1
         1  1  1 -1 -1 -1 -1  1 -1  1 -1  1  1  1  1 -1 -1  1 -1 -1
         1 -1  1 -1 -1  1  1 -1 -1 -1 -1  1 -1  1 -1  1  1  1  1 -1
         1  1 -1 -1  1  1 -1 -1 -1 -1  1 -1  1 -1  1  1  1  1 -1 -1

Let's normalize its columns:: 

    Phi = spx.norm.normalize_l2(PhiB);

:ref:`sec:pursuit:tf:bigaussian` discusses ways to 
generate synthetic sparse vectors.

Let's generate our 2-sparse representation vector::

    rng(100);
    gen = spx.data.synthetic.SparseSignalGenerator(N, K);
    x =  gen.biGaussian();

Let's print :math:`x`::

    >> spx.io.print.sparse_signal(x);
    (6,1.6150) (11,-1.2390)   N=20, K=2

This is a nice helper function to print sparse vectors. It
prints a sequence of tuples where each tuple consists of
the index of a non-zero value and corresponding value.

The support for this vector is::

    >> spx.commons.sparse.support(x)'

    ans =

         6    11

Let's construct our 10-dimensional signal from it::

    y = Phi * x;

Let's print it::

    >> spx.io.print.vector(y)
    0.12 -0.12 -0.90 0.90 0.90 0.90 -0.90 -0.12 0.90 0.12 

Our problem is now setup. Our job now is to 
recover :math:`x` from :math:`\Phi` and :math:`y`.

Initialize the estimated representation and current residual::

    z = zeros(N, 1);
    r = y;

We will run the matching pursuit iterations up to 100 times:: 

    for i=1:100

Following code samples are part of each matching pursuit iteration.
We start with computing the inner products of the 
current residual with each atom::

    inner_products = Phi' * r;

Find the index of best matching atom :math:`k` ::

    [max_abs_inner_product, index]  = max(abs(inner_products));

Corresponding signed inner product :math:`h_k`::

    max_inner_product = inner_products(index);

Update the representation::

    z(index) = z(index) + max_inner_product;

Remove the projection of the atom from the residual::

    r = r - max_inner_product * Phi(:, index);

Compute the norm of residual::

    norm_residual = norm(r);

If the norm is less than a threshold, we break out of loop:: 

    if norm_residual < 1e-4
        break;
    end

It will be instructive to print current value of residual norm, selected atom index and estimated coefficients in the 
:math:`z` variable in each iteration::

    fprintf('[%d]: k: %d, h_k : %.4f, r_norm: %.4f, estimate: ', i, index, norm_residual, max_inner_product);


Here is the output of running this algorithm 
for this problem::

    [1]: k: 6, h_k : 1.2140, r_norm: 1.8628, estimate: (6,1.8628)   N=20, K=1
    [2]: k: 11, h_k : 0.2428, r_norm: -1.1894, estimate: (6,1.8628) (11,-1.1894)   N=20, K=2
    [3]: k: 6, h_k : 0.0486, r_norm: -0.2379, estimate: (6,1.6249) (11,-1.1894)   N=20, K=2
    [4]: k: 11, h_k : 0.0097, r_norm: -0.0476, estimate: (6,1.6249) (11,-1.2370)   N=20, K=2
    [5]: k: 6, h_k : 0.0019, r_norm: -0.0095, estimate: (6,1.6154) (11,-1.2370)   N=20, K=2
    [6]: k: 11, h_k : 0.0004, r_norm: -0.0019, estimate: (6,1.6154) (11,-1.2389)   N=20, K=2
    [7]: k: 6, h_k : 0.0001, r_norm: -0.0004, estimate: (6,1.6150) (11,-1.2389)   N=20, K=2


It took us 7 iterations, but the residual norm 
reached close to 0. We can note that 
the non-zero values in :math:`z` match closely
with the corresponding values in :math:`x`.
Matching pursuit has been successful.
We can also notice that the reconstruction alternates
between atom number 6 and 11 in each iteration. 
Also, the residual norm keeps on decreasing with
each iteration.

The complete code can be downloaded 
:download:`here <demo_mp_partial_hadamard_10x20_k_3.m>`.
