
 
Compressed sensing
===================================================

.. _sec:compressed_sensing:

In this section we formally define the problem of compressed sensing. 

 **Compressed sensing**  refers to the idea that for sparse or compressible signals, a small
number of nonadaptive measurements carries sufficient information to approximate
the signal well. In the literature it is also known as
 **compressive sensing**  and  **compressive sampling** . Different
authors seem to prefer different names. In this book we will 
stick to the name as compressed sensing.

In this section we will represent a signal dictionary as well as its synthesis matrix as  :math:`\DD` . 

We recall the definition of sparse signals from  :ref:`def:ssm:D_K_sparse_signal <def:ssm:D_K_sparse_signal>`.

A signal  :math:`x \in \CC^N`  is  :math:`K` -sparse in  :math:`\DD`  if there exists a representation  :math:`\alpha`  for  :math:`x`  which
has at most  :math:`K`  non-zeros. i.e.


.. math:: 

    x = \DD \alpha

and 


.. math:: 

    \| \alpha \|_0 \leq K.


The dictionary could be standard basis, Fourier basis, wavelet basis, a wavelet packet dictionary,
a multi-ONB or even a randomly generated dictionary. 

Real life signals are not sparse, yet they are compressible in the sense that entries in the
signal decay rapidly when sorted by magnitude. As a result compressible signals are well
approximated by sparse signals. Note that we are talking about the sparsity or compressibility
of the signal in a suitable dictionary. Thus we mean that the signal  :math:`x`  has a representation
 :math:`\alpha`  in  :math:`\DD`  in which the coefficients decay rapidly when sorted by magnitude. 


.. _def:ssm:compressed_sensing:

.. definition:: 

     
    .. index:: Sensing matrix
    
     
    .. index:: Measurement vector
    
     
    .. index:: Signal space
    
     
    .. index:: Measurement space
    

    
    In compressed sensing, a  **measurement**  is a linear functional applied to a signal
    
    
    .. math:: 
    
        y = \langle x, f \rangle.
    
    
    The compressed sensor makes multiple such linear measurements. This can best be represented
    by the action of a  **sensing matrix**   :math:`\Phi`  on the signal  :math:`x`  given by 
    
    
    .. math::
        y = \Phi x
    
    
    where  :math:`\Phi \in \CC^{M \times N}`  represents  :math:`M`  different measurements made on the signal  :math:`x` 
    by the sensing process. Each row of  :math:`\Phi`  represents one linear measurement.
    
    The vector  :math:`y \in \CC^M`  is known as  **measurement vector** .
    
     :math:`\CC^N`  forms the  **signal space**  while  :math:`\CC^M`  forms the  **measurement space** .
    
    We also note that above can be written as
    
    
    .. math:: 
    
        y  = \Phi x = \Phi \DD \alpha = (\Phi \DD) \alpha.
    
    
    It is assumed that the signal  :math:`x`  is  :math:`K` -sparse or  :math:`K` -compressible in  :math:`\DD`  and  :math:`K \ll N` .
    
    The objective is to recover  :math:`x`  from  :math:`y`  given that  :math:`\Phi`  and  :math:`\DD`  are known.
    
    We do this by first recovering the sparse representation  :math:`\alpha`  from  :math:`y`  and then
    computing  :math:`x = \DD \alpha` .
    
    If  :math:`M \geq N`  then the problem is a straight forward least squares problem. So we don't consider it here.
    
    The more interesting case is when  :math:`K < M \ll N`  i.e. the number of measurements is much less
    than the dimension of the ambient signal space while more than the sparsity level of signal namely  :math:`K` .
    
    We note that given  :math:`\alpha`  is found, finding  :math:`x`  is straightforward.  
    We therefore can remove the dictionary from our consideration and look at
    the simplified problem given as: recover  :math:`x`  from  :math:`y`  with
    
    
    .. math:: 
    
        y = \Phi x
    
    where  :math:`x \in \CC^N`  itself is assumed to be  :math:`K` -sparse or  :math:`K` -compressible 
    and  :math:`\Phi \in \CC^{M \times N}`  is the sensing matrix.


 
The sensing matrix
----------------------------------------------------

.. _sec:ssm:sensing_matrix:

 
.. index:: Sensing matrix

 
.. index:: Sensing vector


There are two ways to look at the sensing matrix. First view is in terms of its columns


.. math::
    :label: eq:ssm:sensing_matrix_column_view

    \Phi = \begin{bmatrix}
    \phi_1 & \phi_2 & \dots & \phi_N
    \end{bmatrix}

where  :math:`\phi_i \in \CC^M`  are the columns of sensing matrix.  In this view we see that


.. math:: 

    y = \sum_{i=1}^{N} x_i \phi_i

i.e.  :math:`y`  belongs to the column span of  :math:`\Phi`  and one representation of  :math:`y`  in  :math:`\Phi` 
is given by  :math:`x` .

This view looks very similar to a dictionary and its atoms but there is a difference.
In a dictionary, we require each atom to be unit norm. We don't require columns of
the sensing matrix  :math:`\Phi`  to be unit norm.

