
 
Recovery of exactly sparse signals
===================================================


The null space of a matrix  :math:`\Phi`  is denoted as 




.. math::
    	\NullSpace(\Phi) = \{ v \in \RR^N :\Phi v = 0\}.


The set of  :math:`K` -sparse signals is defined as 




.. math::
    	\Sigma_K = \{ x \in \RR^N :  \|x\|_0 \leq K\}.




.. _ex:ksparsesignals:

.. example:: K sparse signals


    
    Let  :math:`N=10` . 
    
    
    
    *    :math:`x=(1,2, 1, -1, 2 , -3, 4, -2, 2, -2) \in \RR^{10}`  is not a sparse signal.
    *   :math:`x=(0,0,0,0,1,0,0,-1,0,0)\in \RR^{10}`  is a 2-sparse signal. Its also a 4 sparse signal.
    
.. _lem:difference_k_sparse_signals:

.. lemma:: 

    If :math:`a` and :math:`b` are two $K$ sparse signals then 
    :math:`a - b` is a :math:`2K` sparse signal.

.. proof:: 

    :math:`(a - b)_i` is non zero only if at least one of 
    :math:`a_i` and :math:`b_i` is non-zero.
    Hence number of non-zero components of  
    :math:`a - b`  cannot exceed  
    :math:`2K` . Hence  :math:`a - b`  is a 
    :math:`2K` -sparse signal.




.. example:: Difference of K sparse signals

    Let N = 5. 
    
    
    *  Let  :math:`a = (0,1,-1,0, 0)`  and  :math:`b = (0,2,0,-1, 0)`. 
       Then  :math:`a - b = (0,-1,-1,1, 0)`  is a 3 sparse 
       hence 4 sparse signal.
    *  Let  :math:`a = (0,1,-1,0, 0)`  and  :math:`b = (0,2,-1,0, 0)`. 
       Then  :math:`a - b = (0,-1,-2,0, 0)`  is a 2 sparse
       hence 4 sparse signal.
    *  Let  :math:`a = (0,1,-1,0, 0)`  and  :math:`b = (0,0,0,1, -1)`. 
       Then  :math:`a - b = (0,1,-1,-1, 1)`  is a 4 sparse signal.
    

.. _lem:k_sparse_unique_representation_requirement:

.. lemma:: 

    A sensing matrix  :math:`\Phi`  uniquely represents all  :math:`x \in \Sigma_K`  if and only if  :math:`\NullSpace(\Phi) \cap \Sigma_{2K} = \phi` . i.e.
    :math:`\NullSpace(\Phi)`  contains no vectors in  
    :math:`\Sigma_{2K}` .

.. proof:: 

    Let  :math:`a`  and  :math:`b`  be two  :math:`K`  sparse signals. Then  :math:`\Phi a`  and  :math:`\Phi b`  are corresponding measurements.
    Now if  :math:`\Phi`  allows recovery of all  :math:`K`  sparse signals, then  :math:`\Phi a \neq \Phi b` . Thus 
    :math:`\Phi (a - b) \neq 0` . Thus  :math:`a - b \notin \NullSpace(\Phi)` . 
    
    Let  :math:`x \in \NullSpace(\Phi) \cap \Sigma_{2K}` . Thus  :math:`\Phi x = 0`  and  :math:`\#x \leq 2K` . Then we can find  :math:`y, z \in \Sigma_K` 
    such that  :math:`x = z - y` . Thus  :math:`m = \Phi z = \Phi y` . But then,  :math:`\Phi`  doesn't uniquely represent  :math:`y, z \in \Sigma_K` . 


There are many equivalent ways of characterizing above condition.

 
The spark
----------------------------------------------------


We recall from  :ref:`definition of spark <def:spark>`, 
that spark of a matrix  :math:`\Phi`  is defined as the
minimum number of columns which are linearly dependent.


.. _def:explanation_signal:

.. definition:: 

    A signal :math:`x \in \RR^N` is called an 
    **explanation** of a measurement 
    :math:`y \in \RR^M` w.r.t.
    sensing matrix  :math:`\Phi`  if
    :math:`y = \Phi x` . 
     
    .. index:: Explanation signal
    
.. _thm:k_sparse_explanation_spark_requirement:

.. theorem:: 

    For any measurement :math:`y \in \RR^M`, 
    there exists at most one signal :math:`x  \in \Sigma_K`
    such that :math:`y = \Phi x`  if and only if  
    :math:`\spark(\Phi) > 2K` .

