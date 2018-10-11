
.. _sec:ssm:babel:

Babel function
====================================================

Recalling the definition of coherence, we note that 
it reflects only the extreme correlations between atoms of dictionary.
If most of the inner products are small compared to one dominating inner product, then the value of
coherence is highly misleading.

In :cite:`tropp2004greed`, Tropp introduced  **Babel function** , which measures the maximum
total coherence between a fixed atom and a collection of other atoms.
The  *Babel function*  quantifies an idea as to how much the atoms of a dictionary are 
*speaking the same language*.


.. _def:babel_function:

.. definition:: 

     
    .. index:: Babel function
    

    
    The  *Babel function*  for a dictionary  :math:`\DDD` is defined by
    
    
    .. math::
        :label: eq:ssm:babel_function
    
        \mu_1(p) \triangleq \underset{|\Lambda| = p}{\max} \; \underset {\psi}{\max} 
        \sum_{\Lambda} | \langle \psi, d_{\lambda} \rangle |,
    
    where the vector  :math:`\psi` ranges over the atoms indexed by  :math:`\Omega \setminus \Lambda`.
    We define 
    
    
    .. math:: 
    
        \mu_1(0) = 0
    
    for sparsity level  :math:`p=0`.


Let us understand what is going on here.
For each value of  :math:`p` we consider all possible  :math:`\binom{D}{p}` subspaces by choosing  :math:`p` 
vectors from  :math:`\mathcal{D}`. 

Let the atoms spanning one such subspace be identified by an index set  :math:`\Lambda \subset \Omega`.

All other atoms are indexed by the index set  :math:`\Gamma = \Omega \setminus \Lambda`.

Let 


.. math:: 

    \Psi = \{ \psi_{\gamma} : \gamma \in \Gamma \}


denote the atoms indexed by  :math:`\Gamma`.

We pickup a vector  :math:`\psi \in \Psi` and compute its inner product with all atoms indexed by  :math:`\Lambda`.
We compute the sum of absolute value of these inner products over all  :math:`\{ d_{\lambda} : \lambda \in \Lambda\}`.

We run it for all  :math:`\psi \in \Psi` and then pickup the maximum value of above sum over all  :math:`\psi`.

We finally compute the maximum over all possible  :math:`p`-subspaces. 

This number is considered at the Babel number for sparsity level  :math:`p`.

We first make a few observations over the properties of Babel function.

Babel function is a generalization of coherence. 


.. remark:: 

    For  :math:`p=1` we observe that 
    
    
    .. math:: 
    
        \mu_1(1) = \mu(\DDD)
    
    the coherence of  :math:`\mathcal{D}`.




.. remark:: 

     :math:`\mu_1` is a non-decreasing function of  :math:`p`. 



.. proof:: 

    This is easy to see since the sum 
    
    
    .. math:: 
    
        \sum_{\Lambda} | \langle \psi, d_{\lambda} \rangle |
    
    cannot decrease as  :math:`p = | \Lambda|` increases. 
    
    In particular for some value of  :math:`p` let  :math:`\Lambda^p` and  :math:`\psi^p` denote the set and vector for which 
    the maximum in  :eq:`eq:ssm:babel_function` is achieved. 
    Now pick some column which is not
    :math:`\psi^p` and is not indexed by  
    :math:`\Lambda^p` and include it for  :math:`\Lambda^{p + 1}`. 
    Note that  :math:`\Lambda^{p + 1}` and  :math:`\psi^p` 
    might not be the worst case for sparsity level  :math:`p+1` 
    in  :eq:`eq:ssm:babel_function`.
    Clearly
    
    
    .. math:: 
    
        \sum_{\Lambda^{p + 1}} | \langle \psi^p, d_{\lambda} \rangle | \geq \sum_{\Lambda^{p}} | \langle \psi^p, d_{\lambda} \rangle |
    
    :math:`\mu_1(p+1)` cannot be less than  :math:`\mu_1(p)`.
    



.. _lem:ssm:babel_function_upper_bound:

.. lemma:: 

     
    .. index:: Babel function upper bound
    

    
    Babel function is upper bounded by coherence as per
    
    
    .. math::
        \mu_1(p) \leq p \; \mu(\DDD).
    




