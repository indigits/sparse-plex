Coherence
----------------------------------------------------

Finding out the spark of a dictionary  :math:`\DDD`  is NP-hard since 
it involves considering combinatorially 
large number of selections of columns from  
:math:`\DDD` . 
In this section we consider
the  *coherence*  of a dictionary which is computationally tractable 
and quite useful 
in characterizing the solutions of sparse approximation problems.


.. index:: Coherence of dictionary
.. index:: Mutual coherence
.. _def:ssm:coherence:

.. definition:: 

    The  **coherence**  of a dictionary  :math:`\DDD`  is defined as
    the maximum absolute inner product between two distinct atoms in the dictionary:
    
    .. math::
        \mu = \underset{j \neq k}{\text{max}} | \langle d_{\omega_j}, d_{\omega_k} \rangle |
        = \underset{j \neq k}{\text{max}} | (\DDD^H \DDD)_{jk} |.
    


If the dictionary consists of two orthonormal bases, then coherence is also known as  *mutual coherence* or  *proximity*. Since the atoms within each
orthonormal basis are orthogonal to each other, the coherence is determined
only by the inner products of atoms from one basis with another basis.


We note that  :math:`d_{\omega_i}`  is the  :math:`i` -th column of synthesis matrix  :math:`\DDD` . 
Also  :math:`\DDD^H \DDD`  is the  **Gram matrix**  for  :math:`\DDD`  whose elements are nothing
but the inner-products of columns of  :math:`\DDD` .
 
.. index:: Gram matrix


We note that by definition  :math:`\| d_{\omega} \|_2 = 1`  
hence :math:`\mu \leq 1`  and since absolute values are considered 
hence  :math:`\mu \geq 0` .
Thus,  :math:`0 \leq \mu \leq 1`. 

For an orthonormal basis  :math:`\Psi`  all atoms are orthogonal to each other, hence


.. math:: 

    | \langle \psi_{\omega_j}, \psi_{\omega_k} \rangle |= 0 \text{ whenever } j \neq k.
 
Thus  :math:`\mu = 0` .

In the following, we will use the notation  :math:`|A|`  to denote a matrix consisting
of absolute values of entries in a matrix  :math:`A` . i.e.


.. math:: 

    |  A |_{i j}  = |  A _{i j} |.

The off-diagonal entries of the Gram matrix are captured by the 
matrix  :math:`\DDD^H \DDD - I` . Note that all diagonal entries in  :math:`\DDD^H \DDD - I` 
are zero since atoms of  :math:`\DDD`  are unit norm.
Moreover, each of the entries in  :math:`| \DDD^H \DDD - I |` 
is dominated by  :math:`\mu(\DDD)` .


The inner product between any two atoms  :math:`| \langle d_{\omega_j}, d_{\omega_k} \rangle |` 
is a measure of how much they look alike or how much they are correlated. 
Coherence just picks up the two vectors
which are most alike and returns their correlation.
In a way  :math:`\mu`  is quite a blunt measure of the quality of a dictionary, yet it is quite useful.

If a dictionary is uniform in the sense that there is not much variation in 
:math:`| \langle d_{\omega_j}, d_{\omega_k} \rangle |` , 
then  :math:`\mu`  captures
the behavior of the dictionary quite well.


.. _def:ssm:incoherent_dictionary:

.. definition:: 

     
    .. index:: Incoherent dictionary
    

    
    We say that a dictionary is  **incoherent**  if the coherence of the dictionary is small.

We are looking for dictionaries which are incoherent. In the sequel we will see how
incoherence plays a role in sparse approximation.



.. example:: 

    The coherence of two ortho-bases is bounded by
    
    .. math:: 
    
        \frac{1}{\sqrt{N}} \leq \mu \leq 1.
    
    The coherence of Dirac Fourier basis is  :math:`\frac{1}{\sqrt{N}}` .

.. example:: Coherence: Multi-ONB dictionary

    A dictionary of concatenated orthonormal bases is called a multi-ONB. For some  :math:`N` , it is
    possible to build a multi-ONB which contains  :math:`N`  or even  :math:`N+1`  bases yet retains 
    the minimal coherence  :math:`\mu = \frac{1}{\sqrt{N}}`  possible.

.. theorem:: 

    A lower bound on the coherence of a general dictionary is given by
    
    
    .. math:: 
    
        \mu \geq \sqrt{\frac{D-N}{N(D-1)}}
    


