
 
Subgaussian distributions
===================================================

.. _sec:subgaussian:


In this section we review subgaussian distributions and
matrices drawn from subgaussian distributions.

Examples of subgaussian distributions include


*  Gaussian distribution
*  Rademacher distribution taking values  :math:`\pm \frac{1}{\sqrt{M}}` 
*  Any zero mean distribution with a bounded support





.. definition:: 

    A random variable  :math:`X`  is called \textbf{subgaussian} if there exists a constant  :math:`c > 0`  such that
    
    
    .. math::
        :label: eq:sub_gaussian_definition
    
          M_X(t)  = \EE [\exp(X t) ] \leq \exp \left (\frac{c^2 t^2}{2} \right )
    
    holds for all  :math:`t \in \RR` . We use the notation 
     :math:`X \sim \Sub (c^2)`  to denote that  :math:`X`  satisfies the 
    constraint \eqref{eq:sub_gaussian_definition}.
    We also say that  :math:`X`  is  :math:`c` -subgaussian.
     
    .. index:: Subgaussian
    


 :math:`\EE [\exp(X t) ]`  is moment generating function of  :math:`X` .

 :math:`\exp \left (\frac{c^2 t^2}{2} \right )`  is moment generating function of a Gaussian random variable with variance  :math:`c^2` .

The definition means that for a subgaussian variable  :math:`X` , its M.G.F. is bounded by the M.G.F. of a Gaussian random variable  :math:`\sim \mathcal{N}(0, c^2)` .



.. example:: Gaussian r.v. as subgaussian r.v.

    Consider zero-mean Gaussian random variable  :math:`X \sim \mathcal{N}(0, \sigma^2)`  with variance  :math:`\sigma^2` .
    Then 
      
    
    .. math:: 
    
          \EE [\exp(X t) ] = \exp\left ( \frac{\sigma^2 t^2}{2} \right ) 
    
    Putting  :math:`c = \sigma`  we see that \eqref{eq:sub_gaussian_definition} is satisfied.
    Hence  :math:`X\sim \Sub(\sigma^2)`  is a subgaussian r.v.
    or  :math:`X`  is  :math:`\sigma` -subgaussian.




.. example:: Rademacher distribution

    Consider  :math:`X`  with 
      
    
    .. math:: 
    
          \PP_X(x) = \frac{1}{2}\delta(x-1) + \frac{1}{2}\delta(x + 1) 
    
    i.e.  :math:`X`  takes a value  :math:`1`  with probability  :math:`0.5`  and value  :math:`-1`  with probability  :math:`0.5` .
    
    Then 
      
    
    .. math:: 
    
          \EE [\exp(X t) ] = \frac{1}{2} \exp(-t) + \frac{1}{2} \exp(t) = \cosh t \leq \exp \left ( \frac{t^2}{2} \right) 
    
    
    Thus  :math:`X \sim \Sub(1)`  or  :math:`X`  is 1-subgaussian.
    
    




