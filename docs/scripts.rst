Scripts
================

.. highlight:: matlab


Preamble
-------------------

::
    
    close all; clear all; clc;

Resetting random numbers::

    
    rng('default');


Export management flag::

    export = true;


Figures
---------------


Exporting figures::

    if export
    export_fig images\figure_name.png -r120 -nocrop;
    export_fig images\figure_name.pdf;
    end


Typical steps in figures::

    xlabel('Principal angle (degrees)');
    ylabel('Number of subspace pairs');
    title('Distribution of principal angles over subspace pairs in signal space');
    grid on;



.. rubric:: Math Symbols

Ignore this section. This is just for testing
some command definitions for mathjax.



:math:`\Tau \Chi, \Eta, \RR`

:math:`\spark`

:math:`\RRMN`

:math:`\CC \KK \Re{} \Im{} \Nat \NN \ZZ \EE \PP`

:math:`\QQ \II`

:math:`\FF \VV \WW \TT \UU \XX \HH`

:math:`\AAA \BBB \CCC \DDD \EEE \FFF \GGG \HHH \III \JJJ \KKK`
:math:`\LLL \MMM \NNN \OOO \PPP \QQQ \RRR \SSS \TTT`
:math:`\UUU \VVV \WWW \XXX \YYY \ZZZ`


:math:`\AA \BB \CC \DD \EE \FF \GG \HH \II \JJ \KK`


:math:`\NullSpace \ColSpace \RowSpace`

:math:`\Range{} \, \Kernel{} \,\Span{} \, \Image{} \,`
:math:`\Nullity{} \, \Dim\, \Rank\, \Trace\, \Diag\,`
:math:`\sgn \, \supp \, \rowsupp`
 
:math:`\abs\, \erf \, \erfc \, \Sub \, \SSub \, \Var\,\Cov\,`

:math:`\Power`

:math:`\forall\,\Forall\,`


:math:`\Bracket\,`


:math:`\Card{\SSS} \; \argmin (\SSS)  \; \argmax_{x \in A} \ZZZ`

:math:`\EmptySet`

:math:`\AffineHull \, \ConvexHull`

:math:`\Gaussian`


:math:`\spark \, \ERC \, \Maxcor\,`


.. rubric:: Environments

.. theorem::

    hello world


.. proposition::

    hello world
    
.. definition::

    hello world
    
.. lemma::

    hello world
    
.. example::

    hello world
    
.. example:: Title

    hello world
    
.. example:: Title

    hello world
    
.. example::

    hello world
    
.. exercise::

    hello world
    