.. _def:ssm:grassmannian_frame:

.. definition::

     
    .. index:: Grassmannian frame
    

    
    If each atomic inner product meets this bound, the dictionary is  called an  **optimal Grassmannian frame** .


The definition of coherence can be extended to arbitrary matrices  :math:`\Phi \in \CC^{N \times D}` .

.. _def:ssm:coherence_matrix:

.. definition:: 

     
    .. index:: Coherence of a matrix
    

    
    The  **coherence**  of a matrix  :math:`\Phi \in \CC^{N \times D}`  is defined as
    the maximum absolute  *normalized*  inner product between two distinct columns in the matrix.
    Let 
    
    
    .. math:: 
    
        \Phi = \begin{bmatrix} \phi_1 & \phi_2 & \dots & \phi_D \end{bmatrix}.
    
    Then coherence of  :math:`\Phi`  is given by
    
    
    .. math::
        :label: eq:ssm:dict:coherence:arbitrary_matrix
    
        \mu(\Phi) = \underset{j \neq k}{\text{max}} \frac{ | \langle \phi_j, \phi_k \rangle |} {\| \phi_j \|_2  \| \phi_k \|_2}
    
    It is assumed that none of the columns in  :math:`\Phi`  is a zero vector. 


 
Lower bounds for spark
""""""""""""""""""""""""""""""""""""""""""""""""""""""

Coherence of a matrix is easy to compute. More interestingly it also provides a lower bound on the
spark of a matrix.

.. _lem:ssm:spark_lower_bound_coherence:

.. theorem:: 

     
    .. index:: Spark lower bound
    

    
    For any matrix  :math:`\Phi \in \CC^{N \times D}`  (with non-zero columns) the following relationship holds
    
    
    .. math::
        \spark(\Phi) \geq 1 + \frac{1}{\mu(\Phi)}.
    




.. proof:: 

    We note that scaling of a column of  :math:`\Phi`  doesn't change either the spark or coherence of  :math:`\Phi` .
    Therefore, we assume that the columns of  :math:`\Phi`  are normalized.
    
    We now construct the Gram matrix of  :math:`\Phi`  given by  :math:`G = \Phi^H \Phi` . 
    We note that
    
    
    .. math:: 
    
        G_{k k} = 1 \quad  \Forall 1 \leq k \leq D
    
    since each column of  :math:`\Phi`  is unit norm.
    
    Also
    
    
    .. math:: 
    
        |G_{k j}| \leq \mu(\Phi) = \mu(\Phi) \quad \Forall 1 \leq k, j \leq D , k \neq j.
    
    Consider any  :math:`p`  columns from  :math:`\Phi`  and construct its Gram matrix. This is nothing but a
    leading minor of size  :math:`p \times p`  from the matrix  :math:`G` .
    
    From the Gershgorin disk theorem, if this minor is diagonally dominant, i.e. if
    
    
    .. math:: 
    
        \sum_{j \neq i} |G_{i j}| < | G_{i i}| \Forall i
    
    then this sub-matrix of  :math:`G`  is positive definite and so corresponding  :math:`p`  columns from  :math:`\Phi`  are
    linearly independent. 
    
    But
    
    
    .. math:: 
    
        |G_{i i}| = 1
    
    and
    
    
    .. math:: 
    
        \sum_{j \neq i} |G_{i j}| \leq (p-1) \mu(\Phi) 
    
    for the minor under consideration.
    Hence for  :math:`p`  columns to be linearly independent the following condition is sufficient
    
    
    .. math:: 
    
        (p-1) \mu (\Phi) < 1.
    
    Thus if
    
    
    .. math:: 
    
        p < 1 + \frac{1}{\mu(\Phi)},
    
    then every set of  :math:`p`  columns from  :math:`\Phi`  is linearly independent. 
    
    Hence, the smallest possible set of linearly dependent columns must satisfy
    
    
    .. math:: 
    
        p \geq 1 + \frac{1}{\mu(\Phi)}.
    
    This establishes the lower bound that
    
    
    .. math:: 
    
        \spark(\Phi) \geq 1 + \frac{1}{\mu(\Phi)}.
    

This bound on spark doesn't make any assumptions on the structure of the dictionary.
In fact, imposing additional structure on the dictionary can give better bounds.
Let us look at an example for a two ortho-basis  :cite:`donoho2003optimally`.


