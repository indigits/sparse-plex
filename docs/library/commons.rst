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


Printing functions
-------------------------------


Print a sparse vector as pairs of indices and values::

    printSparseSignal(x)

Print the sorted non-zero elements of a sparse vector along with their indices::

    printSortedSparseSignal(x);


