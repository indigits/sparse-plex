Dictionaries with Wavelet Toolbox
=====================================

MATLAB Wavelet Toolbox provides good support for 
constructing multi-basis dictionaries 
(dictionaries that are constructed by 
concatenating one or more 
subdictionaries which are
either orthogonal bases or
wavelet packets).


Constructing Dictionaries
----------------------------------


.. example:: Dirac DCT Dictionary


    We need to specify the dimension
    of the signal space :math:`\RR^N`::

        N  = 32;

    We can now construct the dictionary::

        Phi = wmpdictionary(N, 'lstcpt', {'RnIdent', 'dct'});

    .. figure:: images/wmp_dirac_dct_N_32.png


    The name-value pair argument ``lstcpt`` 
    takes the list of constituent subdictionaries.


.. example:: Symlet DCT Dictionary

    We wish to combine a symlet ONB 
    with 4 vanishing moments and
    5 level decomposition and a DCT basis


    We can now construct the dictionary::

        N = 256;
        [Phi, nb_atoms] = wmpdictionary(N, 'lstcpt', { {'sym4', 5}, 'dct'});

    .. figure:: images/wmp_sym4_dct_N_256.png

    The vector ``nb_atoms`` tells us the number
    of atoms in each subdictionary::

        >> nb_atoms
        nb_atoms =

            256   256

.. example:: Symlet, Symlet Packets, DCT Dictionary

    Here we will combine symlets with the
    wavelet packet version of symets and
    DCT ONB. 

    #. symlet with 4 vanishing moments and 5 level
       decomposition
    #. wavelet packet symlet with 4 vanishing
       moments and 5 level decomposition
    #. DCT basis


    ::

        N = 256;
        [Phi, nb_atoms] = wmpdictionary(N, 'lstcpt', { {'sym4', 5}, {'wpsym4', 5}, 'dct'});

    .. figure:: images/wmp_sym4_wpsym4_dct_N_256.png


    We can visualize the atoms in this dictionary one by one.
    ``sparse-plex`` provides a method to visualize the
    atoms one by one and save the visualizations in the
    form of an MP4 video file::

        spx.graphics.multi_basis_dict_movie('sym4_wpsym4_dct.mp4', ...
        Phi, nb_atoms, {'sym4', 'wpsym4', 'dct'})

    We have specified the name of the output video file,
    the dictionary to be visualized, number of atoms
    in each subdictionary and names of subdictionaries.

    .. youtube:: XwKnOaJg8BY