.. _res:ssm:spark_lower_bound_two_ortho_basis:

.. theorem:: 


    
    Let  :math:`\DDD`  be a two ortho-basis. Then
    
    
    .. math::
        \spark (\DDD) \geq \frac{2}{\mu(\DDD)}.
    



.. proof:: 

    It can be shown that for any
    vector  :math:`v \in \NullSpace(\DDD)` 
        
    .. math:: 
    
        \| v \|_0 \geq \frac{2}{\mu(\DDD)}.
    
    But
    
    
    .. math:: 
    
        \spark(\DDD) = \underset{v \in \NullSpace(\DDD)} {\min}( \| v \|_0).
    
    Thus
    
    
    .. math:: 
    
        \spark(\DDD) \geq \frac{2}{\mu(\DDD)}.
    

For maximally incoherent two orthonormal bases, we know that  :math:`\mu = \frac{1}{\sqrt{N}}` .
A perfect example is the pair of Dirac and Fourier bases. In this case
:math:`\spark(\DDD) \geq 2 \sqrt{N}` .


 
Uniqueness-Coherence
""""""""""""""""""""""""""""""""""""""""""""""""""""""


We can now establish a uniqueness condition for sparse solution of  :math:`x = \Phi \alpha` . 


.. _thm:ssm:uniqueness_coherence:

.. theorem:: 

     
    .. index:: Uniqueness-Coherence
    

    
    Consider a solution  :math:`x^*`  to the under-determined system  :math:`y = \Phi x` . If  :math:`x^*`  obeys
    
    
    .. math::
        \| x^* \|_0 < \frac{1}{2} \left (1 + \frac{1}{\mu(\Phi)} \right )
    
    then it is necessarily the sparsest solution.




.. proof:: 

    This is a straightforward application of  
    :ref:`spark uniqueness theorem <thm:ssm:uniqueness_spark>` 
    and  :ref:`spark lower bound <lem:ssm:spark_lower_bound_coherence>`
    on coherence.


It is interesting to compare the two uniqueness theorems:  
:ref:`spark uniqueness theorem <thm:ssm:uniqueness_spark>` 
and  :ref:`coherence uniqueness theorem <thm:ssm:uniqueness_coherence>`.

First one is sharp and is far more powerful
than the second one based on coherence.

Coherence can never be smaller than  :math:`\frac{1}{\sqrt{N}}` , 
therefore the bound on :math:`\| x^* \|_0`  in   
:ref:`above <thm:ssm:uniqueness_coherence>` 
can never be larger than :math:`\frac{\sqrt{N} + 1}{2}` .

However, spark can be easily as large as  :math:`N`  and then bound on  :math:`\| x^* \|_0`  can
be as large as  :math:`\frac{N}{2}` .


Thus, we note that coherence gives a weaker bound than spark for supportable sparsity levels
of unique solutions. The advantage that coherence has is that it is easily computable and
doesn't require any special structure on the dictionary (two ortho basis has a special structure).

 
Singular values of sub-dictionaries
""""""""""""""""""""""""""""""""""""""""""""""""""""""



.. _res:ssm:subdictionary_eigenvalue_coherence:

.. theorem:: 


    
    Let  :math:`\DDD`  be a dictionary and  :math:`\DDD_{\Lambda}`  be a sub-dictionary. 
    Let  :math:`\mu`  be the coherence of  :math:`\DDD` . Let  :math:`K = | \Lambda |` .
    Then
    the eigen values of  :math:`G = \DDD_{\Lambda}^H \DDD_{\Lambda}`  satisfy:
    
    
    .. math::
        1 - (K - 1)   \mu  \leq \lambda \leq 1 + (K - 1)   \mu.
    
    Moreover, the singular values of the sub-dictionary  :math:`\DDD_{\Lambda}`  satisfy
    
    
    .. math::
        \sqrt{1 - (K - 1)   \mu}  \leq \sigma (\DDD_{\Lambda}) \leq \sqrt{1 + (K - 1)   \mu}.
    