The second view of sensing matrix  :math:`\Phi`  is in terms of its columns. We write


.. math::
    :label: eq:ssm:sensing_matrix_row_view

    \Phi = \begin{bmatrix}
    \chi_1^H \\
    \chi_2^H \\
    \vdots \\
    \chi_M^H
    \end{bmatrix}

where  :math:`\chi_i \in \CC^N`  are conjugate transposes of rows of  :math:`\Phi` . This view gives
us following result


.. math::
    :label: eq:equation_label

    \begin{bmatrix}
    y_1\\
    y_2 \\
    \vdots
    y_M
    \end{bmatrix}
    = \begin{bmatrix}
    \chi_1^H \\
    \chi_2^H \\
    \vdots \\
    \chi_M^H
    \end{bmatrix}
    x
    = \begin{bmatrix}
    \chi_1^H x\\
    \chi_2^H x\\
    \vdots \\
    \chi_M^H x
    \end{bmatrix}
    = \begin{bmatrix}
    \langle x , \chi_1 \rangle \\
    \langle x , \chi_2 \rangle \\
    \vdots \\
    \langle x , \chi_M \rangle \\
    \end{bmatrix}


In this view  :math:`y_i`  is a measurement given by the inner product of  :math:`x`  with  :math:`\chi_i`  
 :math:`( \langle x , \chi_i \rangle = \chi_i^H x)` . 

We will call  :math:`\chi_i`  as a  **sensing vector** . There are  :math:`M`  such sensing vectors in  :math:`\CC^N` 
comprising  :math:`\Phi`  corresponding to  :math:`M`  measurements in the measurement space  :math:`\CC^M` .

 
Number of measurements
----------------------------------------------------

A fundamental question of compressed sensing framework is: \emph{How many measurements are 
necessary to acquire  :math:`K` -sparse signals}? By necessary we mean that  :math:`y`  carries
enough information about  :math:`x`  such that  :math:`x`  can be recovered from  :math:`y` . 

Clearly if  :math:`M < K`  then recovery is not possible. 

We further note that the sensing matrix  :math:`\Phi`  should not map two different  :math:`K` -sparse
signals to the same measurement vector. Thus we will need  :math:`M \geq 2K`  and each
collection of  :math:`2K`  columns in  :math:`\Phi`  must be non-singular. 

If the  :math:`K` -column  sub matrices of  :math:`\Phi`  are badly conditioned, then it is possible that
some sparse signals get mapped to very similar measurement vectors. Thus it is numerically unstable
to recover the signal. Moreover, if noise is present, stability further degrades. 

