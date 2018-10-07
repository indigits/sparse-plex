.. _sec:dic:dirac_hadamard_dictionary:


Dirac-Hadamard dictionary
===================================================

.. highlight:: matlab


.. index:: Dirac-Hadamard dictionary

.. definition:: 

    The Dirac-Hadamard dictionary is a two-ortho dictionary consisting of 
    the union of the Dirac and the Hadamard bases. 


This dictionary is suitable for real signals since both Dirac and
Hadamard are totally real bases  :math:`\in \RR^{N \times N}`. 

:math:`N`, :math:`N/12` or :math:`N/20` must be a power of 
2 to allow for the construction of Hadamard matrix.


Hadamard matrix is special in the sense that all the
entries are either 1 or -1. Thus, multiplication with 
the matrix can be achieved by simple additions and
subtractions::


    >> A = hadamard(12)

    A =

         1     1     1     1     1     1     1     1     1     1     1     1
         1    -1     1    -1     1     1     1    -1    -1    -1     1    -1
         1    -1    -1     1    -1     1     1     1    -1    -1    -1     1
         1     1    -1    -1     1    -1     1     1     1    -1    -1    -1
         1    -1     1    -1    -1     1    -1     1     1     1    -1    -1
         1    -1    -1     1    -1    -1     1    -1     1     1     1    -1
         1    -1    -1    -1     1    -1    -1     1    -1     1     1     1
         1     1    -1    -1    -1     1    -1    -1     1    -1     1     1
         1     1     1    -1    -1    -1     1    -1    -1     1    -1     1
         1     1     1     1    -1    -1    -1     1    -1    -1     1    -1
         1    -1     1     1     1    -1    -1    -1     1    -1    -1     1
         1     1    -1     1     1     1    -1    -1    -1     1    -1    -1

    >> A' * A

    ans =

        12     0     0     0     0     0     0     0     0     0     0     0
         0    12     0     0     0     0     0     0     0     0     0     0
         0     0    12     0     0     0     0     0     0     0     0     0
         0     0     0    12     0     0     0     0     0     0     0     0
         0     0     0     0    12     0     0     0     0     0     0     0
         0     0     0     0     0    12     0     0     0     0     0     0
         0     0     0     0     0     0    12     0     0     0     0     0
         0     0     0     0     0     0     0    12     0     0     0     0
         0     0     0     0     0     0     0     0    12     0     0     0
         0     0     0     0     0     0     0     0     0    12     0     0
         0     0     0     0     0     0     0     0     0     0    12     0
         0     0     0     0     0     0     0     0     0     0     0    12


While constructing the Dirac-Hadamard dictionary, we need to
ensure that the columns of the dictionary are normalized.


.. _sec:dirac-hadamard-dict:handson:

Hands-on with Dirac Hadamard dictionaries
-------------------------------------------


.. example:: Constructing a Dirac Hadamard dictionary

    We need to specify the dimension of the ambient space::

        N = 256;

    We are ready to construct the dictionary::

        Phi = spx.dict.simple.dirac_hadamard_mtx(N);

    Let's visualize the dictionary::

        imagesc(Phi);
        colorbar;


    .. figure:: images/demo_dirac_hadamard_1.png


    Measuring the coherence of the dictionary::

        >> spx.dict.coherence(Phi)

        ans =

            0.0625


    Let's construct the babel function for this dictionary::


        mu1 = spx.dict.babel(Phi);

    We can plot it::

        plot(mu1);
        grid on;

    .. figure:: images/demo_dirac_hadamard_babel.png


    We note that the babel function increases linearly
    for the initial part and saturates to a value
    of 16 afterwards.


.. example:: Normalization in Dirac Hadamard dictionary

    We can construct a Dirac Hadamard dictionary for
    a small size to see the effect of normalization::

        >> spx.dict.simple.dirac_hadamard_mtx(4)

        ans =

            1.0000         0         0         0    0.5000    0.5000    0.5000    0.5000
                 0    1.0000         0         0    0.5000   -0.5000    0.5000   -0.5000
                 0         0    1.0000         0    0.5000    0.5000   -0.5000   -0.5000
                 0         0         0    1.0000    0.5000   -0.5000   -0.5000    0.5000