.. proof:: 

    We need to show
        
    *  If for every measurement, there is only one  :math:`K` -sparse 
       explanation, then  :math:`\spark(\Phi) > 2K` .
    *  If  :math:`\spark(\Phi) > 2K`  then for every measurement, there 
       is only one  :math:`K` -sparse explanation.
    
    
    
    Assume that for every  :math:`y \in \RR^M`  there exists at most one :math:`K` sparse signal  :math:`x \in \RR^N`  
    such that  :math:`y = \Phi x` .
    
    Now assume that  :math:`\spark(\Phi) \leq 2K` . Thus there exists a set of at most  :math:`2K`  columns which are linearly
    dependent. 
    
    Thus there exists  :math:`v \in \Sigma_{2K}`  such that  :math:`\Phi v = 0` . Thus  :math:`v \in \NullSpace (\Phi)` .  
    
    Thus  :math:`\Sigma_{2K} \cap \NullSpace (\Phi) \neq \phi` . 
    
    Hence  :math:`\Phi`  doesn't uniquely represent each signal  :math:`x \in \Sigma_K` .
    A contradiction. 
    
    Hence  :math:`\spark(\Phi) > 2K` .
    
    Now suppose that  :math:`\spark(\Phi) > 2K` . 
    
    Assume that for some  :math:`y`  there exist two different K-sparse explanations  :math:`x, x'`  such that
    :math:`y = \Phi x =\Phi x'` .  
    
    Thus  :math:`\Phi (x  - x') = 0` . Thus  :math:`x - x ' \in \NullSpace (\Phi)`  and  :math:`x - x' \in  \Sigma_{2K}` . 
    
    Thus  :math:`\spark(\Phi) \leq 2K` . A contradiction. 
    


Since  :math:`\spark(\Phi) \in [2, M+1]`  and we require that  :math:`\spark(\Phi) > 2K`  hence we require that  :math:`M \geq 2K` .


 
Recovery of approximately sparse signals
----------------------------------------------------





Spark is a useful criteria for characterization of sensing matrices for truly sparse signals. But this
doesn't work well for  *approximately*  sparse signals. We need to have more restrictive criteria on  :math:`\Phi` 
for ensuring  recovery of approximately sparse signals from compressed measurements.

In this context we will deal with two types of errors: 

* [Approximation error] Let us approximate a signal  
  :math:`x`  using only  :math:`K`  coefficients. 
  Let us call the approximation as  
  :math:`\widehat{x}` . 
  Thus  :math:`e_a = (x - \widehat{x})`  is approximation error.
* [Recovery error] Let  :math:`\Phi`  be a sensing matrix. 
  Let  :math:`\Delta`  be a recovery algorithm.  
  Then  :math:`x'= \Delta(\Phi x)`  is the recovered signal vector. 
  The error  :math:`e_r = (x - x')`  is recovery error.


In this section we will

* Formalize the notion of null space property (NSP) 
  of a matrix  :math:`\Phi` .
* Describe a measure for performance of an 
  arbitrary recovery algorithm  :math:`\Delta` .
* Establish the connection between NSP and 
  performance guarantee for recovery algorithms.


Suppose we approximate  :math:`x`  by a  :math:`K` -sparse signal  
:math:`\widehat{x} \in \Sigma_K`, 
then the minimum error for  :math:`l_p`  norm is given by

.. math::
    	\sigma_K(x)_p = \min_{\widehat{x} \in \Sigma_K} \| x - \widehat{x}\|_p. 


Specific  :math:`\widehat{x} \in \Sigma_K`  for which this minimum is achieved is the best  :math:`K` -term approximation.


In the following, we will need some new notation.

Let  :math:`I = \{1,2,\dots, N\}`  be the set of indices for signal  :math:`x \in \RR^N` .

Let  :math:`\Lambda \subset I`   be a subset of indices.

Let  :math:`\Lambda^c = I \setminus \Lambda` .

:math:`x_{\Lambda}`  will denote a signal vector obtained by 
setting the entries of  :math:`x`  indexed by  
:math:`\Lambda^c`  to zero.


.. example:: 

    
    Let N = 4. Then  :math:`I = \{1,2,3,4\}` .  Let  :math:`\Lambda = \{1,3\}` . 
    Then  :math:`\Lambda^c = \{2, 4\}` . 
    
    Now let  :math:`x = (-1,1,2,-4)` .  Then  :math:`x_{\Lambda} = (-1, 0, 2, 0)` .
    



:math:`\Phi_{\Lambda}`  will denote a  :math:`M\times N`  
matrix obtained by setting the columns of  
:math:`\Phi`  indexed by  :math:`\Lambda^c` to zero.



