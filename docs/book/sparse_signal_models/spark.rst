
 
Spark
----------------------------------------------------



.. _def:spark:

.. definition:: 


    
    The  **spark**  of a given matrix  :math:`\Phi` 
    is the smallest number of columns of  :math:`\Phi` that
    are linearly dependent. If all columns are linearly independent, then
    the spark is defined to be number of columns plus one.
     
    .. index:: Spark
    


Note that the definition of spark applies to all matrices (wide, tall or square). It is not
restricted to the synthesis matrices for a dictionary.

Correspondingly, the spark of a dictionary is defined as the minimum number of atoms
which are linearly dependent.

We recall that  *rank*  of a matrix is defined as the maximum number of columns which
are linearly independent. Definition of spark bears remarkable resemblance yet its very hard 
to obtain as it requires a combinatorial search over all possible subsets of columns of  :math:`\Phi`.



.. example:: Spark

    \begin{itemize}
        \item  Spark of the  :math:`3 \times 3` identity matrix    
            
    
    .. math:: 
    
                \begin{pmatrix}
                    1 & 0 & 0\\
                    0 & 1 & 0 \\
                    0 & 0 & 1
                \end{pmatrix}
     is 4 since all columns are linearly independent.
        
    
    \item Spark of the  :math:`2 \times 4` matrix 
    
    
    .. math:: 
    
        \begin{pmatrix}
            1 & 0 & -1 & 0\\
            0 & 1 & 0 & -1
        \end{pmatrix}
     is 2 since column 1 and 3 are linearly dependent.
    
    \item If a matrix has a column with all zero entries, then the spark of such a matrix is 1.  This is a trivial case
    and we will not consider such matrices in the sequel.
    
    \item In general for an  :math:`N \times D` synthesis matrix,  :math:`\spark(\DD) \in [2, N+1]`.
    
    \end{itemize}
    


A naive combinatorial algorithm to calculate the spark of a matrix is given in
 :ref:`alg:ssm:spark_combinatorial_search <alg:ssm:spark_combinatorial_search>`.

.. _alg:ssm:spark_combinatorial_search:

.. code:: 

    \small
    \SetAlgoLined
    \KwIn{ :math:`\Phi` }
    \KwOut{ :math:`s =` Spark of  :math:`\Phi` }
     :math:`R \leftarrow \text{rank} (\Phi)` \;
    \ForEach { :math:`j  \leftarrow 1,\dots, R` }{
    Identify  :math:`\binom{D}{j}` ways of choosing  :math:`j` columns from  :math:`D` columns of  :math:`\Phi` \;
    \ForEach {choice of  :math:`j` columns}{
        \If {columns are dependent}{
             :math:`s \leftarrow j` \;
            \Return \;
        }
    }
    }
    \tcp{All columns are linearly independent}
     :math:`s \leftarrow R  + 1` \;
    \caption{A naive algorithm for computing the spark of a matrix}

    


Spark is useful in characterizing the uniqueness of the solution
of a  :math:`(\DD, K)`- :textsc:`exact-sparse`  problem (see  :ref:`def:ssm:d_k_exact_sparse_problem <def:ssm:d_k_exact_sparse_problem>`).



.. remark:: 

    The  :math:`l_0`-``norm'' of vectors belonging to null space of a matrix  :math:`\Phi` is greater than or equal to  :math:`\spark(\Phi)` :
    
    
    .. math::
        \| x \|_0 \geq \spark(\Phi) \Forall x\in \NullSpace(\Phi).
    




.. proof:: 

    If  :math:`x \in \NullSpace(\Phi)` then  :math:`\Phi x = 0`. Thus non-zero entries in  :math:`x` pick a set of columns in  :math:`\Phi` 
    which are linearly dependent. Clearly  :math:`\| x \|_0` indicates the number of columns in the set which are
    linearly dependent. By definition spark of  :math:`\Phi` indicates the minimum number of columns which are linearly
    dependent hence the result.
    
    
    .. math:: 
    
        \| x \|_0 \geq \spark(\Phi) \Forall x\in \NullSpace(\Phi).
    


