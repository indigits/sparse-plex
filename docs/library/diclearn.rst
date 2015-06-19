Dictionary Learning
================================

.. highlight:: matlab




Utilities
----------------------

Measuring coherence and finding corresponding atoms::

    [ mu, i, j, absG ] = CS_DICTUtil.coherence( A )


Estimating the ratio of atoms matching between original and learned Dictionary::

    result = CS_DICTUtil.matchingAtomsRatio(original, new)

Plotting the contents of a dictionary::

    CS_DICTUtil.plotDictionary(dict);
