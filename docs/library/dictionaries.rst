Dictionaries
=====================================


.. highlight:: matlab


Basic Dictionaries
----------------------------------

Dirac Fourier Dictionary ::


    CS_BasicDictionaryCreator.DiracFourier(N)

Dirac DCT Dictionary::

    CS_BasicDictionaryCreator.DiracDCT(N)


Gaussian Dictionary::

    CS_BasicDictionaryCreator.Gaussian(N, D, normalized_columns)


Over complete 1-D DCT dictionary::

    CS_BasicDictionaryCreator.overcomplete1DDCT(N, D)


Over complete 2-D DCT dictionary::

    CS_BasicDictionaryCreator.overcomplete2DDCT(N, D)

Dictionaries from SPIE2011 paper::

    CS_BasicDictionaryCreator.SPIE2011(name) % ahoc, orth, rand, sine


Operators
-----------------------

Abstract operator::

    op = CS_Operator()
    op.double()
    op.mtimes(other) op * other
    op.transpose()
    op.ctranspose()
    op.columns(columns)
    op.apply_columns(vectors, columns)
    op.columns_operator(columns)
    op.column(index)
    disp(op)


Matrix operator::


    op = CS_MatrixOperator(A)
    op.A
    op.AH

Composite Operator::


    co = CS_CompositeOperator(f, g)



Unitary/Orthogonal matrices
-----------------------------------------

::


    CS_Unitary.uniform_normal_qr(n)
    CS_Unitary.analyze_rr(O)
    CS_Unitary.synthesize_rr(rotations, reflections)
    CS_Unitary.givens_rot(a, b)


Dictionary Properties
-----------------------------------

::


    dp = CS_DictProps(Dict)

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


    CS_EquiangularTightFrame.ss_to_etf(M)
    CS_EquiangularTightFrame.is_etf(F)
    CS_EquiangularTightFrame.ss_etf_structure(k, v)


Grassmannian Frames
----------------------------------

::

    CS_Grassmannian.minimum_coherence(m, n)
    CS_Grassmannian.n_upper_bound(m)
    CS_Grassmannian.min_coherence_max_n(ms)
    CS_Grassmannian.max_n_for_coherence(m, mu)
    CS_Grassmannian.alternate_projections(dict, options)



Sensing matrices
----------------------------------

Estimating the RIP  constants using Monte Carlo simulation::

    deltas = estimateRIPDelta(Phi, KMax)


Gaussian  sensing matrix::
    
    cmd = CS_SensingMatrixDesigner(M, N);
    Phi = cmd.gaussian();


Rademacher sensing matrix::

    cmd = CS_SensingMatrixDesigner(M, N);
    Phi = cmd.rademacher();
  
Partial Fourier matrix::

    Phi = partialFourierMatrix(M, N);

