
 
The RIP and the NSP
===================================================

RIP and NSP are connected. If a matrix  :math:`\Phi` satisfies RIP then it also satisfies NSP (under certain conditions). 

Thus RIP is strictly stronger than NSP (under certain conditions).

We will need following lemma which applies to any arbitrary  
:math:`h \in \RR^N` . The lemma will be proved later.

.. _lem:rip_arbitrary_h:

.. lemma:: 

    Suppose that  :math:`\Phi`  satisfies RIP of order  :math:`2K`, 
    and let  :math:`h \in \RR^N, h \neq 0`  be arbitrary. 
    Let :math:`\Lambda_0`  be any subset of  :math:`\{1,2,\dots, N\}`
    such that  :math:`|\Lambda_0| \leq K`.
    
    Define  :math:`\Lambda_1`  as the index set corresponding to the  
    :math:`K`  entries of  :math:`h_{\Lambda_0^c}`  with
    largest magnitude, and set  :math:`\Lambda = \Lambda_0 \cup \Lambda_1`. 
    Then
    
    .. math::
          \| h_{\Lambda} \|_2 \leq 
          \alpha \frac{\| h_{\Lambda_0^c} \|_1 }{ \sqrt{K}} 
          + \beta \frac{| \langle \Phi h_{\Lambda}, \Phi h \rangle | }{\| h_{\Lambda} \|_2},
    
    where
    
    .. math::
          \alpha = \frac{\sqrt{2} \delta_{2K}}{ 1 - \delta_{2K}} , 
          \beta = \frac{1}{ 1 - \delta_{2K}}.
     
Let us understand this lemma a bit. If  :math:`h \in \NullSpace (\Phi)`, 
then the lemma simplifies to

.. math::
      \| h_{\Lambda} \|_2 \leq \alpha \frac{\| h_{\Lambda_0^c} \|_1 }{ \sqrt{K}}

* :math:`\Lambda_0`  maps to the initial few ( :math:`K`  or less) elements 
  we chose.
* :math:`\Lambda_0^c`  maps to all other elements.
* :math:`\Lambda_1`  maps to largest (in magnitude)
  :math:`K`  elements of  :math:`\Lambda_0^c` .
* :math:`h_{\Lambda}`  contains a maximum of  :math:`2K`  non-zero elements.
* :math:`\Phi`  satisfies RIP of order  :math:`2K` .
* Thus  :math:`(1 - \delta_{2K}) \| h_{\Lambda} \|_2 \leq \| \Phi h_{\Lambda} \|_2 \leq (1 + \delta_{2K}) \| h_{\Lambda} \|_2` .

We now state the connection between RIP and NSP.

.. theorem:: 

    Suppose that  :math:`\Phi`  satisfies RIP of order  :math:`2K`  with  :math:`\delta_{2K} < \sqrt{2} - 1` . Then  :math:`\Phi`  satisfies the NSP of
    order  :math:`2K`  with constant 
        
    .. math::
          C= \frac
          {\sqrt{2} \delta_{2K}}
          {1 - (1 + \sqrt{2})\delta_{2K}}

