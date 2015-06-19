Common utilities
=====================




.. highlight:: matlab





Problem Description
---------------------------------------------------


::

    pd = SPX_ProblemDescription(Dict, Phi, K, ...
                Representations, Signals, Measurements)
    pd.describe()


Number related utilities
---------------------------------------------------


::

    NumberUtil.findIntegerFactorsCloseToSquarRoot(n)


Others
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

    SPX_VectorsUtil.findFirstLessEqEnergy(X, energy)


Sparse Signals
----------------------------------

Sparse support for a vector::

    SPX_SupportUtil.support(x)

l_0 "norm" of a vector::

    SPX_SupportUtil.l0norm(x)

Support intersection ratio::

    SPX_SupportUtil.intersectionRatio(s1, s2)

Support similarity::

    SPX_SupportUtil.supportSimilarity(X, reference)

Support similarities between two sets of signals::

    SPX_SupportUtil.supportSimilarities(X, Y)

Support detection ratios ::

    SPX_SupportUtil.supportDetectionRate(X, trueSupport)


K largest indices over a set of vectors::

     SPX_SupportUtil.dominantSupportMerged(data, K)



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


