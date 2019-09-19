Noise
=================

.. highlight:: matlab



Noise generation
------------------------

Gaussian noise::

    ng = spx.data.noise.Basic(N, S);
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
    signals = spx.data.synthetic.SparseSignalGenerator(N, K, S).gaussian();
    % Create noise at specific SNR level.
    snrDb = 10;
    noises = spx.data.noise.Basic.createNoise(signals, snrDb);
    % add signal to noise
    signals_with_noise = signals + noises;
    % Verify SNR level
    20 * log10 (spx.norm.norms_l2_cw(signals) ./ spx.norm.norms_l2_cw(noises))




Noise measurement
---------------------------------


SNR in dB::

    result = spx.snr.SNR(signals, noises)

SNR in dB from signal and reconstruction::

    reconstructions = signals_with_noise;
    result = spx.snr.recSNRdB(signals, reconstructions)

Signal energy in DB ::

    result = spx.snr.energyDB(signals)


Reconstruction SNR as energy ratio::

    result = spx.snr.recSNR(signal, reconstruction)

Error energy normalized by signal energy::

    result = spx.snr.normalizedErrorEnergy(signal, reconstruction)

Reconstruction SNRs over multiple signals in dB::

    result = spx.snr.recSNRsdB(signals, reconstructions)

Reconstruction SNRs over multiple signals as energy ratios::

    result = spx.snr.recSNRs(signals, reconstructions)

Signal energies::

    result = spx.snr.energies(signals)

Signal energies in dB::

    result = spx.snr.energiesDB(signals)

