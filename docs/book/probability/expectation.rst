
 
Expectation
===================================================


This section contains several results on expectation operator.

Any function :math:`g(x)` defines a new random variable :math:`g(X)`. If :math:`g(X)` has a finite expectation, then


.. math::
    \EE [g(X)] = \int_{-\infty}^{\infty} g(x) f_X(x) d x. 


If several random variables :math:`X_1, \dots, X_n` are defined on the same sample space, then
their sum :math:`X_1 + \dots + X_n` is a new random variable. If all of them have
finite expectations, then the expectation of their sum exists and is given by


.. math::
    \EE [X_1 + \dots + X_n] = \EE [X_1] + \dots + \EE [X_n].



If :math:`X` and :math:`Y` are mutually independent random variables with finite expectations, then their product is a random variable with finite expectation
and


.. math::
    \EE (X Y) = \EE (X) \EE (Y).

By induction, if :math:`X_1, \dots, X_n` are mutually independent random variables with finite expectations, then


.. math::
    \EE \left [ \prod_{i=1}^n X_i \right ] = \prod_{i=1}^n \EE \left [  X_i \right ].



Let :math:`X` and :math:`Y` be two random variables with the joint density function :math:`f_{X, Y} (x, y)`. 
Let the marginal density function of  :math:`Y` given :math:`X` be :math:`f(y | x)`. Then
the conditional expectation is defined as follows:


.. math::
        \EE [Y | X] = \int_{-\infty}^{\infty} y f(y | x)  d y.

:math:`\EE [Y | X ]` is a new random variable. 


.. math:: 

    \begin{aligned}
    \EE \left [ \EE [Y | X ] \right ] &= \int_{-\infty}^{\infty} \EE [Y | X] f (x) d x\\
    &= \int_{-\infty}^{\infty}\int_{-\infty}^{\infty} y f(y | x) f (x)  d y  d x\\
    &= \int_{-\infty}^{\infty}y \left ( \int_{-\infty}^{\infty}  f(x, y) d x \right ) d y  \\
    &= \int_{-\infty}^{\infty} y f(y) d y = \EE [Y].
    \end{aligned}

In short, we have


.. math::
    \EE \left [ \EE [Y | X ] \right ] = \EE [Y].


The covariance of :math:`X` and :math:`Y` is defined as


.. math::
    \Cov (X, Y) = \EE \left [ (X - \EE[X]) ( Y - \EE[Y]) \right ].

It is easy to see that


.. math::
    \Cov (X, Y) = \EE [X Y] - \EE [X] \EE [ Y].


The **correlation coefficient** is defined as


.. math::
    \rho  \triangleq \frac{\Cov (X, Y)}{\sqrt{Var (X) Var (Y)}}.





 
Independent variables
----------------------------------------------------

If :math:`X` and :math:`Y` are independent, then


.. math::
    \EE [ g_1(x) g_2 (y)] = \EE [g_1(x)] \EE [g_2 (y)].

If :math:`X` and :math:`Y` are independent, then :math:`\Cov (X, Y)  = 0`.

 
Uncorrelated variables
----------------------------------------------------

The two variables :math:`X` and :math:`Y` are called uncorrelated if :math:`\Cov (X, Y)  = 0`.
Covariance doesn't imply independence.


.. disqus::

