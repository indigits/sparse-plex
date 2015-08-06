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
in a variable named ``d``.

* Verify that each column has unit norm.
* Verify that each row has a norm of :math:`\sqrt{2}`.
* Compute the Gram matrix ``d' * d``. 
* Verify that the diagonal elements are all one.
* Divide the Gram matrix into four quadrants.
* Verify that the first and fourth quadrants are identity
  matrices.
* Verify that the Gram matrix is symmetric.
* What can you say about the values in 2nd and 3rd quadrant?



.. rubric:: Creating a signal which is a mixture of sinusoids and impulses



Creating a random dictionary
---------------------------------------------



Taking compressive measurements
------------------------------------



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

