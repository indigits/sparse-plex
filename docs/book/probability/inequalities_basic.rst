
 
Basic inequalities
===================================================


Probability theory is all about inequalities. So many results are derived from
the application of these inequalities. This section collects some basic inequalities.

A good reference is 
`Wikipedia list of inequalities <http://en.wikipedia.org/wiki/List_of_inequalities>`_. 
In particular see the 
`section on probability inequalities <http://en.wikipedia.org/wiki/List_of_inequalities#Probability_theory_and_statistics>`_.

In this section we will cover the basic inequalities.

.. index:: Markov's inequality
 
Markov's inequality
----------------------------------------------------

http://en.wikipedia.org/wiki/Markov

.. _res:prob:markov_inequality:

.. theorem:: 


    Let :math:`X` be a non-negative random variable and :math:`a > 0`. Then
    
    
    .. math::
        \PP (X \geq a) \leq \frac{\EE (X)}{a}.
    


.. index:: Chebyshev's inequality
 
Chebyshev's inequality
----------------------------------------------------

http://en.wikipedia.org/wiki/Chebyshev

.. _res:prob:chebyshev_inequality:

.. theorem:: 


    Let :math:`X` be a random variable with finite mean :math:`\mu` and finite non-zero variance :math:`\sigma^2`.
    Then for any real number :math:`k > 0`, the following holds
    
    
    .. math::
        \PP (| X - \mu | \geq k \sigma) \leq \frac{1}{k^2}.
    



.. proof:: 

    TBD.

Choosing :math:`k = \sqrt{2}`, we see that at least half of the values lie in the interval 
:math:`(\mu - \sqrt{2} \sigma, \mu + \sqrt{2} \sigma)`.

.. index:: Boole's inequality
 
Boole's inequality
----------------------------------------------------

http://en.wikipedia.org/wiki/Boole
This is also known as union bound.

.. _res:prob:boole_inequality:

.. theorem:: 


    For a countable set of events :math:`A_1, A_2, \dots`, we have
    
    
    .. math::
        \PP \left ( \bigcup_{i}  A_i \right) \leq \sum_{i} \PP \left ( A_i \right).
    



.. proof:: 

    We first prove it for a finite collection of events using induction.
    For :math:`n=1`, obviously
    
    
    .. math::
        \PP (A_1) \leq \PP (A_1).
    
    Assume the inequality is true for the set of :math:`n` events. i.e.
    
    
    .. math::
        \PP \left ( \bigcup_{i=1}^n  A_i \right) \leq \sum_{i=1}^n \PP \left ( A_i \right).
    
    Since 
    
    
    .. math:: 
    
        \PP (A \cup B ) = \PP (A) + \PP(B) - \PP (A \cap B),
    

    hence


    .. math:: 

        \PP \left ( \bigcup_{i=1}^{n + 1}  A_i \right)  = \PP \left ( \bigcup_{i=1}^n  A_i \right) 
        + \PP (A_{n + 1}) - \PP \left ( \bigcup_{i=1}^n  A_i \bigcap A_{n +1} \right  ). 

    Since


    .. math:: 

         \PP \left ( \bigcup_{i=1}^n  A_i \bigcap A_{n +1} \right  ) \geq 0,

    hence


    .. math:: 

        \PP \left ( \bigcup_{i=1}^{n + 1}  A_i \right) \leq  \PP \left ( \bigcup_{i=1}^n  A_i \right) + \PP (A_{n + 1}) 
        \leq \sum_{i=1}^{n + 1} \PP \left ( A_i \right).

 
Fano's inequality
----------------------------------------------------


 
Cramér–Rao inequality
----------------------------------------------------


.. index:: Hoeffding's inequality for Bernoulli r.v.
 
Hoeffding's inequality
----------------------------------------------------

http://en.wikipedia.org/wiki/Hoeffding

This inequality provides an upper bound on the probability that the sum of random variables
deviates from its expected value.

We start with a version of the inequality for i.i.d Bernoulli random variables.

.. _res:prob:hoeffding_inequality_bernoulli:

