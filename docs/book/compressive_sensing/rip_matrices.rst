Matrices satisfying RIP
===================================================

.. highlight:: matlab


The natural question at this moment is how to construct matrices which satisfy RIP.

There are two different approaches


*  Deterministic approach
*  Randomized approach


Known deterministic approaches so far tend to require  :math:`M`  to be very large ( :math:`O(K^2 \ln N)`  or  :math:`O(KN^{\alpha}` ). 

We can overcome this limitation by randomizing matrix construction.

Construction process:

*  Input  :math:`M`  and  :math:`N` .
*  Generate  :math:`\Phi`  by choosing  :math:`\Phi_{ij}`  
   as independent realizations from some probability distribution.


Suppose that  :math:`\Phi`  is drawn from normal distribution.

It can be shown that the rank of  :math:`\Phi`  is  
:math:`M`  with probability 1. 


.. example:: Random matrices are full rank.

    We can verify this fact by doing a small computer simulation.
    
    .. literalinclude:: ./demo_random_matrix_rank.m
    
    Above program generates a number of random matrices and measures 
    their ranks. It verifies whether they are full rank or not.
    
    Here is a sample output:
    
    ::

        Number of trials: 10000
        Number of full rank matrices: 10000
        Percentage of full rank matrices: 100.00 %




Thus, if we choose  :math:`M=2K` ,  any subset of  
:math:`2K`  columns will be linearly independent.
The matrix will satisfy RIP with some  :math:`\delta_{2K} > 0`.

But this construction doesn't tell us exact value of  :math:`\delta_{2K}` .

In order to find out  :math:`\delta_{2K}`, 
we must consider all possible  :math:`K`-dimensional 
subspaces formed by columns of :math:`\Phi`. 

This is computationally impossible for reasonably large  
:math:`N`  and  :math:`K`.

What is the alternative?

We can start with a chosen value of  
:math:`\delta_{2K}`  and try to construct a matrix which matches 
it.


Before we proceed further, we should take a 
detour and review sub-Gaussian distributions in 
:ref:`this section <sec:subgaussian>`.

We now state the main theorem of this section.

.. theorem:: 

    Suppose that  :math:`X = [X_1, X_2, \dots, X_M]`  
    where each  :math:`X_i`  is i.i.d. with  
    :math:`X_i \sim \Sub (c^2)`  and
    :math:`\EE (X_i^2) = \sigma^2` . Then
    
    .. math::
         \EE (\| X\|_2^2) = M \sigma^2 
    
    Moreover, for any  :math:`\alpha \in (0,1)`  and for any  
    :math:`\beta \in [c^2/\sigma^2, \beta_{\text{max}}]`, there exists
    a constant  :math:`\kappa^* \geq 4`  depending only on   :math:`\beta_{\text{max}}`  and the ratio  :math:`\sigma^2/c^2`  such that
        
    .. math::
         \PP(\| X\|_2^2 \leq \alpha M \sigma^2) \leq \exp \left  ( -\frac{M(1-\alpha)^2}{\kappa^*} \right ) 
    
    and   
    
    .. math::
         \PP(\| X\|_2^2 \geq \beta M \sigma^2) \leq \exp \left  ( -\frac{M(\beta-1)^2}{\kappa^*} \right ) 


The theorem states that the length (squared) of the random vector 
:math:`X` is concentrated around its mean value. If we choose
:math:`\sigma` such that :math:`M \sigma^2 = 1`, then we have
:math:`\beta \leq \| X \|_2^2 \leq \alpha` with very high probability.


 
Conditions on random distribution for RIP
----------------------------------------------------


Let us get back to our business of constructing a matrix  :math:`\Phi`  using random distributions
which satisfies RIP with a given  :math:`\delta` .

We will impose some conditions on the random distribution.



*  We require that the distribution will yield a matrix that is norm-preserving. 
   This requires that
  
  .. math::
    :label: eq:rip_subgaussian_variance

        \EE (\Phi_{ij}^2) = \frac{1}{M}

  Hence variance of distribution should be  :math:`\frac{1}{M}`.