.. proof:: 

    We are given 
      
    .. math:: 
    
        	(1- \delta_{2K}) \| x \|^2_2 \leq \| \Phi x \|^2_2 \leq (1 + \delta_{2K}) \| x \|^2_2
    
    holds for all  :math:`x \in \Sigma_{2K}`
    where  :math:`\delta_{2K}  < \sqrt{2} - 1`.
    
    We have to show that:

    .. math:: 
    
        \| h_{\Lambda}\|_2 \leq C \frac{\| h_{{\Lambda}^c}\|_1 }{\sqrt{K}}
    
    holds  :math:`\forall h \in \NullSpace (\Phi)`  and  :math:`\forall \Lambda`  such that  :math:`|\Lambda| \leq 2K`.
    
    Let  :math:`h \in \NullSpace(\Phi)` . Then  :math:`\Phi h = 0` . 
    
    Let  :math:`\Lambda_m`  denote the  :math:`2K`  largest entries of  :math:`h`.  Then

    .. math:: 
    
        	\| h_{\Lambda}\|_2  \leq \| h_{\Lambda_m}\|_2 \quad \forall \Lambda : |\Lambda| \leq 2K. 
    
    
    Similarly
    
    .. math:: 
    
        	\| h_{\Lambda^c}\|_1  \geq \| h_{\Lambda_m^c}\|_1 \quad \forall \Lambda : |\Lambda| \leq 2K. 
    
    Thus if we show that  :math:`\Phi`  satisfies NSP of order  :math:`2K`  
    for  :math:`\Lambda_m` , i.e.
    	
    .. math:: 
    
        \| h_{\Lambda_m}\|_2 \leq C \frac{\| h_{{\Lambda_m}^c}\|_1 }{\sqrt{K}}
    
    then we would have shown
    it for all  :math:`\Lambda`  such that  :math:`|\Lambda| \leq 2K` . 
    So let  :math:`\Lambda = \Lambda_m` .
    
    We can divide  :math:`\Lambda`  into two components  :math:`\Lambda_0`  
    and  :math:`\Lambda_1`  of size  :math:`K`  each.
    
    Since  :math:`\Lambda`  maps to the largest  :math:`2K`  entries in  
    :math:`h`  hence whatever entries we choose 
    in :math:`\Lambda_0` , the largest  :math:`K`  entries in  
    :math:`\Lambda_0^c`  will be  :math:`\Lambda_1` .
    
    Hence as per  :ref:`lemma above <lem:rip_arbitrary_h>`
    above, we have

    .. math::
          \| h_{\Lambda} \|_2 \leq \alpha \frac{\| h_{\Lambda_0^c}\|_1}{\sqrt{K}}
    
    Also  
    
    .. math:: 
    
          \Lambda = \Lambda_0 \cup \Lambda_1 
          \implies \Lambda_0 = \Lambda \setminus \Lambda_1 = \Lambda \cap \Lambda_1^c
          \implies \Lambda_0^c = \Lambda_1 \cup \Lambda^c
    
    Thus we have
    
    .. math::
          \| h_{\Lambda_0^c} \|_1 = \| h_{\Lambda_1} \|_1 + \| h_{\Lambda^c} \|_1   
    
    We have to get rid of  :math:`\Lambda_1` .
    
    Since  :math:`h_{\Lambda_1} \in \Sigma_K` , by applying 
    :ref:`lem:u_sigma_k_norms <lem:u_sigma_k_norms>` we get
      
    .. math:: 
    
           \| h_{\Lambda_1} \|_1 \leq  \sqrt{K} \| h_{\Lambda_1} \|_2
        
    Hence
    
    
    .. math::
          \| h_{\Lambda} \|_2 \leq 
          \alpha \left ( 
            \| h_{\Lambda_1} \|_2 + 
            \frac{\| h_{\Lambda^c} \|_1}{\sqrt{K}} 
            \right)
    
    
    But since  :math:`\Lambda_1 \subset \Lambda` , hence  :math:`\| h_{\Lambda_1} \|_2 \leq  \| h_{\Lambda} \|_2` , hence
    
    
    .. math::
          &\| h_{\Lambda} \|_2 \leq 
          \alpha \left ( 
            \| h_{\Lambda} \|_2 + 
            \frac{\| h_{\Lambda^c} \|_1}{\sqrt{K}} 
            \right)\\
         \implies &(1 - \alpha) \| h_{\Lambda} \|_2 \leq  \alpha \frac{\| h_{\Lambda^c} \|_1}{\sqrt{K}}\\
        \implies &\| h_{\Lambda} \|_2 \leq \frac{\alpha}{1 - \alpha} \frac{\| h_{\Lambda^c} \|_1}{\sqrt{K}} 
        \quad \text{ if } \alpha \leq 1.
    
    
    Note that the inequality is also satisfied for  
    :math:`\alpha = 1`  in which case, we don't need to bring
    :math:`1-\alpha`  to denominator.
    
    Now 
    
    .. math:: 
    
          &\alpha \leq 1\\
          \implies &\frac{\sqrt{2} \delta_{2K}}{ 1 - \delta_{2K}} \leq 1 \\
          \implies &\sqrt{2} \delta_{2K} \leq 1 - \delta_{2K}\\
          \implies &(\sqrt{2} + 1) \delta_{2K} \leq 1\\
          \implies &\delta_{2K} \leq \sqrt{2} - 1 
    
    
    Putting 
    
    
    .. math::
          C = \frac{\alpha}{1 - \alpha}  = \frac
          {\sqrt{2} \delta_{2K}}
          {1 - (1 + \sqrt{2})\delta_{2K}}
    
    
    we see that  :math:`\Phi`  satisfies NSP of order  :math:`2K`  whenever  :math:`\Phi`  satisfies RIP of order  :math:`2K`  with  :math:`\delta_{2K} \leq \sqrt{2} -1` .
    


Note that for  :math:`\delta_{2K} = \sqrt{2} - 1` ,  :math:`C=\infty` .


.. disqus::
