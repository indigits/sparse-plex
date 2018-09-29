
 
Rademacher sensing matrices
===================================================

.. _sec:sm:rademacher_sensing_matrix:


In this section we collect several results related to Rademacher sensing matrices.


.. _def:sm:rademacher_sensing_matrix:

.. definition:: 

     
    .. index:: Rademacher sensing matrix
    

    
    A Rademacher sensing matrix  :math:`\Phi \in \RR^{M \times N}`  with  :math:`M < N`  is constructed by drawing each
    entry  :math:`\phi_{ij}`  independently from a Radamacher random distribution given by
    
    
    .. math::
        :label: eq:sm:scaled_rademacher_distribution
    
        \PP_X(x) = \frac{1}{2}\delta\left(x-\frac{1}{\sqrt{M}}\right) + \frac{1}{2}\delta\left(x+\frac{1}{\sqrt{M}}\right).
    
    
    Thus  :math:`\phi_{ij}`  takes a value  :math:`\pm \frac{1}{\sqrt{M}}`  with equal probability.


We can remove the scale factor  :math:`\frac{1}{\sqrt{M}}`  out of the matrix  :math:`\Phi`  writing


.. math:: 

    \Phi = \frac{1}{\sqrt{M}} \Chi

With that
we can draw individual entries of  :math:`\Chi`  from a simpler Rademacher distribution given by


.. math::
    :label: eq:sm:standard_rademacher_distribution

    \PP_X(x) = \frac{1}{2}\delta(x-1) + \frac{1}{2}\delta(x + 1).


Thus entries in  :math:`\Chi`  take values of  :math:`\pm 1`  with equal probability. 

This construction is useful since it allows us to implement the multiplication with 
 :math:`\Phi`  in terms of just additions and subtractions. The scaling can be implemented
towards the end in the signal processing chain.


We note that 


.. math::
    \EE(\phi_{ij}) = 0.




.. math::
    \EE(\phi_{ij}^2) = \frac{1}{M}.


Actually we have a better result with 


.. math::
    \phi_{ij}^2 = \frac{1}{M}.



We can write


.. math:: 

    \Phi = \begin{bmatrix}
    \phi_1 & \dots & \phi_N
    \end{bmatrix}

where  :math:`\phi_j \in \RR^M`  is a Rademacher random vector with independent entries.

We note that


.. math::
    \EE (\| \phi_j  \|_2^2) = \EE \left ( \sum_{i=1}^M \phi_{ij}^2 \right ) = \sum_{i=1}^M (\EE (\phi_{ij}^2)) = M \frac{1}{M} = 1.


Actually in this case we also have


.. math::
    \| \phi_j  \|_2^2 = 1.




Thus the squared length of each of the columns in  :math:`\Phi`  is  :math:`1` . 


.. _lem:sm:rademacher:random_vector_tail_bound:

.. lemma:: 


    
    Let  :math:`z \in \RR^M`  be a Rademacher random vector with i.i.d entries  :math:`z_i`   
    that take a value  :math:`\pm \frac{1}{\sqrt{M}}`  with equal probability. 
    Let  :math:`u \in \RR^M`  be an arbitrary unit norm vector. Then
    
    
    .. math::
        \PP \left ( | \langle z, u \rangle | > \epsilon \right ) \leq 2 \exp \left (- \epsilon^2 \frac{M}{2} \right ).
    

Representative values of this bound are plotted in 
 :ref:`fig:sm:rademacher:random_vector_tail_bound <fig:sm:rademacher:random_vector_tail_bound>`.


.. _fig:sm:rademacher:random_vector_tail_bound:

.. code:: 

    \centering 
    \includegraphics[width=0.95\textwidth]
    {dictionaries/images/img_rademacher_rand_vec_tail_bound.pdf}
    \caption{Tail bound for the probability of inner product of a Rademacher random vector with a 
    unit norm vector}

    





