Commons
=====================


.. highlight:: matlab


Commons-Checks
---------------------------------------------------

::

    CS_Checks.is_square(A)
    CS_Checks.is_symmetric(A)
    CS_Checks.is_hermitian(A)
    CS_Checks.is_positive_definite(A)
    CS_Checks.
    CS_Checks.

Commons-Comparing Signals
---------------------------------------------------

::

    CS_CompareSignals.sparse_approximation(X, K)
    cs = CS_CompareSignals(References, Estimates, K)
    cs.difference_norms()
    cs.reference_norms()
    cs.estimate_norms()
    cs.error_to_signal_norms()
    cs.signal_to_noise_ratios()
    cs.sparse_references()
    cs.sparse_estimates()
    cs.reference_sparse_supports()
    cs.estimate_sparse_supports()
    cs.support_similarity_ratios()
    cs.has_matching_supports(1.0)
    cs.summarize()


Commons-Distance
---------------------------------------------------

::


    CS_Distance.pairwise_distances(X, distance)
    CS_Distance.sqrd_l2_distances_cw(X)
    CS_Distance.sqrd_l2_distances_rw(X)
    CS_Distance.
    CS_Distance.
    CS_Distance.


Commons-Matrix
---------------------------------------------------


::

    CS_Mat.off_diagonal_elements(X)
    CS_Mat.off_diagonal_matrix(X)
    CS_Mat.off_diag_upper_tri_elements(X)
    CS_Mat.off_diag_upper_tri_matrix(X)
    CS_Mat.nonzero_density(X)


Commons-Signal space comparison
---------------------------------------------------

::

    cs = CS_MeasureApproximation(References, Estimates)
    cs.difference_norms()
    cs.reference_norms()
    cs.estimate_norms()
    cs.error_to_signal_norms()
    cs.signal_to_noise_ratios()
    cs.summarize()


Commons-Norm utilities
---------------------------------------------------


::

    CS_NormUtils.norms_l1_cw(X)
    CS_NormUtils.norms_l2_cw(X)
    CS_NormUtils.norms_linf_cw(X)
    CS_NormUtils.normalize_l1(X)
    CS_NormUtils.normalize_l2(X)
    CS_NormUtils.normalize_l2_rw(X)
    CS_NormUtils.normalize_linf(X)
    CS_NormUtils.scale_columns(X, factors)
    CS_NormUtils.scale_rows(X, factors)
    CS_NormUtils.inner_product_cw(A, B)


Commons-Problem Description
---------------------------------------------------


::

    pd = CS_ProblemDescription(Dict, Phi, K, ...
                Representations, Signals, Measurements)
    pd.describe()


Commons-Number related utilities
---------------------------------------------------


::

    NumberUtil.findIntegerFactorsCloseToSquarRoot(n)


Commons-Others
---------------------------------------------------

::

    isDiagonallyDominant(A, strict)
    largestIndices(x, K)
    makeDiagonallyDominant( A, strict )
    nonDiagonalElements(A)
    normalizeColumns( A )
    phaseTransitionEstimateM(N, K)
    sortByMagnitude(x)
    sortedNonZeroElements(x)
    sparcoOpToMatrix(op)

K largest entries in a vector x::

    sparseApproximation(x, K)

Energy of signal::

    sumSquare(input)

 Unit vector in a given co-ordinate::
    
    unitVector(N, i)

Find the first vector with energy less than a given target::

    CS_VectorsUtil.findFirstLessEqEnergy(X, energy)


Sparse Signals
----------------------------------

Sparse support for a vector::

    CS_SupportUtil.support(x)

l_0 "norm" of a vector::

    CS_SupportUtil.l0norm(x)

Support intersection ratio::

    CS_SupportUtil.intersectionRatio(s1, s2)

Support similarity::

    CS_SupportUtil.supportSimilarity(X, reference)

Support similarities between two sets of signals::

    CS_SupportUtil.supportSimilarities(X, Y)

Support detection ratios ::

    CS_SupportUtil.supportDetectionRate(X, trueSupport)


K largest indices over a set of vectors::

     CS_SupportUtil.dominantSupportMerged(data, K)



Printing functions
-------------------------------

Print a matrix for putting in Latex::

    printMatrixForLatex(Phi);


Print a set for putting in Latex::

    printSetForLatex(x);

Print a vector for Latex::

    printVectorForLatex(x)

    
Print a matrix for putting in SciRust::

    printMatrixForSciRust(Phi);

Print a sparse vector as pairs of indices and values::

    printSparseVector(x)

Print the sorted non-zero elements of a sparse vector along with their indices::

    printSortedSparseVector(x);


