Comparing signals
===============================

.. highlight:: matlab


Comparing sparse or approximately sparse signals
---------------------------------------------------

``spx.commons.SparseSignalsComparison`` class provides a number of
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
    Noise = spx.data.noise.Basic.createNoise(XMS, SNR);
    Y = X;
    Y(Omega, :) = Y(Omega, :) + Noise;

Let us create an instance of sparse signal comparison class::

    cs = spx.commons.SparseSignalsComparison(X, Y, K);

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
truly sparse, then ``spx.commons.signalsComparison``
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
we have another helper utility class ``spx.commons.signalsComparison``. 

Assuming X is a signal matrix (with each column treated
as a signal), and Y is its noisy version, 
we created the signal comparison instance as::

    cs = spx.commons.signalsComparison(X, Y);

Most functions are similar to what we had for
``spx.commons.SparseSignalsComparison``::

    cs.difference_norms()
    cs.reference_norms()
    cs.estimate_norms()
    cs.error_to_signal_norms()
    cs.signal_to_noise_ratios()
    cs.summarize()