.. proof:: 

    This can be proven using Hoeffding inequality. To be elaborated later.


A particular application of this lemma is when  :math:`u`  itself is another (independently chosen) unit norm Rademacher
random vector. 

The lemma establishes that the probability of inner product of two independent unit norm 
Rademacher random vectors being large is very very small. 
In other words, independently chosen unit norm Rademacher random vectors are
incoherent with high probability.
This is a very useful result
as we will see later in measurement of coherence of Rademacher sensing matrices.


 
Joint correlation
----------------------------------------------------


Columns of  :math:`\Phi`  satisfy a joint correlation property (:cite:`tropp2007signal`) which is described in following lemma.


.. _lem:sm:ramemacher:joint_correlation_property:

.. lemma:: 


    
    Let  :math:`\{u_k\}`  be a sequence of  :math:`K`  vectors (where  :math:`u_k \in \RR^M` ) whose  :math:`l_2`  norms do not exceed one. Independently 
    choose  :math:`z \in \RR^M`  to be a random vector with i.i.d. entries
     :math:`z_i`   that take a value  :math:`\pm \frac{1}{\sqrt{M}}`  with equal probability. Then
    
    
    .. math::
        \PP\left(\max_{k} | \langle z,  u_k\rangle | \leq \epsilon \right) \geq 1  - 2 K \exp \left( - \epsilon^2 \frac{M}{2} \right).
    




.. proof:: 

    Let us call   :math:`\gamma = \max_{k} | \langle z,  u_k\rangle |` .
    
    We note that if for any  :math:`u_k` ,  :math:`\| u_k \|_2 <1`  and we increase the length of  :math:`u_k`  by scaling it, then  :math:`\gamma` 
    will not decrease and hence  :math:`\PP(\gamma \leq \epsilon)`  will not increase.
    Thus if we prove the bound for vectors  :math:`u_k`  with  :math:`\| u_k\|_2 = 1 \Forall 1 \leq k \leq K` , it will
    be applicable for all  :math:`u_k`  whose  :math:`l_2`  norms do not exceed one. Hence we will assume that  :math:`\| u_k \|_2 = 1` .
    
    From  :ref:`lem:sm:rademacher:random_vector_tail_bound <lem:sm:rademacher:random_vector_tail_bound>` we have
    
    
    .. math:: 
    
        \PP \left ( | \langle z, u_k \rangle | > \epsilon \right ) \leq 2 \exp \left (- \epsilon^2 \frac{M}{2} \right ).
    
    
    Now the event 
    
    
    .. math:: 
    
        \left \{ \max_{k} | \langle z,  u_k\rangle | > \epsilon \right \} = \bigcup_{ k= 1}^K \{| \langle z,  u_k\rangle | > \epsilon\}
    
    i.e. if any of the inner products (absolute value) is greater than  :math:`\epsilon`  then the maximum is greater.
    
    We recall Boole's inequality which states that
    
    
    .. math:: 
    
        \PP \left(\bigcup_{i} A_i \right) \leq \sum_{i} \PP(A_i).
    
    
    Thus
    
    
    .. math:: 
    
        \PP\left(\max_{k} | \langle z,  u_k\rangle | > \epsilon \right) \leq  2 K \exp \left (- \epsilon^2 \frac{M}{2} \right ).
    
    This gives us
    
    
    .. math::
        \begin{aligned}
        \PP\left(\max_{k} | \langle z,  u_k\rangle | \leq \epsilon \right) 
        &= 1 - \PP\left(\max_{k} | \langle z,  u_k\rangle | > \epsilon \right) \\
        &\geq 1 - 2 K \exp \left(- \epsilon^2 \frac{M}{2} \right).
        \end{aligned}
    
    


 
Coherence of Rademacher sensing matrix
----------------------------------------------------


We show that coherence of Rademacher sensing matrix is fairly small with high probability (adapted from :cite:`tropp2007signal`).


.. _lem:sm:rademacher:coherence:

