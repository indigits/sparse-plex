
 
Examples
===================================================

In this section we will look at several examples
which can be modeled using sparse and redundant
representations and measured using compressed
sensing techniques.

Several examples in this section have been 
incorporated from Sparco :cite:`sparco:2007` (a testing framework
for sparse reconstruction).

 
Piecewise cubic polynomial signal
----------------------------------------------------


This example was discussed in :cite:`candRomb2004practical`.
Our signal of interest is a piecewise cubic polynomial signal
as shown in  :ref:`fig:ssm:piecewise_polynomial:signal <fig:ssm:piecewise_polynomial:signal>`. 
It has a sparse representation in a wavelet basis 
( :ref:`fig:ssm:piecewise_polynomial:representation <fig:ssm:piecewise_polynomial:representation>`).
We can sort the wavelet coefficients by magnitude and plot
them in descending order to visualize how sparse the 
representation is in  :ref:`fig:ssm:piecewise_polynomial:representation_sorted <fig:ssm:piecewise_polynomial:representation_sorted>`. The chosen basis is a Daubechies wavelet basis  :math:`\Psi` 
 :ref:`fig:ssm:piecewise_polynomial:dictionary <fig:ssm:piecewise_polynomial:dictionary>`.
A Gaussian random sensing matrix  :math:`\Phi`  
( :ref:`fig:ssm:piecewise_polynomial:sensing_matrix <fig:ssm:piecewise_polynomial:sensing_matrix>`)
is used to generate
the measurement vector  :math:`y`  
( :ref:`fig:ssm:piecewise_polynomial:measurements <fig:ssm:piecewise_polynomial:measurements>`).
Finally the product of  :math:`\Phi`  and  :math:`\Psi`  given by  :math:`\Phi \Psi`  
will be used for actual recovery of sparse representation
 :math:`\alpha`  from the measurements  :math:`y`  
( :ref:`fig:ssm:piecewise_polynomial:recovery_matrix <fig:ssm:piecewise_polynomial:recovery_matrix>`).
Fundamental equations are:


.. math:: 

    x = \Psi \alpha

and


.. math:: 

    y = \Phi x + e = \Phi \Psi \alpha + e.

with  :math:`x \in \RR^N` . In this example  :math:`N = 2048` .
 :math:`\Psi`  is a complete dictionary of size  :math:`N \times N` .
Thus we have  :math:`D = N`  and  :math:`\alpha \in \RR^N` . 
 :math:`\Phi \in \RR^{M \times N}` . In this example, 
the number of measurements  :math:`M=600` . The 
measurement vector  :math:`y \in \RR^M` . For this problem
we chose  :math:`e = 0` . 

Sparse signal recovery problem is denoted as


.. math:: 

    \widehat{\alpha} = \text{recovery}(\Phi \Psi, y, K).

where  :math:`\widehat{\alpha}`  is a  :math:`K` -sparse approximation of  :math:`\alpha` .

Closely examining the coefficients in  :math:`\alpha`  we can note that
 :math:`\max(\alpha_i) = 78.0546` . Further if we put different thresholds
over magnitudes of entries in  :math:`\alpha`  we can find the number
of coefficients higher than the threshold as listed in 
 :ref:`tbl:ssm:piecewise_polynomial:nonzero_entries <tbl:ssm:piecewise_polynomial:nonzero_entries>`. 
A choice of  :math:`M = 600`  looks quite reasonable given the decay
of entries in  :math:`\alpha` .


.. _tbl:ssm:piecewise_polynomial:nonzero_entries:

.. code:: 

    \centering
    \caption{Entries in wavelet representation of piecewise cubic polynomial
    signal higher than a threshold}

    
    \begin{tabular}{c c}
    \hline
    Threshold & Entries higher than threshold \\
    \hline
    1 & 129\\
    1E-1 & 173\\
    1E-2 & 186\\
    1E-4 & 197\\
    1E-8 & 199\\
    1E-12 & 200\\
    \hline
    \end{tabular}




.. _fig:ssm:piecewise_polynomial:signal:

.. code:: 

    \centering
    \includegraphics[width=0.95\textwidth]
    {sparsemodels/images/piecewise_polynomial/signal.pdf}
    \caption{A piecewise cubic polynomials signal}

    




.. _fig:ssm:piecewise_polynomial:representation:

.. code:: 

    \centering
    \includegraphics[width=0.95\textwidth]
    {sparsemodels/images/piecewise_polynomial/representation.pdf}
    \caption{Sparse representation of signal in wavelet basis}

    



.. _fig:ssm:piecewise_polynomial:representation_sorted:

.. code:: 

    \centering
    \includegraphics[width=0.95\textwidth]
    {sparsemodels/images/piecewise_polynomial/representation_sorted.pdf}
    \caption{Wavelet coefficients sorted by magnitude}

    



.. _fig:ssm:piecewise_polynomial:measurements:

.. code:: 

    \centering
    \includegraphics[width=0.95\textwidth]
    {sparsemodels/images/piecewise_polynomial/measurements.pdf}
    \caption{Measurement vector  :math:`y = \Phi x + e` }

    



.. _fig:ssm:piecewise_polynomial:dictionary:

.. code:: 

    \centering
    \includegraphics[width=0.95\textwidth]
    {sparsemodels/images/piecewise_polynomial/dictionary.pdf}
    \caption{Daubechies-8 wavelet basis}

    



.. _fig:ssm:piecewise_polynomial:sensing_matrix:

.. code:: 

    \centering
    \includegraphics[width=0.95\textwidth]
    {sparsemodels/images/piecewise_polynomial/sensing_matrix.pdf}
    \caption{Gaussian sensing matrix  :math:`\Phi` }

    



.. _fig:ssm:piecewise_polynomial:recovery_matrix:

.. code:: 

    \centering
    \includegraphics[width=0.95\textwidth]
    {sparsemodels/images/piecewise_polynomial/recovery_matrix.pdf}
    \caption{Recovery matrix  :math:`\Phi \Psi` }

    
