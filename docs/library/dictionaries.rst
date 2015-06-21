Dictionaries
=====================================


.. highlight:: matlab


Basic Dictionaries
----------------------------------

Some simple dictionaries can be constructed
using library functions. These dictionaries
implement the ``SPX_Operator`` abstraction 
as defined below.

Dirac Fourier Dictionary ::


    SPX_SimpleDicts.dirac_fourier_dict(N)

Dirac DCT Dictionary::

    SPX_SimpleDicts.dirac_dct_dict(N)


Gaussian Dictionary::

    SPX_SimpleDicts.gaussian_dict(N, D, normalized_columns)


Over complete 1-D DCT dictionary::

    SPX_SimpleDicts.overcomplete1DDCT(N, D)


Over complete 2-D DCT dictionary::

    SPX_SimpleDicts.overcomplete2DDCT(N, D)

Dictionaries from SPIE2011 paper::

    SPX_SimpleDicts.SPIE2011(name) % ahoc, orth, rand, sine



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
in an abstract class ``SPX_Operator``.
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
wrapping a given matrix into ``SPX_MatrixOperator``
which is a subclass of ``SPX_Operator``.

Constructing the matrix operator from a matrix ``A``::

    op = SPX_MatrixOperator(A)

The matrix operator holds references to the matrix
as well as its Hermitian transpose::

    op.A
    op.AH

Composite Operators
--------------------------------

A composite operator can be created by combining
two or more operators::

    co = SPX_CompositeOperator(f, g)






Unitary/Orthogonal matrices
-----------------------------------------

::


    SPX_Unitary.uniform_normal_qr(n)
    SPX_Unitary.analyze_rr(O)
    SPX_Unitary.synthesize_rr(rotations, reflections)
    SPX_Unitary.givens_rot(a, b)


Dictionary Properties
-----------------------------------

::


    dp = SPX_DictProps(Dict)

    dp.gram_matrix()
    dp.abs_gram_matrix()
    dp.frame_operator()
    dp.singular_values()
    dp.gram_eigen_values()
    dp.lower_frame_bound()
    dp.upper_frame_bound()
    dp.coherence()


Coherence of a dictionary::

    mu = coherence(dict)

Babel function of a dictionary::

    mu = babel(dict)

Spark of a dictionary (for small sizes)::

    [ K, columns ] = spark( Phi )


Equiangular Tight Frames
-----------------------------------------

::


    SPX_EquiangularTightFrame.ss_to_etf(M)
    SPX_EquiangularTightFrame.is_etf(F)
    SPX_EquiangularTightFrame.ss_etf_structure(k, v)


Grassmannian Frames
----------------------------------

::

    SPX_Grassmannian.minimum_coherence(m, n)
    SPX_Grassmannian.n_upper_bound(m)
    SPX_Grassmannian.min_coherence_max_n(ms)
    SPX_Grassmannian.max_n_for_coherence(m, mu)
    SPX_Grassmannian.alternate_projections(dict, options)



Sensing matrices
----------------------------------

Estimating the RIP  constants using Monte Carlo simulation::

    deltas = estimate_delta(Phi, KMax)


Gaussian  sensing matrix::
    
    cmd = SPX_SensingMatrixDesigner(M, N);
    Phi = cmd.gaussian();


Rademacher sensing matrix::

    cmd = SPX_SensingMatrixDesigner(M, N);
    Phi = cmd.rademacher();
  
Partial Fourier matrix::

    Phi = partialFourierMatrix(M, N);

