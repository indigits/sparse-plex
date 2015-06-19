Common utilities
=====================




.. highlight:: matlab


Simple checks on matrices
---------------------------------------------------

Let us create a simple matrix::

    A = magic(3);

Checking whether the matrix is a square matrix::

    SPX_Checks.is_square(A)

Checking if it is symmetric::

    SPX_Checks.is_symmetric(A)

Checking if it is a Hermitian matrix::

    SPX_Checks.is_hermitian(A)


Checking if it is a positive definite matrix::

    SPX_Checks.is_positive_definite(A)


Distance measurement utilities
---------------------------------------------------

Let ``X`` be a matrix. Treat each column of ``X``
as a signal.

Euclidean distance between each signal pair can be computed by::

    SPX_Distance.pairwise_distances(X)

If ``X`` contains N signals, then the result 
is an ``N x N`` matrix whose (i, j)-th entry
contains the distance between i-th and j-th
signal. Naturally, the diagonal elements are all 
zero.

An additional second argument can be
provided to specify the distance measure
to be used. See the documentation of
MATLAB ``pdist`` function for supported
distance functions.

For example, for measuring city-block
distance between each pair of signals, use::

    SPX_Distance.pairwise_distances(X, 'cityblock')



Following dedicated functions are faster.

Squared :math:`\ell_2` distances between all pairs
of columns of X::

    SPX_Distance.sqrd_l2_distances_cw(X)


Squared :math:`\ell_2` distances between all pairs
of rows of X::

    SPX_Distance.sqrd_l2_distances_rw(X)

Matrix
---------------------------------------------------


::

    SPX_Mat.off_diagonal_elements(X)
    SPX_Mat.off_diagonal_matrix(X)
    SPX_Mat.off_diag_upper_tri_elements(X)
    SPX_Mat.off_diag_upper_tri_matrix(X)
    SPX_Mat.nonzero_density(X)


Norm utilities
---------------------------------------------------

These functions help in computing norm or
normalizing signals in a signal matrix.

Compute :math:`\ell_1` norm of each column vector::

    SPX_Norm.norms_l1_cw(X)


Compute :math:`\ell_2` norm of each column vector::

    SPX_Norm.norms_l2_cw(X)
    

Compute :math:`\ell_{\infty}` norm of each column vector::

    SPX_Norm.norms_linf_cw(X)
    

Normalize each column vector w.r.t. :math:`\ell_1` norm::

    SPX_Norm.normalize_l1(X)
    
Normalize each column vector w.r.t. :math:`\ell_2` norm::

    SPX_Norm.normalize_l2(X)
    
Normalize each row vector w.r.t. :math:`\ell_2` norm::

    SPX_Norm.normalize_l2_rw(X)
    
Normalize each column vector w.r.t. :math:`\ell_{\infty}` norm::

    SPX_Norm.normalize_linf(X)
    

Scale each column vector by a separate factor::

    SPX_Norm.scale_columns(X, factors)
    
Scale each row vector by a separate factor::
    
    SPX_Norm.scale_rows(X, factors)
    
Compute  the inner product of each column vector in A
with each column vector in B::

    SPX_Norm.inner_product_cw(A, B)



Comparing sparse or approximately sparse signals
---------------------------------------------------

``SPX_SparseSignalsComparison`` class provides a number of
methods to compare two sets of sparse signals. It is
typically used to compare a set of original sparse signals
with corresponding recovered sparse signals.

Let us create two signals of size (N=256)
with sparsity level (K=4) with the
non-zero entries having magnitude chosen
uniformly between [1,2]::

    N = 256;
    K = 4;
    % Constructing a sparse vector
    % Choosing the support randomly
    Omega = randperm(N, K);
    % Number of signals
    S = 2;
    % Original signals
    X = zeros(N, S);
    % Choosing non-zero values uniformly between (-b, -a) and (a, b)
    a = 1;
    b = 2; 
    % unsigned magnitudes of non-zero entries
    XM = a + (b-a).*rand(K, S);
    % Generate sign for non-zero entries randomly
    sgn = sign(randn(K, S));
    % Combine sign and magnitude
    XMS = sgn .* XM;
    % Place at the right non-zero locations
    X(Omega, :) = XMS;

Let us create a noisy version of these
signals with noise only in the non-zero
entries at 15 dB of SNR::

    % Creating noise using helper function
    SNR = 15;
    Noise = SPX_NoiseGen.createNoise(XMS, SNR);
    Y = X;
    Y(Omega, :) = Y(Omega, :) + Noise;

Let us create an instance of sparse signal comparison class::

    cs = SPX_SparseSignalsComparison(X, Y, K);

Norms of difference signals [X - Y]::

    cs.difference_norms()

Norms of original signals [X]::

    cs.reference_norms()

Norms of estimated signals [Y]::

    cs.estimate_norms()


Ratios between signal error norms and original signal norms::

    cs.error_to_signal_norms()

SNR for each signal::

    cs.signal_to_noise_ratios()

In case the signals X and Y were not 
truly sparse, then ``SPX_SignalsComparison``
has the ability to sparsify them 
by choosing the ``K`` largest (magnitude)
entries for each signal in reference signal
set and estimated signal set. ``K``
is an input parameter taken by the class.

We can access the sparsified reference signals:: 

    cs.sparse_references()

We can access the sparsified estimated signals:: 

    cs.sparse_estimates()

We can also examine the support index set
for each sparsified reference signal::

    cs.reference_sparse_supports()

Ditto for the supports of sparsified estimated signals:: 

    cs.estimate_sparse_supports()

We can measure the support similarity ratio 
for each signal ::

    cs.support_similarity_ratios()

We can find out which of the signals have
a support similarity above a specified threshold::

    cs.has_matching_supports(1.0)

Overall analysis can be easily summarized
and printed for each signal::

    cs.summarize()

Here is the output ::

    Signal dimension: 256
    Number of signals: 2
    Combined reference norm: 4.56207362
    Combined estimate norm: 4.80070407
    Combined difference norm: 0.81126416
    Combined SNR: 15.0000 dB
    Specified sparsity level: 4

    Signal: 1
      Reference norm: 2.81008750
      Estimate norm: 2.91691022
      Error norm: 0.49971207
      SNR: 15.0000 dB
      Support similarity ratio: 1.00

    Signal: 2
      Reference norm: 3.59387311
      Estimate norm: 3.81292464
      Error norm: 0.63909106
      SNR: 15.0000 dB
      Support similarity ratio: 1.00




Signal space comparison
---------------------------------------------------

For comparing signals which are not sparse,
we have another helper utility class ``SPX_SignalsComparison``. 

Assuming X is a signal matrix (with each column treated
as a signal), and Y is its noisy version, 
we created the signal comparison instance as::

    cs = SPX_SignalsComparison(X, Y);

Most functions are similar to what we had for
``SPX_SparseSignalsComparison``::

    cs.difference_norms()
    cs.reference_norms()
    cs.estimate_norms()
    cs.error_to_signal_norms()
    cs.signal_to_noise_ratios()
    cs.summarize()




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