.. proof:: 

    
    
    .. math:: 
    
        \sum_{\Lambda} | \langle \psi, d_{\lambda} \rangle | \leq p \; \mu(\DDD).
    
    This leads to 
    
    
    .. math:: 
    
        \mu_1(p) = \underset{|\Lambda| = p}{\max} \; \underset {\psi}{\max} 
        \sum_{\Lambda} | \langle \psi, d_{\lambda} \rangle |
        \leq \underset{|\Lambda| = p}{\max} \; \underset {\psi}{\max}   \left (p \; \mu(\DDD)\right)
        =  p \; \mu(\DDD).
    



 
Computation of Babel function
----------------------------------------------------

It might seem at first that computation of Babel function is combinatorial and hence prohibitively expensive.
But it is not true.

We will demonstrate this through an example in this section. Our example synthesis matrix will be


.. math:: 

    \DDD  = 
    \begin{bmatrix}
    0.5 & 0 & 0 & 0.6533 & 1 & 0.5 & -0.2706 & 0\\
    0.5 & 1 & 0 & 0.2706 & 0 & -0.5 & 0.6533 & 0\\
    0.5 & 0 & 1 & -0.2706 & 0 & -0.5 & -0.6533 & 0\\
    0.5 & 0 & 0 & -0.6533 & 0 & 0.5 & 0.2706 & 1
    \end{bmatrix}



From the synthesis matrix  :math:`\DDD` we first construct its Gram matrix given by


.. math::
    G = \DDD^H \DDD.


We then take absolute value of each entry in  :math:`G` to construct  :math:`|G|`.

For the running example


.. math:: 

    |G| = 
    \begin{bmatrix}
    1 & 0.5 & 0.5 & 0 & 0.5 & 0 & 0 & 0.5\\
    0.5 & 1 & 0 & 0.2706 & 0 & 0.5 & 0.6533 & 0\\
    0.5 & 0 & 1 & 0.2706 & 0 & 0.5 & 0.6533 & 0\\
    0 & 0.2706 & 0.2706 & 1 & 0.6533 & 0 & 0 & 0.6533\\
    0.5 & 0 & 0 & 0.6533 & 1 & 0.5 & 0.2706 & 0\\
    0 & 0.5 & 0.5 & 0 & 0.5 & 1 & 0 & 0.5\\
    0 & 0.6533 & 0.6533 & 0 & 0.2706 & 0 & 1 & 0.2706\\
    0.5 & 0 & 0 & 0.6533 & 0 & 0.5 & 0.2706 & 1
    \end{bmatrix}


We now sort every row in descending order to obtain a 
new matrix  :math:`G'`.



.. math:: 

    G' = 
    \begin{bmatrix}
    1 & 0.5 & 0.5 & 0.5 & 0.5 & 0 & 0 & 0\\
    1 & 0.6533 & 0.5 & 0.5 & 0.2706 & 0 & 0 & 0\\
    1 & 0.6533 & 0.5 & 0.5 & 0.2706 & 0 & 0 & 0\\
    1 & 0.6533 & 0.6533 & 0.2706 & 0.2706 & 0 & 0 & 0\\
    1 & 0.6533 & 0.5 & 0.5 & 0.2706 & 0 & 0 & 0\\
    1 & 0.5 & 0.5 & 0.5 & 0.5 & 0 & 0 & 0\\
    1 & 0.6533 & 0.6533 & 0.2706 & 0.2706 & 0 & 0 & 0\\
    1 & 0.6533 & 0.5 & 0.5 & 0.2706 & 0 & 0 & 0
    \end{bmatrix}


First entry in each row is now  :math:`1`. This corresponds to  :math:`\langle d_i, d_i \rangle` and it doesn't 
appear in the calculation of  :math:`\mu_1(p)` hence we disregard whole of first column.

Now look at column 2 in  :math:`G'`. In the  :math:`i`-th row it is nothing but 


.. math:: 

    \underset{j \neq i}{\max} | \langle d_i, d_j \rangle |.


Thus, 


