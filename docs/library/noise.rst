Noise
=================

.. highlight:: matlab



Noise generation
------------------------

Gaussian noise::

    ng = CS_NoiseGenerator(N, S);
    ng.gaussian(sigma, mean);

Creating noise at a specific SNR::

    noises = CS_NoiseGenerator.createNoise(signals, snrDb)




Noise measurement
---------------------------------


SNR in dB::

    result = CS_SNRUtil.SNR(signal, noise)

SNR in dB from signal and reconstruction::

    result = CS_SNRUtil.recSNRdB(signal, reconstruction)

Signal energy in DB ::

    result = CS_SNRUtil.energyDB(signal)


Reconstruction SNR as energy ratio::

    result = CS_SNRUtil.recSNR(signal, reconstruction)

Error energy normalized by signal energy::

    result = CS_SNRUtil.normalizedErrorEnergy(signal, reconstruction)

Reconstruction SNRs over multiple signals in dB::

    result = CS_SNRUtil.recSNRsdB(signals, reconstructions)

Reconstruction SNRs over multiple signals as energy ratios::

    result = CS_SNRUtil.recSNRs(signals, reconstructions)

Signal energies::

    result = CS_SNRUtil.energies(signals)

Signal energies in dB::

    result = CS_SNRUtil.energiesDB(signals)