.. example:: Uniform distribution

    Consider  :math:`X`  as uniformly distributed over the interval  :math:`[-a, a]`  for some  :math:`a > 0` . i.e.
      
    
    .. math:: 
    
          f_X(x) = \begin{cases}
          \frac{1}{2 a} & -a \leq x \leq a\\
          0 & \text{otherwise}
          \end{cases}
    
    Then 
    \begin{equation*}
        \EE [\exp(X t) ]  = \frac{1}{2 a}  \int_{-a}^{a} \exp(x t)d x =  \frac{1}{2 a t}  [e^{at} - e^{-at}]
        = \sum_{n = 0}^{\infty}\frac{(at)^{2 n}}{(2 n + 1)!}
    \end{equation*}
    But  :math:`(2n+1)! \geq n! 2^n` . Hence we have
    
    
    .. math:: 
    
          \sum_{n = 0}^{\infty}\frac{(at)^{2 n}}{(2 n + 1)!} \leq \sum_{n = 0}^{\infty}\frac{(at)^{2 n}}{( n! 2^n)} 
          = \sum_{n = 0}^{\infty}\frac{(a^2 t^2 / 2)^{n}}{( n!)} = \exp \left (\frac{a^2 t^2}{2} \right ) 
    
    Thus
      
    
    .. math:: 
    
           \EE [\exp(X t ]  \leq \exp \left ( \frac{a^2 t^2}{2} \right ).
    
    
    Hence  :math:`X \sim \Sub(a^2)`  or  :math:`X`  is  :math:`a` -subgaussian.
    




.. example:: Random variable with bounded support

    Consider  :math:`X`  as a zero mean, bounded random variable i.e.
      
    
    .. math:: 
    
          \PP(|X| \leq B) = 1 
    
    for some  :math:`B \in \RR^+` 
    and
    
    
    .. math:: 
    
        \EE(X) = 0.
    
    Then, the following upper bound holds:
    
    
    .. math::
          \EE [ \exp(X t) ] =  \int_{-B}^{B} \exp(x t) f_X(x) d x \leq \exp\left (\frac{B^2 t^2}{2} \right )
    
    
    This result can be proven with some advanced calculus. 
     :math:`X \sim \Sub(B^2)`  or  :math:`X`  is  :math:`B` -subgaussian.


There are some useful properties of subgaussian random variables.



.. lemma:: 

    If  :math:`X \sim \Sub(c^2)`  then
    
    
    .. math::
          \EE (X) = 0
    
    and
    
    
    .. math::
          \EE(X^2) \leq c^2
    
    


Thus subgaussian random variables are always zero-mean.

Their variance is always bounded by the variance of the bounding Gaussian distribution.



.. proof:: 

    
    
    
    .. math::
          \sum_{n = 0}^{\infty} \frac{t^n}{n!} \EE (X^n) = \EE \left( \sum_{n = 0}^{\infty} \frac{(X t)^n}{n!} \right ) 
          = \EE \left ( \exp(X t) \right )
    
    
    But since  :math:`X \sim \Sub(c^2)`  hence
    
    
    .. math::
          \sum_{n = 0}^{\infty} \frac{t^n}{n!} \EE (X^n) \leq \exp \left ( \frac{c^2 t^2}{2} \right) = 
          \sum_{n = 0}^{\infty} \frac{c^{2 n} t^{2 n}}{2^n n!}
    
    
    Restating
    
    
    .. math::
          \EE (X) t + \EE (X^2) \frac{t^2}{2!} \leq \frac{c^2 t^2}{2} + \smallO{t^2} \text{ as } t \to 0.
    
    
    Dividing throughout by  :math:`t > 0`  and letting  :math:`t \to 0`  we get  :math:`\EE (X) \leq 0` . 
    
    Dividing throughout by  :math:`t < 0`  and letting  :math:`t \to 0`  we get  :math:`\EE (X) \geq 0` . 
    
    Thus  :math:`\EE (X) = 0` . So  :math:`\Var(X) = \EE (X^2)` . 
    
    Now we are left with 
    
    
    .. math::
         \EE (X^2) \frac{t^2}{2!} \leq \frac{c^2 t^2}{2} + \smallO{t^2} \text{ as } t \to 0.
    
    
    Dividing throughout by  :math:`t^2`  and letting  :math:`t \to 0`  we get   :math:`\Var(X) \leq c^2` 


Subgaussian variables have a linear structure.




.. theorem:: 

    If  :math:`X \sim \Sub(c^2)`  i.e.  :math:`X`  is  :math:`c` -subgaussian, 
    then for any  :math:`\alpha \in \RR` , the
    r.v.  :math:`\alpha X`  is  :math:`|\alpha| c` -subgaussian.
    
    If  :math:`X_1, X_2`  are r.v. such that  :math:`X_i`  is
     :math:`c_i` -subgaussian, then 
     :math:`X_1 + X_2`  is  :math:`c_1 + c_2` -subgaussian.




.. proof:: 

    Let  :math:`X`  be  :math:`c` -subgaussian. Then
    
    
    .. math:: 
    
          \EE [\exp(X t) ] \leq \exp \left (\frac{c^2 t^2}{2} \right )
    
    
    Now for  :math:`\alpha \neq 0` , we have
    
    
    .. math:: 
    
        \EE [\exp(\alpha X t) ] \leq \exp \left (\frac{\alpha^2 c^2 t^2}{2} \right )
        = \leq \exp \left (\frac{(|\alpha | c)^2 t^2}{2} \right )
    
    Hence  :math:`\alpha X`  is  :math:`|\alpha| c` -subgaussian.
    
    Now consider  :math:`X_1`  as  :math:`c_1` -subgaussian and  :math:`X_2`  as  :math:`c_2` -subgaussian.
    
    Thus
    
    
    .. math:: 
    
          \EE (\exp(X_i t) ) \leq \exp \left (\frac{c_i^2 t^2}{2} \right )
    
    
    Let  :math:`p, q >1`  be two numbers s.t.  :math:`\frac{1}{p} + \frac{1}{q} = 1` .
    
    Using  H\"older's inequality, we have
    
    
    .. math:: 
    
        \EE (\exp((X_1  + X_2)t) ) 
        &\leq 
        \left [ \EE (\exp(X_1 t) )^p\right ]^{\frac{1}{p}}
        \left [ \EE (\exp(X_2 t) )^q\right ]^{\frac{1}{q}}\\
        &= 
        \left [ \EE (\exp( p X_1 t) )\right ]^{\frac{1}{p}}
        \left [ \EE (\exp(q X_2 t) )\right ]^{\frac{1}{q}}\\
        &\leq
        \left [ \exp \left (\frac{(p c_1)^2 t^2}{2} \right ) \right ]^{\frac{1}{p}}
        \left [ \exp \left (\frac{(q c_2)^2 t^2}{2} \right ) \right ]^{\frac{1}{q}}\\
        &= \exp \left ( \frac{t^2}{2} ( p c_1^2 + q c_2^2) \right ) \\
        &= \exp \left ( \frac{t^2}{2} ( p c_1^2 + \frac{p}{p - 1} c_2^2) \right ) 
    
    
    Since this is valid for any  :math:`p > 1` , we can minimize the r.h.s. 
    over  :math:`p > 1` .  If suffices to minimize the term
    
    
    .. math:: 
    
        r = p c_1^2 + \frac{p}{p - 1} c_2^2.
    
    
    We have 
    
    
    .. math:: 
    
        \frac{\partial r}{\partial p} = c_1^2 - \frac{1}{(p-1)^2}c_2^2
    
    
    Equating it to 0 gives us
    
    
    .. math:: 
    
        p - 1 = \frac{c_2}{c_1}
        \implies p = \frac{c_1 + c_2}{c_1}
        \implies \frac{p}{p -1} = \frac{c_1 + c_2}{c_2}
    
    
    Taking second derivative, we can verify that this is indeed a minimum value.
    
    Thus
    
    
    .. math:: 
    
        r_{\min} = (c_1 + c_2)^2
    
    
    Hence we have the result
    
    
    .. math:: 
    
        \EE (\exp((X_1  + X_2)t) ) 
        \leq
        \exp \left (\frac{(c_1+ c_2)^2 t^2}{2} \right )
    
    
    Thus  :math:`X_1 + X_2`  is  :math:`(c_1 + c_2)` -subgaussian.
    


If  :math:`X_1`  and  :math:`X_2`  are independent, then 
 :math:`X_1 + X_2`  is  :math:`\sqrt{c_1^2 + c_2^2}` -subgaussian.


If  :math:`X`  is  :math:`c` -subgaussian then naturally,  :math:`X`  is  :math:`d` -subgaussian
for any  :math:`d \geq c` . A question arises as to what is the minimum
value of  :math:`c`  such that  :math:`X`  is  :math:`c` -subgaussian. 



.. definition:: 

    For a centered random variable  :math:`X` , the \textbf{subgaussian moment}
    of  :math:`X` , denoted by  :math:`\sigma(X)` , is defined as
    
    
    .. math::
        \sigma(X) = \inf \left \{ c \geq 0 \; |  \;
        \EE (\exp(X t) ) \leq \exp \left (\frac{c^2 t^2}{2} \right ), \Forall t \in \RR.
         \right \}
    
    
     :math:`X`  is subgaussian if and only if  :math:`\sigma(X)`  is finite.
     
    .. index:: Subgaussian moment
    


We can also show that  :math:`\sigma(\cdot)`  is a norm on the
space of subgaussian random variables. And this
normed space is complete.

For centered Gaussian r.v.  :math:`X \sim \mathcal{N}(0, \sigma^2)` , 
the subgaussian moment coincides with the standard deviation.
 :math:`\sigma(X) = \sigma` .




Sometimes it is useful to consider more restrictive class of subgaussian random variables.


.. definition:: 

    A random variable  :math:`X`  is called \textbf{strictly subgaussian} if  :math:`X \sim \Sub(\sigma^2)`  where
     :math:`\sigma^2 =  \EE(X^2)` , i.e. the inequality
    
    
    .. math::
          \EE (\exp(X t) ) \leq \exp \left (\frac{\sigma^2 t^2}{2} \right ) 
    
    holds true for all  :math:`t \in \RR` . 
    
    We will denote strictly subgaussian variables by  :math:`X \sim \SSub (\sigma^2)` .
     
    .. index:: Strictly subgaussian
    




.. example:: Gaussian distribution

    If  :math:`X \sim \mathcal{N} (0, \sigma^2)`  then  :math:`X \sim \SSub(\sigma^2)` .


 
Characterization of subgaussian random variables
----------------------------------------------------


We quickly review Markov's inequality which will help us establish the results in this section.



.. lemma:: 

    Let  :math:`X`  be a non-negative random variable. And let  :math:`t > 0` . Then
    
    
    .. math::
          \PP (X \geq t ) \leq \frac{\EE (X)}{t}.
    
    \todo{Move this into a chapter on probability. Include the proof.}




.. theorem:: 

    For a centered random variable  :math:`X` , the following statements are 
    equivalent:
    
    *  moment generating function condition:
    
    
    .. math::
          \EE [\exp(X t) ] \leq \exp \left (\frac{c^2 t^2}{2} \right ) \Forall t \in \RR.
    *  subgaussian tail estimate: There exists  :math:`a > 0`  such that 
    
    
    .. math::
             \PP(|X| \geq \lambda) \leq 2 \exp (- a \lambda^2) \Forall \lambda > 0.
    *   :math:`\psi_2` -condition: There exists some  :math:`b > 0`  such that
    
    
    .. math::
        \EE [\exp (b X^2) ] \leq 2.
    
    
    




.. proof:: 

     :math:`(1) \implies (2)`  Using Markov's inequality, for any  :math:`t > 0`  we have
    
    
    .. math:: 
    
        \PP(X \geq \lambda) 
        &= \PP (t X \geq t \lambda) 
        = \PP \left(e^{t X} \geq e^{t \lambda} \right )\\
        &\leq \frac{\EE \left ( e^{t X} \right ) }{e^{t \lambda}} 
        \leq \exp \left ( - t \lambda + \frac{c^2 t^2}{2}\right ) \Forall t \in \RR. 
    
    
    Since this is valid for all  :math:`t \in \RR` , hence it should be valid for
    the minimum value of r.h.s.
    
    The minimum value is obtained for  :math:`t = \frac{\lambda}{c^2}` .
    
    Thus we get
    
    
    .. math::
        \PP(X \geq \lambda) \leq \exp \left ( - \frac{\lambda^2}{2 c^2}\right ) 
    
    
    Since  :math:`X`  is  :math:`c` -subgaussian, hence  :math:`-X`  is also  :math:`c` -subgaussian.
    
    Hence 
    
    
    .. math:: 
    
        \PP (X \leq - \lambda) = \PP (-X \geq \lambda)
        \leq \exp \left ( - \frac{\lambda^2}{2 c^2}\right ) 
    
    
    Thus
    
    
    .. math:: 
    
        \PP(|X| \geq \lambda) = \PP (X \leq - \lambda) + \PP(X \geq \lambda)
        \leq 2 \exp \left ( - \frac{\lambda^2}{2 c^2}\right )
    
    
    Thus we can choose  :math:`a = \frac{1}{2 c^2}`  to complete the proof.
    
     :math:`(2)\implies (3)` 
    
    TODO PROVE THIS
    
    
    
    .. math:: 
    
        \EE (\exp (b X^2)) \leq 1 + \int_0^{\infty} 2 b t \exp (b t^2) \PP (|X| > t)d t
    
    
     :math:`(3)\implies (1)` 
    
    TODO PROVE THIS
    
    
    




 
More properties
----------------------------------------------------


We also have the following result on the exponential moment of a subgaussian random variable.



.. lemma:: 

    Suppose  :math:`X \sim \Sub(c^2)` . Then 
    
    
    .. math::
          \EE \left [\exp \left ( \frac{\lambda X^2}{2 c^2} \right ) \right ] \leq \frac{1}{\sqrt{1 - \lambda}} 
    
    for any  :math:`\lambda \in [0,1)` .
    \label {lem:subgaussian_exp_square_moment}




.. proof:: 

    We are given that 
    
    
    .. math:: 
    
          &\EE (\exp(X t) ) \leq \exp \left (\frac{c^2 t^2}{2} \right )\\
          &\implies \int_{-\infty}^{\infty} \exp(t x) f_X(x) d x 
          \leq \exp \left (\frac{c^2 t^2}{2} \right ) \Forall t \in \RR\\
    
    
    Multiplying on both sides with  :math:`\exp \left ( -\frac{c^2 t^2}{2 \lambda} \right )` :
    
    
    
    .. math:: 
    
         \int_{-\infty}^{\infty} \exp \left (t x - \frac{c^2 t^2}{2 \lambda}\right ) f_X(x) d x 
          \leq \exp \left (\frac{c^2 t^2}{2}\frac{\lambda-1}{\lambda} \right )
          = \exp \left (-\frac{t^2}{2}\frac{c^2 (1 - \lambda)}{\lambda} \right )
    
    
    Integrating on both sides w.r.t.  :math:`t`  we get:
    
    
    .. math:: 
    
         \int_{-\infty}^{\infty} \int_{-\infty}^{\infty} 
         \exp \left (t x - \frac{c^2 t^2}{2 \lambda}\right ) f_X(x) d x  d t 
         \leq \int_{-\infty}^{\infty} \exp \left (-\frac{t^2}{2}\frac{c^2 (1 - \lambda)}{\lambda} \right ) d t
    
    
    which reduces to:
    
    
    .. math:: 
    
        &\frac{1}{c} \sqrt{2 \pi \lambda} \int_{-\infty}^{\infty} 
        \exp \left ( \frac{\lambda x^2}{2 c^2} \right ) f_X(x) d x
        \leq \frac{1}{c} \sqrt {\frac{2 \pi \lambda}{1 - \lambda}}\\
        \implies
        &  \EE \left (\exp \left ( \frac{\lambda X^2}{2 c^2} \right ) \right ) \leq \frac{1}{\sqrt{1 - \lambda}}  
    
    
    which completes the proof.
    


 
Subgaussian random vectors
----------------------------------------------------


The linearity property of subgaussian r.v.s can be extended
to random vectors also. This is
stated more formally in following result.



.. theorem:: 

    Suppose that  :math:`X = [X_1, X_2,\dots, X_N]` , where each  :math:`X_i`  is i.i.d. with  :math:`X_i \sim \Sub(c^2)` . Then
    for any  :math:`\alpha \in \RR^N` ,  :math:`\langle X, \alpha \rangle \sim \Sub(c^2 \| \alpha \|^2_2)` . Similarly if
    each   :math:`X_i \sim \SSub(\sigma^2)` , then
    for any  :math:`\alpha \in \RR^N` ,  :math:`\langle X, \alpha \rangle \sim \SSub(\sigma^2 \| \alpha \|^2_2)` .


\textbf{Norm of a subgaussian random vector}:
Let  :math:`X`  be a random vector where each  :math:`X_i`  is i.i.d. with  :math:`X_i \sim \Sub (c^2)` .

Consider the  :math:`l_2`  norm  :math:`\| X \|_2` . It is a random variable in its own right.

It would be useful to understand the average
behavior of the norm.

Suppose  :math:`N=1` .  Then  :math:`\| X \|_2 = |X_1|` .

Also  :math:`\| X \|^2_2 = X_1^2` . Thus  :math:`\EE (\| X \|^2_2) = \sigma^2` .

[leftmargin=*]
*  It looks like  :math:`\EE (\| X \|^2_2)`  should be connected with  :math:`\sigma^2` .
*  Norm can increase or decrease compared to the average value.
*  A ratio based measure between actual value and average value would be useful.
*  What is the probability that the norm increases beyond a given factor?
*  What is the probability that the norm reduces beyond a given factor?


These bounds are stated formally in the following theorem.




.. theorem:: 

    Suppose that  :math:`X = [X_1, X_2,\dots, X_N]` , where each  :math:`X_i`  is i.i.d. with  :math:`X_i \sim \Sub(c^2)` .
    
    Then
    
    
    .. math::
        :label: eq:subgaussian_vector_norm_expectation
    
        \EE (\| X \|_2^2 ) = N \sigma^2.
    
    
    Moreover, for any  :math:`\alpha \in (0,1)`  and for any  :math:`\beta \in [\frac{c^2}{\sigma^2}, \beta_{\max}]` , there exists a constant  :math:`\kappa^* \geq 4`  depending only on 
     :math:`\beta_{\max}`  and the ratio  :math:`\frac{\sigma^2}{c^2}`  such that
    
    
    .. math::
        :label: eq:subgaussian_vector_norm_reduction_probability
    
        \PP (\| X \|_2^2 \leq \alpha N \sigma^2) 
        \leq \exp \left ( - \frac{ N (1 - \alpha)^2}{\kappa^*} \right ) 
    
    and
    
    
    .. math::
        :label: eq:subgaussian_vector_norm_expansion_probability
    
        \PP (\| X \|_2^2 \geq \beta N \sigma^2) 
        \leq \exp \left ( - \frac{ N (\beta - 1)^2}{\kappa^*} \right ) 
    

[leftmargin=*]
*  First equation gives the average value of the square of the norm.
*  Second inequality states the upper bound on the probability that norm 
could reduce beyond a factor given by  :math:`\alpha < 1` .
*  Third inequality states the upper bound on the probability that norm
could increase beyond a factor given by  :math:`\beta > 1` .
*  Note that if  :math:`X_i`  are strictly subgaussian, then  :math:`c=\sigma` . Hence
 :math:`\beta \in (1, \beta_{\max})` .




.. proof:: 

    Since  :math:`X_i`  are independent hence
    
    
    .. math::
        \EE \left [ \| X \|_2^2 \right ]  = \EE \left [ \sum_{i=1}^N X_i^2 \right ] 
        = \sum_{i=1}^N \EE \left [ X_i^2 \right ] = N \sigma^2.
    
    This proves the first part. That was easy enough. 
    
    Now let us look at \eqref{eq:subgaussian_vector_norm_expansion_probability}.
    
    By applying Markov's inequality for any  :math:`\lambda > 0`  we have:
    
    
    
    .. math:: 
    
        \PP (\| X \|_2^2 \geq \beta N \sigma^2)  
        &= \PP \left ( \exp (\lambda \| X \|_2^2 ) \geq \exp (\lambda \beta N \sigma^2) \right) \\
        & \leq \frac{\EE (\exp (\lambda \| X \|_2^2 )) }{\exp (\lambda \beta N \sigma^2)}
        = \frac{\prod_{i=1}^{N}\EE (\exp ( \lambda X_i^2 )) }{\exp (\lambda \beta N \sigma^2)}
    
    
    Since  :math:`X_i`  is  :math:`c` -subgaussian, hence from \cref {lem:subgaussian_exp_square_moment}
    we have 
    
    
    .. math:: 
    
        \EE (\exp ( \lambda X_i^2 )) = \EE \left (\exp \left ( \frac{2 c^2\lambda X_i^2}{2 c^2} \right ) \right)
        \leq \frac{1}{\sqrt{1 - 2 c^2 \lambda}}.
    
    
    Thus:
    
    
    .. math:: 
    
        \prod_{i=1}^{N}\EE (\exp ( \lambda X_i^2 )) \leq  \left ( \frac{1}{\sqrt{1 - 2 c^2 \lambda}} \right )^{\frac{N}{2}}.
    
    
    
    Putting it back we get:
    
    
    .. math:: 
    
        \PP (\| X \|_2^2 \geq \beta N \sigma^2)  
        \leq \left (\frac{\exp (- 2\lambda \beta \sigma^2)}{\sqrt{1 - 2 c^2 \lambda}}\right )^{\frac{N}{2}}.
    
    
    Since above is valid for all  :math:`\lambda > 0` , we can minimize the R.H.S. over  :math:`\lambda`  by setting the
    derivative w.r.t.  :math:`\lambda`  to  :math:`0` .
    
    Thus we get optimum  :math:`\lambda`  as:
    
    
    .. math:: 
    
        \lambda = \frac{\beta \sigma^2  - c^2 }{2 c^2 \sigma^2 (1 + \beta)}.
    
    
    Plugging this back we get:
    
    
    .. math::
        \PP (\| X \|_2^2 \geq \beta N \sigma^2)  \leq
        \left ( \beta \frac{\sigma^2}{c^2}  \exp \left ( 1  - \beta \frac{\sigma^2}{c^2} \right ) \right ) ^{\frac{N}{2}}.
    
    
    Similarly proceeding for \eqref{eq:subgaussian_vector_norm_reduction_probability} we get
    
    
    .. math::
        \PP (\| X \|_2^2 \leq \alpha N \sigma^2)  \leq
        \left ( \alpha \frac{\sigma^2}{c^2}  \exp \left ( 1  - \alpha \frac{\sigma^2}{c^2} \right ) \right ) ^{\frac{N}{2}}.
    
    
    We need to simplify these equations. We will do some jugglery now.
    
    Consider the function
    
    
    .. math::
        f(\gamma) = \frac{2 (\gamma - 1)^2}{(\gamma-1) - \ln \gamma}  \Forall \gamma > 0.
    
    
    By differentiating twice, we can show that this is a strictly increasing function.
    
    Let us have  :math:`\gamma \in (0, \gamma_{\max}]` . 
    
    Define
    
    
    .. math::
        \kappa^* = \max \left ( 4, \frac{2 (\gamma_{\max} - 1)^2}{(\gamma_{\max}-1) - \ln \gamma_{\max}} \right )
    
    
    Clearly
    
    
    .. math::
        \kappa^* \geq  \frac{2 (\gamma - 1)^2}{(\gamma-1) - \ln \gamma} \Forall \gamma \in (0, \gamma_{\max}].
    
    
    Which gives us:
    
    
    .. math::
        \ln (\gamma) \leq (\gamma - 1) - \frac{2 (\gamma - 1)^2}{\kappa^*}.
    
    
    Hence by exponentiating on both sides we get:
    
    
    .. math::
        \gamma \leq \exp \left [ (\gamma - 1) - \frac{2 (\gamma - 1)^2}{\kappa^*} \right ].
    
    
    By slight manipulation we get:
    
    
    .. math::
        \gamma  \exp ( 1 - \gamma) \leq \exp \left [ \frac{2 (1 - \gamma )^2}{\kappa^*} \right ].
    
    
    We now choose 
    
    
    .. math:: 
    
        \gamma = \alpha \frac{\sigma^2}{c^2}
    
    
    Substituting we get:
    
    
    
    .. math::
        \PP (\| X \|_2^2 \leq \alpha N \sigma^2)  \leq
        \left ( \gamma \exp \left ( 1  - \gamma \right ) \right ) ^{\frac{N}{2}}
        \leq \exp \left [ \frac{N (1 - \gamma )^2}{\kappa^*} \right ] .
    
    
    Finally
    
    
    .. math:: 
    
        c \geq \sigma \implies \frac{\sigma^2}{c^2}\leq 1 \implies \gamma \leq \alpha 
        \implies 1 - \gamma \geq 1 - \alpha
    
    
    Thus we get
    
    
    .. math::
        \PP (\| X \|_2^2 \leq \alpha N \sigma^2) 
        \leq \exp \left [ \frac{N (1 - \alpha )^2}{\kappa^*} \right ] .
    
    
    Similarly by choosing  :math:`\gamma = \beta \frac{\sigma^2}{c^2}`  proves the other bound.
    
    We can now map  :math:`\gamma_{\max}`  to some  :math:`\beta_{\max}`  by:
    
    
    .. math:: 
    
        \gamma_{\max} = \frac {\beta_{\max} \sigma^2 }{c^2}.
    
    


This result tells us that given a vector with entries drawn from a subgaussian
distribution, we can expect the norm of the vector to concentrate around its 
expected value  :math:`N\sigma^2` . 


Bibliography
-------------------


.. bibliography:: ../../sksrrcs.bib
    