.. theorem:: 


    Let :math:`X_1, \dots, X_n` be  i.i.d. Bernoulli random variables with probability of success as :math:`p`. 
    :math:`\EE \left [\sum_i X_i \right] = p n`. The probability of the sum deviating from the mean  
    by :math:`\epsilon n` for some :math:`\epsilon > 0`
    is bounded by
    
    
    .. math::
        \PP \left (\sum_i X_i \leq (p - \epsilon) n \right ) \leq \exp ( -2 \epsilon^2 n) 
    
    and
    
    
    .. math::
        \PP \left (\sum_i X_i \geq (p + \epsilon) n \right ) \leq \exp ( -2 \epsilon^2 n).
    
    The two inequalities can be summarized as
    
    
    .. math::
        \PP \left [ (p - \epsilon) n \leq \sum_i X_i \leq (p + \epsilon) n \right ] \geq 1 - 2\exp ( -2 \epsilon^2 n). 
    

The inequality states that the number of successes that we see is concentrated around its mean
with exponentially small tail.

We now state the inequality for the general case for any (almost surely) bounded random variable.

.. index:: Hoeffding's inequality

.. _res:prob:hoeffding_inequality:

.. theorem:: 

    Let :math:`X_1, \dots, X_n` be independent r.v.s. Assume that :math:`X_i` are almost surely bounded; i.e.: 
    
    
    .. math:: 
    
        \PP \left ( X_i \in [ a_i, b_i] \right ) = 1, \quad 1 \leq i \leq n. 
    
    Define the empirical mean of the variables as
    
    
    .. math:: 
    
        \overline{X}  \triangleq \frac{1}{n} \left ( X_1  + \dots + X_n \right).
    
    Then the probability that :math:`\overline{X}` deviates from its mean :math:`\EE(\overline{X})` 
    by an amount :math:`t > 0`
    is bounded
    by following inequalities:
    
    
    .. math::
        \PP \left ( \overline{X} -  \EE(\overline{X}) \geq t \right ) \leq 
        \exp \left ( - \frac{2 n^2 t^2}{\sum_{i = 1}^n (b_i - a_i)^2} \right)
    
    and
    
    
    .. math::
        \PP \left ( \overline{X} -  \EE(\overline{X}) \leq -t \right ) \leq 
        \exp \left ( - \frac{2 n^2 t^2}{\sum_{i = 1}^n (b_i - a_i)^2} \right).
    
    Together, we have
    
    
    .. math::
        \PP \left ( \left | \overline{X} -  \EE(\overline{X}) \right | \geq t \right ) \leq 
        2\exp \left ( - \frac{2 n^2 t^2}{\sum_{i = 1}^n (b_i - a_i)^2} \right).
    
    

Note that we don't require :math:`X_i` to be identically distributed in this formulation. 
For the special case when :math:`X_i` are i.i.d. uniform r.v.s over :math:`[0, 1]`, then
:math:`\EE(\overline{X}) = \EE(X_i) = \frac{1}{2}` and


.. math::
    \PP \left ( \left | \overline{X} -  \frac{1}{2}\right | \geq t \right ) \leq 
    2\exp \left ( - 2 n t^2 \right).

Clearly, :math:`\overline{X}` starts concentrating around its mean as :math:`n` increases and
the tail falls exponentially.

The proof of this result depends on what is known as **Hoeffding's Lemma**.

.. index:: Hoeffding's lemma

.. _res:prob:hoeffding_lemma:

.. lemma:: 


    Let :math:`X` be a zero mean r.v.  with :math:`\PP (X \in [a, b]) = 1`. Then
    
    
    .. math::
        \EE \left [ \exp (t X) \right] \leq \exp \left ( \frac{1}{8} t^2 (b - a)^2 \right ).
    




 
Jensen's inequality
----------------------------------------------------

http://en.wikipedia.org/wiki/Jensen
Jensen's inequality relates the value of a convex function of an integral to the
integral of the convex function.  In the context of probability theory, the inequality
take the following form.

.. index:: Jensen's inequality

.. _res:prob:jensen_inequality:

.. theorem:: 


    Let :math:`f : \RR \to \RR` be a convex function. Then
    
    
    .. math::
        f \left ( \EE [X] \right ) \leq \EE \left [ f  ( X ) \right  ].
    

The equality holds if and only if either :math:`X` is a constant r.v. or :math:`f` is linear.
 
Bernstein inequalities
----------------------------------------------------


 
Chernoff's inequality
----------------------------------------------------

http://en.wikipedia.org/wiki/Chernoff
This is also known as Chernoff bound.

 
Fréchet inequalities
----------------------------------------------------