We now present a criteria based on spark which characterizes the uniqueness of a sparse solution 
to the problem  :math:`y = \Phi x`.


.. _thm:ssm:uniqueness_spark:

.. theorem:: 

     
    .. index:: Uniqueness Spark
    

    
    Consider a solution  :math:`x^*` to the under-determined system  :math:`y = \Phi x`. If  :math:`x^*` obeys
    
    
    .. math::
        \| x^* \|_0 < \frac{\spark(\Phi)}{2}
    
    then it is necessarily the sparsest solution.




.. proof:: 

    Let  :math:`x'` be some other solution to the problem. Then 
    
    
    .. math:: 
    
        \Phi x' = \Phi x^* \implies \Phi (x' - x^*)  = 0 \implies (x' - x^*) \in \NullSpace(\Phi).
    
    Now based on previous remark we have
    
    
    .. math:: 
    
        \| x' - x^* \|_0 \geq \spark(\Phi).
    
    Now 
    
    
    .. math:: 
    
        \| x' \|_0 + \| x^* \|_0 \geq \| x' - x^* \|_0 \geq \spark(\Phi).
    
    Hence, if  :math:`\| x^* \|_0 < \frac{\spark(\Phi)}{2}`, then we have
    
    
    .. math:: 
    
        \| x' \|_0  > \frac{\spark(\Phi)}{2}
    
    for all other solutions  :math:`x'` to the equation  :math:`y = \Phi x`. 
    
    Thus  :math:`x^*` is necessarily the sparsest possible solution.


This result is quite useful as it establishes a global optimality criterion for the
  :math:`(\DD, K)`- :textsc:`exact-sparse`  problem in
 :ref:`def:ssm:d_k_exact_sparse_problem <def:ssm:d_k_exact_sparse_problem>`.

As long as  :math:`K < \frac{1}{2}\spark(\Phi)` this theorem guarantees that
the solution to   :math:`(\DD, K)`- :textsc:`exact-sparse`  problem
is unique. This is quite surprising result for a non-convex combinatorial optimization
problem. We are able to guarantee a global uniqueness for the solution based
on a simple check on the sparsity of the solution.

Note that we are only saying that if a sufficiently sparse solution is found
then it is unique. We are not claiming that it is possible to find such a solution.

Obviously, the larger the spark, we can guarantee uniqueness for signals
with higher sparsity levels. So a natural question is: \emph{How large can
spark of a dictionary be}? We consider few examples.



.. example:: Spark of Gaussian dictionaries

    Consider a dictionary  :math:`\DD` whose atoms  :math:`d_{i}` are random vectors 
    independently drawn from normal distribution.
    Since a dictionary requires all its atoms to be unit-norms, hence we divide the each of 
    the random vectors with their norms.
    
    We know that with probability  :math:`1` any set of  :math:`N` independent Gaussian random vectors is linearly independent. 
    Also since  :math:`d_i \in \CC^N` hence a set of  :math:`N+1` atoms is always linearly dependent. 
    
    Thus  :math:`\spark(\DD) = N +1`.
    
    Thus, if a solution to  :textsc:`exact-sparse`  problem contains  :math:`\frac{N}{2}` or fewer non-zero
    entries then it is necessarily unique with probability 1. 




.. example:: Spark of Dirac Fourier basis

    For 
    
    
    .. math:: 
    
        \DD = \begin{bmatrix} I  & F \end{bmatrix} \in \CC^{N \times 2N} 
     
    it can be shown that
    
    
    .. math:: 
    
        \spark(\DD) = 2 \sqrt{N}.
    
    In this case, the sparsity level of a unique solution must be less than  :math:`\sqrt{N}`.
    \todo{Find how to compute spark of DF basis}

