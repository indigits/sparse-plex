Dictionaries
=====================================


.. highlight:: matlab


Basic Dictionaries
----------------------------------

Some simple dictionaries can be constructed
using library functions. 

The dictionaries are available in
two flavors: 

#. As simple matrices
#. As objects which implement the ``spx.dict.Operator`` abstraction defined below.

The functions returning the dictionary
as a simple matrix have a suffix "mtx".
The functions returning the dictionary
as a ``spx.dict.Operator`` have the suffix
"dict" at the end.

These functions can also be used
to construct random **sensing matrices**
which are essentially random 
dictionaries. 


Dirac Fourier Dictionary ::


    spx.dict.simple.dirac_fourier_dict(N)

Dirac DCT Dictionary::

    spx.dict.simple.dirac_dct_dict(N)


Gaussian Dictionary::

    spx.dict.simple.gaussian_dict(N, D, normalized_columns)


Rademacher Dictionary::

    Phi = spx.dict.simple.rademacher_dict(N, D);

Partial Fourier Dictionary::

    Phi = spx.dict.simple.partial_fourier_dict(N, D);

Over complete 1-D DCT dictionary::

    spx.dict.simple.overcomplete1DDCT(N, D)


Over complete 2-D DCT dictionary::

    spx.dict.simple.overcomplete2DDCT(N, D)

Dictionaries from SPIE2011 paper::

    spx.dict.simple.spie_2011(name) % ahoc, orth, rand, sine


Sensing matrices
-------------------------


Gaussian  sensing matrix::
    
    Phi = spx.dict.simple.gaussian_mtx(M, N);


Rademacher sensing matrix::

    Phi = spx.dict.simple.rademacher_mtx(M, N);
  
Partial Fourier matrix::

    Phi = spx.dict.simple.partial_fourier_mtx(M, N);




Operators
--------------------------

In simple terms, a (finite) dictionary is 
implemented as a matrix whose columns are
atoms of the dictionary. This approach
is not powerful enough. A dictionary 
:math:`\Phi`
usually acts on a sparse representation
:math:`\alpha` to obtain a signal
:math:`x = \Phi \alpha`. During
sparse recovery, the Hermitian transpose
of the dictionary acts on the signal 
[or residual] to compute :math:`\Phi^H x`
or :math:`\Phi^H r`. Thus, the fundamental
operations are multiplication by :math:`\Phi`
and :math:`\Phi^H`. While, these operations
can be directly implemented by using
a matrix representation of a dictionary,
they are slow and require a large storage
for the dictionary. For random dictionaries,
this is the only option. But for structured
dictionaries and sensing matrices, the
whole of dictionary need not be held in memory.
The multiplication by :math:`\Phi`
and :math:`\Phi^H` can be implemented using
fast functions. 

Also multiple dictionaries can be combined
to construct a composite dictionary, e.g. :math:`\Phi \Psi`.


In order to take care of these scenarios, 
we define the notion of a generic operator
in an abstract class ``spx.dict.Operator``.
All operators support following methods.


Constructing a matrix representation of the operator::

    op.double()

Computing :math:`\Phi x`::

    op.mtimes(x)


The transpose operator::

    op.transpose()

By default it is constructed by computing the
matrix representation of the transpose of the
operator. But specialized dictionaries can
implement it smartly.


The Hermitian transpose operator::
     
    op.ctranspose()

By default it is constructed by computing the
matrix representation of the Hermitian transpose of the
operator. But specialized dictionaries can
implement it smartly.


Obtaining specific columns from the operator::

    op.columns(columns)

Note that this doesn't require computing the complete
matrix representation of the operator.


    op.apply_columns(vectors, columns)


Constructing an operator which uses only the specified columns from 
this dictionary::

    op.columns_operator(columns)

A specific column of the dictionary::

    op.column(index)

Printing the contents of the dictionary::

    disp(op)


Matrix operators
------------------------------

Matrix operators are constructed by
wrapping a given matrix into ``spx.dict.MatrixOperator``
which is a subclass of ``spx.dict.Operator``.

Constructing the matrix operator from a matrix ``A``::

    op = spx.dict.MatrixOperator(A)

The matrix operator holds references to the matrix
as well as its Hermitian transpose::

    op.A
    op.AH

Composite Operators
--------------------------------

A composite operator can be created by combining
two or more operators::

    co = spx.dict.CompositeOperator(f, g)






Unitary/Orthogonal matrices
-----------------------------------------

::


    spx.dict.unitary.uniform_normal_qr(n)
    spx.dict.unitary.analyze_rr(O)
    spx.dict.unitary.synthesize_rr(rotations, reflections)
    spx.dict.unitary.givens_rot(a, b)


Dictionary Properties
-----------------------------------

::


    dp = spx.dict.Properties(Dict)

    dp.gram_matrix()
    dp.abs_gram_matrix()
    dp.frame_operator()
    dp.singular_values()
    dp.gram_eigen_values()
    dp.lower_frame_bound()
    dp.upper_frame_bound()
    dp.coherence()


Coherence of a dictionary::

    mu = spx.dict.coherence(dict)

Babel function of a dictionary::

    mu = spx.dict.babel(dict)

Spark of a dictionary (for small sizes)::

    [ K, columns ] = spx.dict.spark( Phi )


Equiangular Tight Frames
-----------------------------------------

::


    spx.dict.etf.ss_to_etf(M)
    spx.dict.etf.is_etf(F)
    spx.dict.etf.ss_etf_structure(k, v)


Grassmannian Frames
----------------------------------

::

    spx.dict.grassmannian.minimum_coherence(m, n)
    spx.dict.grassmannian.n_upper_bound(m)
    spx.dict.grassmannian.min_coherence_max_n(ms)
    spx.dict.grassmannian.max_n_for_coherence(m, mu)
    spx.dict.grassmannian.alternate_projections(dict, options)