In :cite:`candes2006near` Cand\`es and Tao  showed that the geometry of sparse
signals should be preserved under the action of a sensing matrix. In particular
the distance between two sparse signals shouldn't change by much during sensing.

They quantified this idea in the form of a  *restricted isometric constant*  of a matrix
 :math:`\Phi`  as the smallest number  :math:`\delta_K`  for which the following holds


.. math:: 

    (1 - \delta_K) \| x \|_2^2 \leq \| \Phi x \|_2^2 \leq (1 + \delta_K) \| x \|_2^2 \Forall x : \| x \|_0 \leq K.


We will study more about this property known as restricted isometry property (RIP) 
in  :ref:`sec:proj:restricted_isometry_property <sec:proj:restricted_isometry_property>`. Here we
just sketch the implications of RIP for compressed sensing.

When  :math:`\delta_K < 1`  then the inequalities imply that every collection of  :math:`K`  columns from  :math:`\Phi`  is
non-singular. Since we need every collection of  :math:`2K`  columns to be non-singular, we actually need
 :math:`\delta_{2K} < 1`  which is the minimum requirement for recovery of  :math:`K`  sparse signals. 

Further if  :math:`\delta_{2K} \ll 1`  then we note that sensing operator very nearly maintains the
 :math:`l_2`  distance between any two  :math:`K`  sparse signals. In consequence, it is possible to invert
the sensing process stably.

It is now known that many randomly generated matrices have excellent RIP behavior. One can show 
that if  :math:`\delta_{2K} \leq 0.1` , then with 


.. math:: 

    M = \bigO{K \ln ^{\alpha} N}

measurements, one can recover  :math:`x`  with high probability. 

Some of the typical random matrices which have suitable RIP properties are
\begin{itemize}
\item Gaussian sensing matrices
\item Partial Fourier matrices
\item Rademacher sensing matrices
\end{itemize}



 
Signal recovery
----------------------------------------------------

.. _sec:sparse_reovery:

The second fundamental problem in compressed sensing is: \emph{Given the compressed
measurements  :math:`y`  how do we recover the signal  :math:`x` }? This problem is known as  :textsc:`SPARSE-RECOVERY` 
problem.

A simple formulation of the problem as: minimize  :math:`\| x \|_0`  subject to  :math:`y = \Phi x`  is hopeless
since it entails a combinatorial explosion of search space.  

Over the years, people have developed a number of algorithms to tackle the sparse recovery problem.

The algorithms can be broadly classified into following categories
\begin{description}
\item[Greedy pursuits] These algorithms attempt to build the approximation of the signal iteratively
by making locally optimal choices at each step. Examples of such algorithms include
OMP (orthogonal matching pursuit), stage-wise OMP, regularized OMP, CoSaMP (compressive sampling pursuit)
and IHT (iterative hard thresholding). 
\item [Convex relaxation] These techniques relax the  :math:`l_0`  ``norm'' minimization problem into a suitable 
problem which is a convex optimization problem. This relaxation is valid for a large class of signals of interest.
Once the problem has been formulated as a convex optimization problem, a number of solutions are available, e.g. 
interior point methods, projected gradient methods and iterative thresholding.  
\item [Combinatorial algorithms] These methods are based on research in group testing and are specifically
suited for situations where highly structured measurements of the signal are taken. This class includes
algorithms like Fourier sampling, chaining pursuit, and HHS pursuit. 
\end{description}

A major emphasis of the following chapters will be the study of these sparse recovery algorithms.

In the following we present examples of real life problems which can be modeled as compressed sensing
problems.

 
Error correction in linear codes
----------------------------------------------------

The classical error correction problem was discussed in one of the 
seminal founding papers on compressed sensing :cite:`candes2005decoding`.

Let  :math:`f \in \RR^N`  be a ``plaintext'' message being sent over a communication channel.

In order to make the message robust against errors in communication channel, we encode 
the error with an error correcting code.

We consider  :math:`A \in \RR^{D \times N}`  with  :math:`D > N`  as a  **linear code** .  :math:`A`  is essentially
a collection of code words given by


.. math::
    A = \begin{bmatrix}
    a_1 & a_2 & \dots & a_N 
    \end{bmatrix}

where  :math:`a_i \in \RR^D`  are the codewords.

We construct the ``ciphertext''  


.. math::
    x = A f

where  :math:`x \in \RR^D`  is sent over the communication channel.  Clearly  :math:`x`  is
a redundant representation of  :math:`f`  which is expected to be robust against 
small errors during transmission.

 :math:`A`  is assumed to be full column rank. Thus  :math:`A^T A`  is invertible and we can easily see that


.. math:: 

    f = A^{\dag} x 

where


.. math:: 

    A^{\dag} = (A^T A)^{-1}A^T

is the left pseudo inverse of  :math:`A` .

But naturally the communication channel is going to add some error. What we actually receive is


.. math::
    y = x + e = A f + e


where  :math:`e \in \RR^D`  is the error being introduced by the channel.

The least squares solution by minimizing the error  :math:`l_2`  norm is given by 


.. math:: 

    f' = A^{\dag} y = A^{\dag} (A f + e) = f + A^{\dag} e.


Since  :math:`A^{\dag} e`  is usually non-zero (we cannot assume that  :math:`A^{\dag}`  will annihilate  :math:`e` ), hence
 :math:`f'`  is not an exact replica of  :math:`f` . 

What is needed is an exact reconstruction of  :math:`f` . To achieve this, 
a common assumption in literature is that 
error vector  :math:`e`  is in fact sparse. i.e. 


.. math::
    \| e \|_0 \leq K \ll D.


To reconstruct  :math:`f`  it is sufficient to reconstruct  :math:`e`  since once  :math:`e`  is known we can get


.. math:: 

    x  = y -e

and from there  :math:`f`  can be faithfully reconstructed.

The question is: for a given sparsity level  :math:`K`  for the error vector  :math:`e`  can one reconstruct
 :math:`e`  via practical algorithms? By practical we mean algorithms which are of polynomial
time w.r.t. the length of ``ciphertext'' (D).

The approach in :cite:`candes2005decoding` is as follows. 

We construct a matrix  :math:`F \in \RR^{M \times D}`  which can annihilate  :math:`A`  i.e.


.. math:: 

    FA  = 0.


We then apply  :math:`F`  to  :math:`y`  giving us


.. math:: 

    \tilde{y} = F (A f + e) = Fe.


Therefore the decoding problem is reduced to that of reconstructing a sparse vector  :math:`e \in \RR^D` 
from the measurements  :math:`Fe \in \RR^M`  where we would like to have  :math:`M \ll D` . 

With this the problem of finding  :math:`e`  can be cast as problem of finding a sparse solution
for the under-determined system given by



.. math::
    :label: eq:ssm:error_correction_k_sparse_error

    \begin{aligned}
      & \underset{e \in \Sigma_K}{\text{minimize}} 
      & &  \| e \|_0 \\
      & \text{subject to}
      & &  \tilde{y} = F e\\
    \end{aligned}
    \tag{ :math:`P_0` }


This now becomes the compressed sensing problem. The natural questions are
\begin{itemize}
\item How many measurements  :math:`M`  are necessary (in  :math:`F` ) to be able to recover  :math:`e`  exactly? 
\item How should  :math:`F`  be constructed?
\item How do we recover  :math:`e`  from  :math:`\tilde{y}` ?
\end{itemize}

Bibliography
-------------------


.. bibliography:: ../../sksrrcs.bib
    