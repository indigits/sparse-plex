.. _sec:sm:gaussian_sensing_matrix:

Gaussian sensing matrices
===================================================

In this section we collect several results related to Gaussian sensing matrices.

.. _def:sm:gaussian_sensing_matrix:

.. index:: Gaussian sensing matrix

.. definition:: 

    A Gaussian sensing matrix  :math:`\Phi \in \RR^{M \times N}`  with  :math:`M < N`  is constructed by drawing each
    entry  :math:`\phi_{ij}`  independently from a Gaussian random distribution  :math:`\Gaussian(0, \frac{1}{M})` .


We note that 

.. math::
    \EE(\phi_{ij}) = 0.

.. math::
    \EE(\phi_{ij}^2) = \frac{1}{M}.


We can write

.. math:: 
    \Phi = \begin{bmatrix}
    \phi_1 & \dots & \phi_N
    \end{bmatrix}

where  :math:`\phi_j \in \RR^M`  is a Gaussian random vector with independent entries.

We note that

.. math::
    \EE (\| \phi_j  \|_2^2) = \EE \left ( \sum_{i=1}^M \phi_{ij}^2 \right ) = \sum_{i=1}^M (\EE (\phi_{ij}^2)) = M \frac{1}{M} = 1.


Thus the expected value of squared length of each of the columns in  :math:`\Phi`  is  :math:`1` . 


 
Joint correlation
----------------------------------------------------


Columns of  :math:`\Phi`  satisfy a joint correlation property 
(:cite:`tropp2007signal`) which is described in following lemma.


.. _lem:sm:gaussian:joint_correlation_property:

.. lemma:: 

    Let  :math:`\{u_k\}`  be a sequence of  :math:`K`  vectors (where  :math:`u_k \in \RR^M` ) whose  :math:`l_2`  norms do not exceed one. Independently 
    choose  :math:`z \in \RR^M`  to be a random vector with i.i.d.  :math:`\Gaussian(0, \frac{1}{M})`  entries. Then
    
    
    .. math::
        \PP\left(\max_{k} | \langle z,  u_k\rangle | \leq \epsilon \right) \geq 1  -  K \exp \left( - \epsilon^2 \frac{M}{2} \right).
    




.. proof:: 

    Let us call   :math:`\gamma = \max_{k} | \langle z,  u_k\rangle |` .
    
    We note that if for any  :math:`u_k` ,  :math:`\| u_k \|_2 <1`  and we increase the length of  :math:`u_k`  by scaling it, then  :math:`\gamma` 
    will not decrease and hence  :math:`\PP(\gamma \leq \epsilon)`  will not increase.
    Thus if we prove the bound for vectors  :math:`u_k`  with  :math:`\| u_k\|_2 = 1 \Forall 1 \leq k \leq K` , it will
    be applicable for all  :math:`u_k`  whose  :math:`l_2`  norms do not exceed one. Hence we will assume that  :math:`\| u_k \|_2 = 1` .
    
    Now consider  :math:`\langle z, u_k \rangle` . Since  :math:`z`  is a Gaussian random vector, hence  :math:`\langle z, u_k \rangle` 
    is a Gaussian random variable. Since  :math:`\| u_k \| =1`  hence
    
    
    .. math:: 
    
        \langle z, u_k \rangle \sim \Gaussian \left(0, \frac{1}{M} \right).
    
    
    We recall a well known tail bound for Gaussian random variables which states that
    
    
    .. math:: 
    
        \PP_X ( | x | > \epsilon) \; = \; \sqrt{\frac{2}{\pi}} \int_{\epsilon \sqrt{N}}^{\infty} \exp \left( -\frac{x^2}{2}\right) d x
        \; \leq \; \exp \left (- \epsilon^2 \frac{M}{2} \right).
    
    
    Now the event 
    
    
    .. math:: 
    
        \left \{ \max_{k} | \langle z,  u_k\rangle | > \epsilon \right \} = \bigcup_{ k= 1}^K \{| \langle z,  u_k\rangle | > \epsilon\}
    
    i.e. if any of the inner products (absolute value) is greater than  :math:`\epsilon`  then the maximum is greater.
    
    We recall Boole's inequality which states that
    
    
    .. math:: 
    
        \PP \left(\bigcup_{i} A_i \right) \leq \sum_{i} \PP(A_i).
    
    
    Thus
    
    
    .. math:: 
    
        \PP\left(\max_{k} | \langle z,  u_k\rangle | > \epsilon \right) \leq  K \exp \left(- \epsilon^2 \frac{M}{2} \right).
    
    This gives us
    
    
    .. math::
        \begin{aligned}
        \PP\left(\max_{k} | \langle z,  u_k\rangle | \leq \epsilon \right) 
        &= 1 - \PP\left(\max_{k} | \langle z,  u_k\rangle | > \epsilon \right) \\
        &\geq 1 - K \exp \left(- \epsilon^2 \frac{M}{2} \right).
        \end{aligned}