.. lemma:: 


    
    Fix  :math:`\delta \in (0,1)` . For an  :math:`M \times N`  Rademacher sensing matrix  :math:`\Phi`  
    as defined in  :ref:`def:sm:rademacher_sensing_matrix <def:sm:rademacher_sensing_matrix>`, the coherence
    statistic 
    
    
    .. math::
        \mu \leq \sqrt{ \frac{4}{M} \ln \left( \frac{N}{\delta}\right)}
    
    with probability exceeding  :math:`1 - \delta` . 



.. _fig:sm:rademacher:coherence_bound:

.. proof:: 

    
    
    

    
    .. code:: 
    
        \centering 
        \includegraphics[width=0.95\textwidth]
        {dictionaries/images/img_rademacher_coherence_bound.pdf}
        \caption{Coherence bounds for Rademacher sensing matrices}
    
        
    
    
    
    We recall the definition of coherence as
    
    
    .. math:: 
    
        \mu = \underset{j \neq k}{\max} | \langle \phi_j, \phi_k \rangle | = \underset{j < k}{\max} | \langle \phi_j, \phi_k \rangle |.
    
    
    
    Since  :math:`\Phi`  is a Rademacher sensing matrix hence each column of  :math:`\Phi`  is unit norm column.
    Consider some  :math:`1 \leq j < k \leq N`  identifying columns  :math:`\phi_j`  and  :math:`\phi_k` . We note
    that they are independent of each other. Thus from 
     :ref:`lem:sm:rademacher:random_vector_tail_bound <lem:sm:rademacher:random_vector_tail_bound>` we have
    
    
    .. math:: 
    
        \PP \left ( |\langle \phi_j, \phi_k \rangle | > \epsilon \right  )  \leq 2 \exp \left (- \epsilon^2 \frac{M}{2} \right ).
    
    
    Now there are  :math:`\frac{N(N-1)}{2}`  such pairs of  :math:`(j, k)` . Hence by applying Boole's inequality
    
    
    .. math:: 
    
        \PP \left ( \underset{j < k} {\max} |\langle \phi_j, \phi_k \rangle | > \epsilon \right  )  
        \leq 2 \frac{N(N-1)}{2} \exp \left (- \epsilon^2 \frac{M}{2} \right )
        \leq N^2 \exp \left (- \epsilon^2 \frac{M}{2} \right ).
     
    Thus we have
    
    
    .. math:: 
    
        \PP \left ( \mu > \epsilon \right )\leq N^2 \exp \left (- \epsilon^2 \frac{M}{2} \right ).
    
    
    What we need to do now is to choose a suitable value of  :math:`\epsilon`  so that the R.H.S. of
    this inequality is simplified. 
    
    We choose
    
    
    .. math:: 
    
        \epsilon^2 = \frac{4}{M} \ln \left ( \frac{N}{\delta}\right ).
    
    This gives us
    
    
    .. math:: 
    
        \epsilon^2 \frac{M}{2} = 2 \ln \left ( \frac{N}{\delta}\right )
        \implies \exp \left (- \epsilon^2 \frac{M}{2} \right ) =  \left ( \frac{\delta}{N} \right)^2.
    
    
    Putting back we get
    
    
    .. math:: 
    
        \PP \left ( \mu > \epsilon \right )\leq N^2 \left ( \frac{\delta}{N} \right)^2 \leq \delta^2.
    
    
    This justifies why we need  :math:`\delta \in (0,1)` .
    
    Finally
    
    
    .. math:: 
    
        \PP \left ( \mu \leq   \sqrt{ \frac{4}{M} \ln \left( \frac{N}{\delta}\right)} \right )
        = \PP (\mu \leq \epsilon)  = 1 - \PP (\mu > \epsilon)
        > 1 - \delta^2 
    
    and
    
    
    .. math:: 
    
        1 - \delta^2 > 1 - \delta
    
    which completes the proof.


