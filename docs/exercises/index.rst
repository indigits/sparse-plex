Exercises
======================

.. highlight:: matlab


The best way to learn is by doing exercises yourself. 
In this section,
we present a set of computer exercises which help you learn
the fundamentals of sparse representations: algorithms and applications. 

Most of these exercises are implemented in some form or
other as part of the ``sparse-plex`` library. 
Once you have written your own implementations, you may 
hunt the code in library and compare your implementation
with the reference implementation.

The exercises are described in terms of MATLAB 
programming environment. But they can be easily
developed in other programming environments too.


Creating a sparse signal
-----------------------------

The first aspect is deciding the support for the
sparse signal.

#. Decide on the length of signal N=1024.
#. Decide on the sparsity level K=10.
#. Choose K entries from 1..N randomly as your choice of sparse support. You can use ``randperm`` function.

Now, we need to consider the values of non-zero entries
in the sparse vector. Typically, they
are chosen from a random distribution. 
Few of the common choices are:

* Gaussian
* Uniform 
* Bi-uniform


.. rubric:: Gaussian 

#. Generate K Gaussian random numbers with zero 
   mean and unit standard deviation. You can 
   use ``randn`` function. You may choose to
   change the standard deviation, but mean should
   usually be zero.
#. Create a column vector with N zeros.
#. On the entries indexed by the sparse support set,
   place the K numbers generated above. 

.. rubric:: Plotting

#. Use ``stem`` command to visualize the sparse signal.

.. rubric::  Uniform

* Most of the steps are similar to creating a 
  Gaussian sparse vector.
* The ``rand`` function generates a number uniformly between 
  0 and 1.
* In order to generate a number uniformly between a and b,
  we can use the simple trick of ``a + (b -a) * rand``


#. Choose a and b (say -4 and 4).
#. Generate K uniformly distributed numbers between a and b.
#. Place them in the N length vector as described above.
#. Plot them.


.. rubric:: Bi-uniform

A problem with Gaussian and uniform distributions 
as described above is that they are prone to 
generate some non-zero entries which are much
smaller compared to others. 

Bi-uniform approach attempts to avoid this situation.
It generates numbers uniformly between [-b, -a] 
and [a, b] where a and b are both positive numbers
with a < b.

#. Choose a and by [say 1 and 2].
#. Generate K uniformly distributed random numbers
   between a and b (as discussed above). These
   are the magnitudes of the sparse non-zero entries.
#. Generate K Gaussian numbers and apply ``sign`` 
   function to them to map them to 1 and -1.
   Note that with equal probability, the signs would 
   be 1 or -1.
#. Multiply the signs and magnitudes to generate your
   sparse non-zero entries.
#. Place them in the N length vector as described above.
#. Plot them.


Following image is an example of how a sparse vector looks.

.. image:: images/k_sparse_biuniform_signal.png


Creating a two ortho basis
--------------------------------------

Simplest example of an overcomplete dictionary
is  Dirac Fourier dictionary.

* You can use ``eye(N)`` to generate the standard
  basis of :math:`\mathbb{C}^N` which is 
  also known as Dirac basis.
* ``dftmtx(N)`` gives the matrix for forward
  Fourier transform. Corresponding Fourier basis 
  can be constructed by taking its transpose.
* The columns / rows of ``dftmtx(N)`` are not 
  normalized. Hence, in order to construct an
  orthonormal basis, we need to normalize the
  columns too. This can be easily done by multiplying
  with :math:`\frac{1}{\sqrt{N}}`. 

#. Choose the dimension of the ambient signal space
   (say N=1024).
#. Construct the Dirac basis for :math:`\mathbb{C}^N`.
#. Construct the orthonormal Fourier basis for :math:`\mathbb{C}^N`.
#. Combine the two to form the two ortho basis 
   (Dirac in left, Fourier in right).


.. rubric:: Verification

We assume that the dictionary has been stored
in a variable named ``d``. We will use the
mathematical symbol :math:`\Phi` for the same.

* Verify that each column has unit norm.
* Verify that each row has a norm of :math:`\sqrt{2}`.
* Compute the Gram matrix :math:`\Phi' * \Phi`. 
* Verify that the diagonal elements are all one.
* Divide the Gram matrix into four quadrants.
* Verify that the first and fourth quadrants are identity
  matrices.
* Verify that the Gram matrix is symmetric.
* What can you say about the values in 2nd and 3rd quadrant?


Creating a Dirac-DCT two-ortho basis
------------------------------------------
While Dirac-DFT two ortho basis has the lowest possible 
coherence amongst all pairs of orthogonal bases, it is 
not restricted to :math:`\mathbb{R}^N`.  A good starting
point is to consider constructing a Dirac-DCT two ortho
basis.

* Replace ``dftmtx(N)`` by ``dctmtx(N)``. 
* Follow steps similar to previous exercise to construct a
  Dirac-DCT dictionary.
* Notice the differences in the Gram matrix of Dirac-DFT dictionary
  with Dirac-DCT dictionary.  
* Construct the Dirac-DCT dictionary for different values of N=(8, 16, 32, 64, 128, 256).
* Look at the changes in the Gram matrix as you vary N for constructing Dirac-DCT dictionary.