.. proof:: 

    We recall from Gershgorin's theorem that for any square matrix  :math:`A \in \CC^{K \times K}` , 
    every eigen value  :math:`\lambda`  of  :math:`A`  satisfies 
    
    
    .. math:: 
    
        | \lambda  - a_{ii} | \leq \sum_{j \neq i} |a_{ij}| \text{ for some } i \in \{ 1, \dots, K\}.
    
    Now consider the matrix  :math:`G =  \DDD_{\Lambda}^H \DDD_{\Lambda}`  
    with diagonal elements equal to 1 and off diagonal elements bounded by a value  :math:`\mu` .
    Then
    
    
    .. math:: 
    
        | \lambda  - 1 | \leq \sum_{j \neq i} |a_{ij}|  \leq \sum_{j \neq i} \mu = (K - 1) \mu.
    
    Thus,
    
    
    .. math:: 
    
        - (K - 1) \mu  \leq \lambda  - 1 \leq (K - 1) \mu \iff  1 - (K - 1)   \mu  \leq \lambda \leq 1 + (K - 1)   \mu
    
    This gives us a lower bound on the smallest eigen value.
    
    
    .. math:: 
    
        \lambda_{\min} (G) \geq 1 - (K - 1) \mu.
    
    Since  :math:`G`  is positive definite ( :math:`\DDD_{\Lambda}`  is full-rank), hence its eigen values
    are positive. Thus, the above lower bound is useful only if
    
    
    .. math:: 
    
        1 - (K - 1) \mu > 0 \iff 1 >  (K - 1) \mu \iff \mu < \frac{1}{K - 1}.
    
    We also get an upper bound on the eigen values of  :math:`G`  given by
    
    
    .. math:: 
    
        \lambda_{\max} (G) \leq 1 + (K - 1) \mu.
    
    The bounds on singular values of  :math:`\DDD_{\Lambda}`  are obtained as a straight-forward
    extension by taking square roots on the expressions.


 
Embeddings using sub-dictionaries
""""""""""""""""""""""""""""""""""""""""""""""""""""""


.. _res:ssm:real_dict_norm_bound_coherence:

.. theorem:: 


    
    Let  :math:`\DDD`  be a real dictionary and  :math:`\DDD_{\Lambda}`  be a sub-dictionary
    with  :math:`K = |\Lambda|` .
    Let  :math:`\mu`  be the coherence of  :math:`\DDD` .  Let  :math:`v \in \RR^K`  be an
    arbitrary vector. Then
    
    
    .. math::
        | v |^T [I - \mu (\OneMat - I)] | v | \leq \| \DDD_{\Lambda} v \|_2^2 \leq | v |^T [I + \mu (\OneMat - I)] | v |
    
    where  :math:`\OneMat`  is a  :math:`K\times K`  matrix of all ones.
    Moreover
    
    
    .. math::
        (1 - (K - 1)   \mu) \| v \|_2^2 \leq \| \DDD_{\Lambda} v \|_2^2 \leq (1 + (K - 1)   \mu)\| v \|_2^2. 
    
    



