Noise
=================

.. highlight:: matlab



Noise generation
------------------------

Gaussian noise::

    ng = SPX_NoiseGen(N, S);
    sigma = 1;
    mean = 0;
    ng.gaussian(sigma, mean);

Creating noise at a specific SNR::

    % Sparse signal dimension
    N = 100;
    % Sparsity level
    K = 20;
    % Number of signals
    S = 4;
    % Create sparse signals
    signals = SPX_SparseSignalGenerator(N, K, S).gaussian();
    % Create noise at specific SNR level.
    snrDb = 10;
    noises = SPX_NoiseGen.createNoise(signals, snrDb);
    % add signal to noise
    signals_with_noise = signals + noises;
    % Verify SNR level
    20 * log10 (SPX_Norm.norms_l2_cw(signals) ./ SPX_Norm.norms_l2_cw(noises))




Noise measurement
---------------------------------


SNR in dB::

    result = SPX_SNR.SNR(signals, noises)

SNR in dB from signal and reconstruction::

    reconstructions = signals_with_noise;
    result = SPX_SNR.recSNRdB(signals, reconstructions)

Signal energy in DB ::

    result = SPX_SNR.energyDB(signals)


Reconstruction SNR as energy ratio::

    result = SPX_SNR.recSNR(signal, reconstruction)

Error energy normalized by signal energy::

    result = SPX_SNR.normalizedErrorEnergy(signal, reconstruction)

Reconstruction SNRs over multiple signals in dB::

    result = SPX_SNR.recSNRsdB(signals, reconstructions)

Reconstruction SNRs over multiple signals as energy ratios::

    result = SPX_SNR.recSNRs(signals, reconstructions)

Signal energies::

    result = SPX_SNR.energies(signals)

Signal energies in dB::

    result = SPX_SNR.energiesDB(signals)