An example Dirac-DCT dictionary has been illustrated in the figure below.

.. image:: images/dirac_dct_256.png


.. note::
 
  While constructing the two-ortho bases is nice for illustration, it
  should be noted that using them directly for computing :math:`\Phi x` 
  is not efficient. This entails full cost of a matrix vector multiplication.
  An efficient implementation would consider following ideas:

  * :math:`\Phi x = [I \Psi] x = I x_1  + \Psi x_2` where :math:`x_1`
    and :math:`x_2` are upper and lower halves of the vector :math:`x`.
  * :math:`I x_1` is nothing but `x_1`.
  * :math:`\Psi x_2` can be computed by using the efficient implementations
    of (Inverse) DFT or DCT transforms with appropriate scaling. 
  * Such implementations would perform the multiplication with dictionary in 
    :math:`O(N \log N)` time.
  * In fact, if the second basis is a wavelet basis, then the multiplication can
    be carried out in linear time too.
  * You are suggested to take advantage of these ideas in following exercises.

.. rubric:: Creating a signal which is a mixture of sinusoids and impulses

If we split the sparse vector :math:`x` into two halves :math:`x_1` and :math:`x_2`
then:
* The first half corresponds to impulses from the Dirac basis.
* The second half corresponds to sinusoids from DCT or DFT basis.

It is straightforward to construct a signal which is a mixture of impulses and
sinusoids and has a sparse representation in Dirac-DFT or Dirac-DCT representation.

* Pick a suitable value of N (say 64).
* Construct the corresponding two ortho basis.
* Choose a sparsity pattern for the vector x (of size 2N) such that some
  of the non-zero entries fall in first half while some in second half.
* Choose appropriate non-zero coefficients for x.
* Compute :math:`y = \Phi x` to obtain a signal which is a mixture of impulses
  and sinusoids.


Verification

* It is obvious that the signal is non-sparse in time domain.
* Plot the signal using ``stem`` function.
* Compute the DCT or DFT representation of the signal (by taking inverse transform).
* Plot the transform basis representation of the signal.
* Verify that the transform basis representation does indeed have some large spikes
  (corresponding to the non-zero entries in second half of :math:`x`) but the rest
  of the representation is also full with (small) non-zero terms (corresponding to
  the transform representation of impulses).





Creating a random dictionary
---------------------------------------------

We consider constructing a Gaussian random matrix.

* Choose the number of measurements :math:`M` say 128.
* Choose the signal space dimension :math:`N` say 1024.
* Generate a Gaussian random matrix as :math:`\Phi = \text{randn(M, N)}`.

There are two ways of normalizing the random matrix to a dictionary.

One view considers that all columns or atoms of a dictionary should be 
of unit norm.

* Measure the norm of each column. You may be tempted to write a for loop
  to do the same. While this is alright, but Matlab is known for its 
  vectorization capabilities. Consider using a combination of ``sum``
  ``conj`` element wise multiplication and ``sqrt`` to come up with 
  a function which can measure the column wise norms of a matrix.
  You may also explore ``bsxfun``.
* Divide  each column by its norm to construct a normalized dictionary.
* Verify that the columns of this dictionary are indeed unit norm.

An alternative way considers a probabilistic view. 

* We say that each entry in the Gaussian random matrix should be zero mean
  and variance :math:`\frac{1}{N}`.
* This ensures that on an average the mean of each column is indeed 1 though
  actual norms of each column may differ.
* As the number of measurements increases, the likelihood of norm being close
  to one increases further.

We can apply these ideas as follows:

* Recall that ``randn`` generates Gaussian random variables with zero mean
  and unit variance.
* Divide the whole random matrix by :math:`\frac{1}{\sqrt{N}}` to achieve
  the desired sensing matrix.
* Measure the norm of each column.
* Verify that the norms are indeed close to 1 (though not exactly).
* Vary M and N to see how norms vary.
* Use ``imagesc`` or ``imshow`` function to visualize the sensing matrix.

An example Gaussian sensing matrix is illustrated in figure below.

.. image:: images/gaussian_matrix.png




Taking compressive measurements
------------------------------------

* Choose a sparsity level (say K=10)
* Choose a sparse support over :math:`1 \dots N` of size K randomly using
  ``randperm`` function.
* Construct a sparse vector with bi uniform non-zero entries.
* Apply the Gaussian sensing matrix on to the sparse signal to compute 
  compressive measurement vector in :math:`\mathbb{R}^M`.

An example of compressive measurement vector is shown in figure below.

.. image:: images/measurement_vector_biuniform.png

In the sequel we will refer to the computation of measurement vector
by the equation :math:`y = \Phi x`.

When we make measurement noisy, the equation would be :math:`y = \Phi x + e`.


Developing the matching pursuit algorithm
----------------------------------------------------


Developing the orthogonal matching pursuit algorithm
----------------------------------------------------- 


Measuring dictionary properties
-------------------------------------


Coherence
'''''''''''''''''


Babel function
''''''''''''''''''''''''''




Sparsifying an image
----------------------------------------------------