.. math:: 

    \mu (\DDD) = \mu_1(1) = \underset{1 \leq j \leq D} {\max} {G'}_{j, 2}

i.e. the coherence is given by the maximum in the 2nd column of  :math:`G'`.

In the running example


.. math:: 

    \mu (\DDD) = \mu_1(1) = 0.6533.


Looking carefully we can note that for  :math:`\psi = d_i` the 
maximum value of sum


.. math:: 

    \sum_{\Lambda} | \langle \psi, d_{\lambda} \rangle |

while  :math:`| \Lambda| = p` is given by 
the sum over elements from 2nd to  :math:`(p+1)`-th columns in  :math:`i`-th row.

Thus 


.. math:: 

    \mu_1 (p) = \underset{1 \leq i \leq D} {\max} \sum_{j = 2}^{p + 1} G'_{i j}.


For the running example the Babel function values are given by


.. math:: 

    \begin{pmatrix}
    0.6533 & 1.3066 & 1.6533 & 2 & 2 & 2 & 2
    \end{pmatrix}.


We see that Babel function stops increasing after  :math:`p=4`. Actually  :math:`\DDD` is
constructed by shuffling the columns of two orthonormal bases. Hence many of
the inner products are 0 in  :math:`G`.

 
Babel function and spark
----------------------------------------------------

We first note that  *Babel function*  tells something about linear independence of columns of  :math:`\DDD`.


.. _lem:ssm:babel_linear_independence_condition:

.. lemma:: 


    
    Let  :math:`\mu_1` be the  *Babel function*  for a dictionary  :math:`\DDD`. If
    
    
    .. math:: 
    
        \mu_1(p) < 1
    
    then all selections of  :math:`p+1` columns from  :math:`\DDD` are linearly independent.




.. proof:: 

    We recall from the proof of  :ref:`this result <lem:ssm:spark_lower_bound_coherence>`
    that if
    
    
    .. math:: 
    
        p + 1 < 1 + \frac{1}{\mu(\DDD)} \implies p < \frac{1}{\mu(\DDD)}
    
    then every set of  :math:`(p+1)` columns from  :math:`\DDD` are linearly independent. 
    
    We also know from  :ref:`this result <lem:ssm:babel_function_upper_bound>` that
    
    
    
    .. math:: 
    
        p \; \mu(\DDD) \geq \mu_1(p) \implies \mu(\DDD) \geq \frac{\mu_1(p)}{p} 
        \implies \frac{1}{\mu(\DDD)} \leq \frac{p} {\mu_1(p)}.
    
    
    Thus if
    
    
    .. math:: 
    
        p < \frac{p} {\mu_1(p)} \implies 1 < \frac{1} {\mu_1(p)} \implies \mu_1(p) < 1
    
    then all selections of  :math:`p+1` columns from  :math:`\DDD` are linearly independent.


This leads us to a lower bound on spark from  *Babel function* .

.. _lem:ssm:dict:spark_lower_bound_babel_func:

.. lemma:: 


    
    A lower bound of spark of a dictionary  :math:`\DDD` is given by
    
    
    .. math::
        \spark(\DDD) \geq \underset{1 \leq p \leq N} {\min}\{p : \mu_1(p-1)\geq 1\}.
    



.. proof:: 

    For all  :math:`j \leq p-2` we are given that  :math:`\mu_1(j) < 1`. Thus all sets of  :math:`p-1` columns from  :math:`\DDD` 
    are linearly independent (using  :ref:`this result <lem:ssm:babel_linear_independence_condition>`).
    
    Finally  :math:`\mu_1(p-1) \geq 1`, hence we cannot say definitively whether a set of  :math:`p` columns
    from  :math:`\DDD` is linearly dependent or not. This establishes the lower bound on spark.


An earlier version of this result also appeared in :cite:`donoho2003optimally` theorem 6.

 
Babel function and singular values
----------------------------------------------------



.. _lem:ssm:subdictionary_singular_value_babel_bounds:

.. theorem:: 


    
    Let  :math:`\DDD` be a dictionary and  :math:`\Lambda` be an index set with  :math:`|\Lambda| = K`. 
    The singular values of  :math:`\DDD_{\Lambda}` are bounded by 
    
    
    .. math::
        1  - \mu_1(K - 1) \leq \sigma^2 \leq 1 + \mu_1 (K - 1).
    



.. proof:: 

    Consider the Gram matrix 
    
    
    .. math:: 
    
        G = \DDD_{\Lambda}^H \DDD_{\Lambda}.
    
    :math:`G` is a  :math:`K\times K` square matrix.
    
    Also let 
    
    
    .. math:: 
    
        \Lambda = \{ \lambda_1, \lambda_2, \dots, \lambda_K\}
    
    so that
    
    
    .. math:: 
    
        \DDD_{\Lambda} = \begin{bmatrix}
        d_{\lambda_1} & d_{\lambda_2} & \dots & d_{\lambda_K}
        \end{bmatrix}.
    
    
    The Gershgorin Disc Theorem states that every
    eigenvalue of  :math:`G` lies in one of the  :math:`K` discs 
    
    
    .. math:: 
    
        \Delta_k  = \left \{
        z : |z -  G_{k k}|\leq \sum_{j \neq k } | G_{j k}| 
        \right \}
    
    Since  :math:`d_i` are unit norm, hence  :math:`G_{k k} = 1`. 
    
    Also we note that
    
    
    .. math:: 
    
        \sum_{j \neq k } | G_{j k}| = \sum_{j \neq k } | \langle d_{\lambda_j},  d_{\lambda_k} \rangle | \leq \mu_1(K-1)
    
    since there are  :math:`K-1` terms in sum and  :math:`\mu_1(K-1)` is an upper bound on all such sums.
    
    Thus if  :math:`z` is an eigen value of  :math:`G` then we have
    
    
    .. math::
        \begin{aligned}
        &| z -1 | \leq \mu_1(K-1) \\
        \implies &- \mu_1(K-1)  \leq z - 1 \leq \mu_1(K-1) \\
        \implies &1 - \mu_1(K-1)  \leq z \leq 1 + \mu_1(K-1). 
        \end{aligned}
    
    This is OK since  :math:`G` is positive semi-definite, thus, the eigen values of  :math:`G` are real.
    
    But the eigen values of  :math:`G` are nothing but the squared singular values of  :math:`\DDD_{\Lambda}`. Thus we get
    
    
    .. math:: 
    
        1 - \mu_1(K-1)  \leq \sigma^2 \leq 1 + \mu_1(K-1).
    




.. _lem:ssm:babel_singular_value_condition:

.. corollary:: 


    
    Let  :math:`\DDD` be a dictionary and  :math:`\Lambda` be an index set with  :math:`|\Lambda| = K`. 
    If   :math:`\mu_1(K-1) < 1` 
    then the squared singular values of  :math:`\DDD_{\Lambda}` exceed  :math:`(1 - \mu_1 (K-1))`. 



.. proof:: 

    From previous theorem we have
    
    
    .. math:: 
    
        1 - \mu_1(K-1)  \leq \sigma^2 \leq 1 + \mu_1(K-1).
    
    Since the singular values are always non-negative, the lower bound is useful only when  :math:`\mu_1(K-1) < 1`. 
    When it holds we have 
    
    
    .. math:: 
    
        \sigma(\DDD_{\Lambda}) \geq \sqrt{1 - \mu_1(K-1)}.
    



.. _res:ssm:babel_uncertainty_principle_K:

.. theorem:: 


    
    Let  :math:`\mu_1(K -1 ) < 1`. If a signal can be written as a linear combination of  :math:`k` atoms, then
    any other exact representation of the signal requires at least  :math:`(K - k + 1)` atoms. 



.. proof:: 

    If  :math:`\mu_1(K -1 ) < 1`, then the singular values of any sub-matrix of  :math:`K` atoms are non-zero. 
    Thus, the minimum number of atoms required to form a linear dependent set is  :math:`K + 1`.
    Let the number of atoms in any other exact representation of the signal be  :math:`l`. Then
    
    
    .. math:: 
    
        k + l \geq K + 1 \implies l \geq K - k + 1.
    


 
Babel function and gram matrix
----------------------------------------------------

Let  :math:`\Lambda` index a subdictionary and let  :math:`G = \DDD_{\Lambda}^H \DDD_{\Lambda}` denote the Gram matrix
of the subdictionary  :math:`\DDD_{\Lambda}`. Assume  :math:`K = | \Lambda |`.


.. _res:ssm:gram_matrix_infty_norm_babel_bound:

.. theorem:: 


    
    
    
    .. math::
        \| G \|_{\infty} =  \| G \|_{1}  \leq 1 + \mu_1(K - 1).
    



.. proof:: 

    Since  :math:`G` is Hermitian, hence the two norms are equal:
    
    
    .. math:: 
    
        \| G \|_{\infty} =  \| G^H \|_{1} = \| G \|_{1}.
    
    Now each row consists of a diagonal entry  :math:`1` and  :math:`K-1` off diagonal entries. The absolute
    sum of all the off-diagonal entries in a row is upper bounded by  :math:`\mu_1(K -1)`. Thus, the absolute
    sum of all the entries in a row is upper bounded by  :math:`1 + \mu_1(K - 1)`. 
    Since  :math:`\| G \|_{\infty}` is nothing but the maximum  :math:`l_1` norm of rows of  :math:`G`, hence
    
    
    .. math:: 
    
        \| G \|_{\infty} \leq 1 +  \mu_1(K - 1).
    





.. _res:ssm:inverse_gram_matrix_infty_norm_babel_bound:

.. theorem:: 


    
    Suppose that  :math:`\mu_1(K - 1) < 1`. Then
    
    
    .. math::
        \| G^{-1} \|_{\infty} = \| G^{-1} \|_{1} \leq \frac{1}{1 - \mu_1(K - 1)}
    



.. proof:: 

    Since  :math:`G` is Hermitian, hence the two operator norms are equal:
    
    
    .. math:: 
    
        \| G^{-1} \|_{\infty} = \| G^{-1} \|_{1}.
    
    As usual we can write  :math:`G` as  :math:`G = I  + A` where  :math:`A` consists of off-diagonal entries in  :math:`A` 
    (recall that since atoms are unit norm, hence diagonal entries in  :math:`G` are 1).
    
    Each row of  :math:`A` lists inner products between a fixed atom and  :math:`K-1` other atoms 
    (leaving the 0 at the diagonal entry). 
    Therefore
    
    
    .. math:: 
    
        \| A \|_{\infty \to \infty} \leq \mu_1(K - 1)
    
    (since  :math:`l_1` norm of any row is upper bounded by the babel number  :math:`\mu_1(K - 1)` ).
    Now  :math:`G^{-1}` can be written as a  Neumann series 
    
    
    .. math:: 
    
        G^{-1} = \sum_{k=0}^{\infty}(-A)^k.
    
    Thus
    
    
    .. math:: 
    
        \| G^{-1} \|_{\infty} = \| \sum_{k=0}^{\infty}(-A)^k \|_{\infty} \leq \sum_{k=0}^{\infty} \| (-A)^k \|_{\infty}
        = \sum_{k=0}^{\infty} \| A \|_{\infty}^k = \frac{1}{1 - \| A \|_{\infty}}.
    
    Finally
    
    
    .. math:: 
    
        \begin{aligned}
        \| A \|_{\infty} \leq \mu_1(K - 1) &\iff 1 - \| A \|_{\infty} \geq 1 - \mu_1(K - 1)\\
        &\iff \frac{1}{1 - \| A \|_{\infty}} \leq \frac{1}{1 - \mu_1(K - 1)}.
        \end{aligned}
    
    Thus
    
    
    .. math:: 
    
        \| G^{-1} \|_{\infty}  \leq \frac{1}{1 - \mu_1(K - 1)}.
    





 
Quasi incoherent dictionaries
----------------------------------------------------


.. _def:ssm:quasi_incoherent_dictionary:

.. definition:: 

     
    .. index:: Quasi-incoherent dictionary
    

    
    When the  *Babel function*  of a dictionary grows slowly, 
    we say that the dictionary is **quasi-incoherent** .


.. _sec:ssm-babel-function-implementation:

Implementing the Babel function
-------------------------------------


We will implement the babel function in Matlab. 
Here is the signature of the function::

    function [ babel ] = babel( Phi )

Let's compute the Gram matrix::

    G = Phi' * Phi;

We now take the absolute values of all entries in 
the gram matrix::

    absG = abs(G);

We sort the rows in ``absG`` in descending order::

    GS = sort(absG, 2,'descend');


We compute the cumulative sums over each row
of ``GS`` leaving out the first column::

    rowSums = cumsum(GS(:, 2:end), 2);

The babel function is now obtained by simply
taking maximum over each column::

    babel = max(rowSums);

This implementation is available in the
``sparse-plex`` library as
``spx.dict.babel``.