.. proof:: 

    We can easily write
    
    
    .. math:: 
    
        \| \DDD_{\Lambda} v \|_2^2 =  v^T \DDD_{\Lambda}^T \DDD_{\Lambda} v
    
    
    
    .. math::
        \begin{aligned}
        v^T \DDD_{\Lambda}^T \DDD_{\Lambda} v &= \sum_{i=1}^K \sum_{j=1}^K v_i  d_{\lambda_i}^T d_{\lambda_j} v_j.
        \end{aligned}
    
    The terms in the R.H.S. for  :math:`i = j`  are given by
    
    
    .. math:: 
    
        v_i  d_{\lambda_i}^T d_{\lambda_i} v_i  = | v_i |^2. 
    
    Summing over  :math:`i = 1, \cdots, K` , we get 
    
    
    .. math:: 
    
        \sum_{i=1}^K | v_i |^2 = \| v \|_2^2 = v^T v = | v |^T | v | = | v |^T I | v |.
    
    We are now left with  :math:`K^2 - K`  off diagonal terms. Each of these terms is bounded by
    
    
    .. math:: 
    
        - \mu |v_i| |v_j | \leq v_i d_{\lambda_i}^T d_{\lambda_j} v_j \leq \mu |v_i| |v_j |.
    
    Summing over the  :math:`K^2 - K`  off-diagonal terms we get:
    
    
    .. math:: 
    
        \sum_{i \neq j}  |v_i| |v_j | = \sum_{i, j}  |v_i| |v_j | - \sum_{i = j}  |v_i| |v_j | =  | v |^T(\OneMat - I ) | v |. 
    
    Thus,
    
    
    .. math:: 
    
         - \mu | v |^T (\OneMat - I ) | v | \leq 
         \sum_{i \neq j} v_i  d_{\lambda_i}^T d_{\lambda_j} v_j 
         \leq  \mu | v |^T (\OneMat - I ) | v |
    
    Thus,
    
    
    .. math:: 
    
        | v |^T I | v |- \mu | v |^T (\OneMat - I ) | v | \leq v^T \DDD_{\Lambda}^T \DDD_{\Lambda} v
        \leq | v |^T I | v |+ \mu | v |^T (\OneMat - I )| v |.
    
    We get the result by slight reordering of terms:
    
    
    .. math:: 
    
        | v |^T [I - \mu (\OneMat - I)] | v | \leq \| \DDD_{\Lambda} v \|_2^2 \leq | v |^T [I + \mu (\OneMat - I)] | v |
    
    We recall that
    
    
    .. math:: 
    
        | v |^T \OneMat | v | =  \| v \|_1^2.
    
    Thus, the inequalities can be written as
    
    
    .. math:: 
    
        (1 + \mu) \| v \|_2^2 - \mu \| v \|_1^2 \leq \| \DDD_{\Lambda} v \|_2^2 \leq (1 - \mu) \| v \|_2^2 + \mu \| v \|_1^2.
    
    Alternatively,
    
    
    .. math:: 
    
        \| v \|_2^2  - \mu \left (\| v \|_1^2 - \| v \|_2^2 \right ) 
        \leq \| \DDD_{\Lambda} v \|_2^2 \leq 
        \| v \|_2^2  + \mu \left (\| v \|_1^2 - \| v \|_2^2\right ) .
    
    
    Finally
    
    
    .. math:: 
    
        \| v \|_1^2 \leq K \| v \|_2^2 \implies \| v \|_1^2 - \| v \|_2^2 \leq (K - 1) \| v \|_2^2.
    
    This gives  us
    
    
    .. math:: 
    
        ( 1- (K - 1) \mu ) \| v \|_2^2 \leq \| \DDD_{\Lambda} v \|_2^2 \leq ( 1 + (K - 1) \mu ) \| v \|_2^2 .
    


We now present the above theorem for the complex case. The proof is
based on singular values. This proof is simpler and more general 
than the one presented above. 

.. _res:ssm:subdict_norm_bound_coherence:

.. theorem:: 


    
    Let  :math:`\DDD`  be a dictionary and  :math:`\DDD_{\Lambda}`  be a sub-dictionary
    with  :math:`K = |\Lambda|` .
    Let  :math:`\mu`  be the coherence of  :math:`\DDD` .  Let  :math:`v \in \CC^K`  be an
    arbitrary vector. Then
    
    
    .. math::
        (1 - (K - 1)   \mu) \| v \|_2^2 \leq \| \DDD_{\Lambda} v \|_2^2 \leq (1 + (K - 1)   \mu)\| v \|_2^2. 
    



.. proof:: 

    Recall that 
    
    
    .. math:: 
    
        \sigma_{\min}^2(\DDD_{\Lambda}) \| v \|_2^2  \leq \| \DDD_{\Lambda} v \|_2^2 \leq 
        \sigma_{\max}^2(\DDD_{\Lambda}) \| v \|_2^2.
    
    
    :ref:`A previous result <res:ssm:subdictionary_eigenvalue_coherence>` tells us:
        
    .. math:: 
    
        1 - (K - 1)   \mu  \leq \sigma^2 (\DDD_{\Lambda}) \leq 1 + (K - 1)   \mu.
    
    Thus,    
    
    .. math:: 
    
        \sigma_{\min}^2(\DDD_{\Lambda}) \| v \|_2^2  \geq (1 - (K - 1)   \mu) \| v \|_2^2
    
    and
    
    
    .. math:: 
    
        \sigma_{\max}^2(\DDD_{\Lambda}) \| v \|_2^2 \leq (1 + (K - 1)   \mu)\| v \|_2^2.
    
    This gives us the result
    
    
    .. math:: 
    
         (1 - (K - 1)   \mu) \| v \|_2^2 \leq \| \DDD_{\Lambda} v \|_2^2 \leq (1 + (K - 1)   \mu)\| v \|_2^2. 
    