.. example:: 

    
    Let N = 4. Then  :math:`I = \{1,2,3,4\}` .  Let  :math:`\Lambda = \{1,3\}` . 
    Then  :math:`\Lambda^c = \{2, 4\}` . 
    
    Now let  :math:`x = (-1,1,2,-4)` .  Then  :math:`x_{\Lambda} = (-1, 0, 2, -4)` .
    
    Now let 
    	
    
    .. math:: 

            \Phi = \begin{pmatrix}
        		1 & 0 & -1 & 1\\
        		-1 & -2 & 2 & 3
        	\end{pmatrix}
    
    
    Then 
    	
    
    .. math:: 
            
            \Phi_{\Lambda} = \begin{pmatrix}
        		1 & 0 & -1 & 0\\
        		-1 & 0 & 2 & 0
        	\end{pmatrix}


.. _def:null_space_property:

.. definition:: 

    .. index:: Null space property
    
    A matrix :math:`\Phi` satisfies the 
    **null space property (NSP)** of order :math:`K` 
    if there exists a constant  :math:`C > 0`  such that,
    
    .. math::
        \| h_{\Lambda}\|_2 \leq C \frac{\| h_{{\Lambda}^c}\|_1 }{\sqrt{K}}
        
    holds  :math:`\forall h \in \NullSpace (\Phi)`  and  :math:`\forall \Lambda`  such that  :math:`|\Lambda| \leq K` .
     


*  Let  :math:`h`  be  :math:`K`  sparse. Thus choosing the 
   indices on which  :math:`h`  is non-zero, I can 
   construct a  :math:`\Lambda`  such that  :math:`|\Lambda| \leq K` 
   and  :math:`h_{{\Lambda}^c} = 0` . 
   Thus  :math:`\| h_{{\Lambda}^c}\|_1`  = 0. 
   Hence above condition is not satisfied. Thus
   such a vector  :math:`h`  should not belong to  
   :math:`\NullSpace(\Phi)`
   if  :math:`\Phi`  satisfies NSP.
*  Essentially vectors in  :math:`\NullSpace (\Phi)`  
   shouldn't be concentrated in a small subset of indices.
*  If  :math:`\Phi`  satisfies NSP then the only  
   :math:`K` -sparse vector in  :math:`\NullSpace(\Phi)`
   is  :math:`h = 0` .



 
Measuring the performance of a recovery algorithm
----------------------------------------------------


Let  :math:`\Delta : \RR^M \rightarrow \RR^N`  represent a recovery method to recover approximately sparse  :math:`x`  from  :math:`y` .

:math:`l_2`  recovery error is given by 

.. math:: 

    	\| \Delta (\Phi x) - x \|_2.


The  :math:`l_1`  error for  :math:`K` -term approximation is 
given by  :math:`\sigma_K(x)_1` .

We will be interested in guarantees of the form

.. math::
    :label: eq:nspguarantee

    	\| \Delta (\Phi x) - x \|_2 \leq C \frac{\sigma_K (x)_1}{\sqrt{K}}

Why, this recovery guarantee formulation?

*  Exact recovery of K-sparse signals.  :math:`\sigma_K (x)_1 = 0`  
   if  :math:`x \in \Sigma_K` .
*  Robust recovery of non-sparse signals
*  Recovery dependent on how well the signals are 
   approximated by  :math:`K` -sparse vectors.
*  Such guarantees are known as  **instance optimal**  guarantees.
*  Also known as  **uniform**  guarantees.


Why the specific choice of norms? 

*  Different choices of  :math:`l_p`  norms lead to 
   different guarantees.
*  :math:`l_2`  norm on the LHS is a typical least squares error.
*  :math:`l_2`  norm on the RHS will require prohibitively large number\todo{Why? Prove it.} of measurements.
*  :math:`l_1`  norm on the RHS helps us keep the number of measurements less.


If an algorithm  :math:`\Delta`  provides instance optimal guarantees as defined above, 
what kind of requirements does it place on 
the sensing matrix  :math:`\Phi` ?

We show that NSP of order  :math:`2K`  is a necessary condition 
for providing uniform guarantees.

.. _thm:nsp_guarantee_requirement:

.. theorem:: 

    Let  :math:`\Phi : \RR^N \rightarrow \RR^M`  denote a sensing matrix 
    and  :math:`\Delta : \RR^M \rightarrow \RR^N`  denote an arbitrary recovery algorithm. If
    the pair  :math:`(\Phi, \Delta)`  satisfies instance optimal guarantee :eq:`eq:nspguarantee`, then 
    :math:`\Phi`  satisfies NSP of the order  :math:`2K` .

    