* We require that distribution is a sub-Gaussian distribution i.e. there exists 
  a constant  :math:`c > 0`  such that
  
  .. math::
    :label: eq:rip_subgaussian_mgf

        \EE(\exp(\Phi_{ij} t)) \leq \exp \left (\frac{c^2 t^2}{2} \right )

  This says that the moment generating function of the distribution is dominated 
  by a Gaussian distribution.
  
  In other words, tails of the distribution decay at least as fast as the 
  tails of a Gaussian distribution.

We will further assume that entries of  :math:`\Phi`  are strictly sub-Gaussian.
i.e. they must satisfy :eq:`eq:rip_subgaussian_mgf` with
  
.. math:: 

      c^2 = \EE (\Phi_{ij}^2) = \frac{1}{M}

Under these conditions we have the following result. 

.. corollary:: 

    Suppose that  :math:`\Phi`  is an  :math:`M\times N`  matrix whose entries  
    :math:`\Phi_{ij}`  are i.i.d. with :math:`\Phi_{ij}`  drawn according to a
    strictly sub-Gaussian distribution with  :math:`c^2 = \frac{1}{M^2}`.
    
    Let  :math:`Y = \Phi x`  for  :math:`x \in \RR^N`. 
    Then for any  :math:`\epsilon > 0`  and any  :math:`x \in \RR^N` ,
    
    .. math::
          \EE ( \| Y \|_2^2) = \| x \|_2^2
    
    and
    
    .. math::
          \PP ( \| Y \|^2_2 - \| x \|_2^2 \geq \epsilon \| x \|_2^2 ) \leq 2 \exp \left ( - \frac{M \epsilon^2}{\kappa^*} \right) 
    
    where  :math:`\kappa^* = \frac{2}{1 - \ln(2)} \approx 6.5178` .

This means that the norm of a sub-Gaussian random vector strongly concentrates 
about its mean.
 
Sub Gaussian random matrices satisfy the RIP
----------------------------------------------------

Using this result we now state that sub-Gaussian matrices satisfy the RIP.

.. theorem:: 

    Fix  :math:`\delta \in (0,1)` .  Let  :math:`\Phi`  be an  :math:`M\times N`  random matrix whose entries  :math:`\Phi_{ij}`  are i.i.d. with
    :math:`\Phi_{ij}`  drawn according to a strictly sub-Gaussian 
    distribution with  :math:`c^2 = \frac{1}{M}` . If
    
    .. math::
          M \geq \kappa_1 K \ln \left ( \frac{N}{K} \right ),
    
    then  :math:`\Phi`  satisfies the RIP of order  :math:`K`  with the 
    prescribed  :math:`\delta`  with probability exceeding 
    :math:`1 - 2e^{-\kappa_2 M}` , where  :math:`\kappa_1`  is arbitrary and
    
    .. math::
          \kappa_2 = \frac{\delta^2 }{2 \kappa^*}  - \frac{1}{\kappa_1} \ln \left ( \frac{42 e}{\delta} \right ) 
    
We note that this theorem achieves  :math:`M`  of the same order as 
the lower bound obtained in 
:ref:`this result <thm:rip_measurement_bound>` up to a constant. 

This is much better than deterministic approaches.
 
Advantages of random construction
----------------------------------------------------


There are a number of advantages of the random sensing matrix construction approach:


* One can show that for random construction, 
  the measurements are  *democratic*.
  This means that all measurements are equal in importance and 
  it is possible to recover the
  signal from any sufficiently large subset of the measurements.
  Thus by using random  :math:`\Phi`  one can be robust to the loss 
  or corruption of a small fraction of measurements.
* In general we are more interested in  :math:`x`  which is sparse 
  in some basis  :math:`\Psi` . In this setting,
  we require that  :math:`\Phi \Psi`  satisfy the RIP.
  Deterministic construction would explicitly require taking  
  :math:`\Psi`  into account.
  But if  :math:`\Phi`  is random, we can avoid this issue.
  If  :math:`\Phi`  is Gaussian and  :math:`\Psi`  is an orthonormal basis, 
  then one can easily show that  :math:`\Phi \Psi`  will also
  have a Gaussian distribution.
  Thus if  :math:`M`  is high,  :math:`\Phi \Psi`  will also satisfy RIP 
  with very high probability.

Similar results hold for other sub-Gaussian distributions as well.

 