.. proof:: 

    We are given that

    *   :math:`(\Phi, \Delta)`  form an encoder-decoder pair.
    *  Together, they satisfy instance optimal guarantee 
       :eq`eq:nspguarantee`.
    *  Thus they are able to recover all sparse signals exactly.
    *  For non-sparse signals, they are able to recover 
       their  :math:`K` -sparse approximation with 
       bounded recovery error.
    
    
    We need to show that if  :math:`h \in \NullSpace(\Phi)`, 
    then  :math:`h`  satisfies 
    
    .. math::

        \| h_{\Lambda}\|_2 \leq C \frac{\| h_{{\Lambda}^c}\|_1 }{\sqrt{2K}}

    where  :math:`\Lambda`  corresponds to  :math:`2K`  largest magnitude entries in  :math:`h` . 
    
    Note that we have used  :math:`2K`  in this expression, since we need to show that  :math:`\Phi`  satisfies
    NSP of order  :math:`2K` .
    
    Let  :math:`h \in \NullSpace(\Phi)` .
    
    Let  :math:`\Lambda`  be the indices corresponding to the  
    :math:`2K`  largest entries of h.
    Thus 
    
    .. math:: 
    
        h = h_{\Lambda}  + h_{\Lambda^c}.
    
    Split  :math:`\Lambda`  into  :math:`\Lambda_0`  and  :math:`\Lambda_1`  such that  :math:`|\Lambda_0| = |\Lambda_1| = K` .    
    Now 
    
    .. math:: 
    
        h_{\Lambda} = h_{\Lambda_0} + h_{\Lambda_1}.
    
    Let 
    
    .. math:: 
    
        x = h_{\Lambda_0} + h_{\Lambda^c}.
    
    Let 
    
    .. math:: 
    
        x' = - h_{\Lambda_1}.
    
    Then 
    
    .. math:: 
    
        h =  x - x'.
     
    By assumption  :math:`h \in \NullSpace(\Phi)` 
    
    Thus
    
    .. math:: 
    
         \Phi h = \Phi(x - x') = 0 \implies \Phi x = \Phi x'.
    
    
    But since  :math:`x' \in \Sigma_K`  
    (recall that  :math:`\Lambda_1`  indexes only  :math:`K`  entries) 
    and   :math:`\Delta`  is able to recover all  :math:`K` -sparse signals exactly, hence
    
    
    .. math:: 
    
        x' = \Delta (\Phi x').
    
    Thus 
    
    .. math:: 
    
        \Delta (\Phi x) = \Delta (\Phi  x') = x'.
    
    i.e. the recovery algorithm  :math:`\Delta`  recovers  :math:`x'`  for
    the signal  :math:`x` . Certainly  :math:`x'`  is not  :math:`K` -sparse.
    
    Finally we also have (since  :math:`h`  contains some additional non-zero entries)
    
    
    .. math:: 
    
        \| h_{\Lambda} \|_2 \leq \| h \|_2  = \| x  - x'\|_2  = \| x - \Delta (\Phi x)\| _2.
    
    
    But as per instance optimal recovery guarantee 
    :eq:`eq:nspguarantee`
    for  :math:`(\Phi, \Delta)`  pair,  we have
   
    .. math::

        \| \Delta (\Phi x) - x \|_2 \leq C \frac{\sigma_K (x)_1}{\sqrt{K}}.

    
    Thus
    
    
    .. math:: 
    
        \| h_{\Lambda} \|_2 \leq C \frac{\sigma_K (x)_1}{\sqrt{K}}.
    
    But 
    
    .. math:: 
    
        \sigma_K (x)_1 = \min_{\widehat{x} \in \Sigma_K} \| x - \widehat{x}\|_1. 
    
    
    Recall that  :math:`x =h_{\Lambda_0} + h_{\Lambda^c}`  where  :math:`\Lambda_0`  indexes  :math:`K`  entries of  :math:`h` 
    which are (magnitude wise) larger than all entries 
    indexed by  :math:`\Lambda^c` .
    Thus the best  :math:`l_1` -norm  :math:`K`  term
    approximation of  :math:`x`  is given by   :math:`h_{\Lambda_0}` . 
    
    Hence

    .. math:: 
    
        	\sigma_K (x)_1  = \|  h_{\Lambda^c} \|_1. 
    
    
    Thus we finally have
    	
    .. math:: 
    
        	\| h_{\Lambda} \|_2 \leq C \frac{\|  h_{\Lambda^c} \|_1}{\sqrt{K}} = \sqrt{2}C \frac{\|  h_{\Lambda^c} \|_1}{\sqrt{2K}}  \quad \forall h \in \NullSpace(\Phi).
    
    
    Thus  :math:`\Phi`  satisfies the NSP of order  :math:`2K` .


It turns out that NSP of order  :math:`2K`  is also sufficient to establish a guarantee of the form above for 
a practical recovery algorithm

.. todo:: Prove it.



