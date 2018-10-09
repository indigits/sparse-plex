Gaussian distribution
===================================================


 
Standard normal distribution
----------------------------------------------------

This distribution has a mean of 0 and a variance of 1. It is denoted by


.. math::
    X \sim \NNN(0, 1).


The PDF is given by


.. math::
    f_X(x) = \frac{1}{\sqrt{2\pi}} \exp \left ( - \frac{x^2}{2} \right ).

The CDF is given by


.. math::
    F_X(x) = \int_{-\infty}^x f_X(t) d t
    = \frac{1}{\sqrt{2\pi}} \int_{-\infty}^{x} \exp \left ( - \frac{t^2}{2} \right ) d t.

Symmetry


.. math::
    f(-x) = f(x). \quad F(-x) + F(x)  = 1.

Some specific values


.. math::
    F_X(-\infty) = 0, \quad  F_X(0) = \frac{1}{2}, 
    \quad F_X(\infty) = 1.




The Q-function is given as


.. math::
    Q(x) = \int_{x}^{\infty} f_X(t) d t 
    = \frac{1}{\sqrt{2\pi}} \int_{x}^{\infty} \exp \left ( - \frac{t^2}{2} \right ) d t.


We have


.. math::
    F_X(x) + Q(x) = 1. 

Alternatively


.. math::
    F_X(x) = 1 - Q(x).

Further


.. math::
    Q(x) + Q(-x) = 1.

This is due to the symmetry of normal distribution.
Alternatively


.. math::
    Q(x)  = 1 - Q(-x).

Probability of :math:`X` falling in a range :math:`[a,b]`


.. math::
    \PP (a \leq X \leq b) =  Q(a) - Q(b) = F(b) - F(a).



The characteristic function is


.. math::
    \Psi_X(j\omega) = \exp\left ( - \frac{\omega^2}{2}\right ).

Mean:


.. math::
    \mu = \EE (X) = 0.

Mean square value


.. math::
    \EE (X^2) = 1.

Variance:


.. math::
    \sigma^2 = \EE (X^2) - \EE(X)^2 = 1.

Standard deviation


.. math::
    \sigma = 1.


An upper bound on Q-function


.. math::
    Q(x) \leq \frac{1}{2} \exp \left ( - \frac{x^2}{2} \right ).



The moment generating function is


.. math::
    M_X(t) = \exp\left ( \frac{t^2}{2}\right ).



 
Error function and its properties
----------------------------------------------------

The **error function** is defined as


.. math::
    \erf(x) \triangleq  \frac{2}{\sqrt{\pi}} \int_0^x \exp\left ( - t^2 \right) d t.


The **complementary error function** is defined as


.. math::
    \erfc(x) = 1 - \erf(x) = \frac{2}{\sqrt{\pi}} \int_x^{\infty} \exp\left ( - t^2 \right) d t.


Error function is an odd function.


.. math::
    \erf(-x) = - \erf(x).

Some specific values of error function.


.. math::
    \erf(0) = 0, \quad \erf(-\infty) = -1 , \quad \erf (\infty) = 1.


The relationship with normal CDF.


.. math::
    F_X(x) = \frac{1}{2} + \frac{1}{2}  \erf \left ( \frac{x}{\sqrt{2}}\right)
    = \frac{1}{2} \erfc \left (- \frac{x}{\sqrt{2}}\right).

Relationship with Q function.


.. math::
    Q(x) = \frac{1}{2} \erfc\left (\frac{x}{\sqrt{2}} \right)
    = \frac{1}{2} - \frac{1}{2}  \erf \left ( \frac{x}{\sqrt{2}} \right ).




.. math::
    \erfc(x) = 2 Q(\sqrt{2} x).


We also have some useful results:


.. math::
    \int_0^{\infty} \exp\left ( - \frac{t^2}{2}\right ) d t 
    = \sqrt{\frac{\pi}{2}}.



 
General normal distribution
""""""""""""""""""""""""""""""""""""""""""""""""""""""


The general Gaussian (or normal) random variable
is denoted as


.. math::
    X \sim \NNN (\mu, \sigma^2).


Its PDF is


.. math::
    f_X( x) = \frac{1}{\sqrt{2 \pi} \sigma} \exp \left ( 
    \frac{1}{2} \frac{(x -\mu)^2}{\sigma^2}.
    \right)

A simple transformation 


.. math:: 

    Y  = \frac{X - \mu}{\sigma}

converts it into standard normal random variable.

The mean:


.. math::
    \EE (X) = \mu.

The mean square value:


.. math::
    \EE (X^2) = \sigma^2 + \mu^2.

The variance:


.. math::
    \EE (X^2) - \EE (X)^2 = \sigma^2.

The CDF:


.. math::
    F_X(x) = \frac{1}{2} + \frac{1}{2}  \erf \left ( \frac{x - \mu}{\sigma\sqrt{2}}\right).

Notice the transformation from :math:`x` to :math:`(x - \mu) / \sigma`.


The characteristic function:


.. math::
    \Psi_X(j\omega) = \exp\left (j \omega \mu - \frac{\omega^2 \sigma^2}{2}\right ).

Naturally putting :math:`\mu = 0` and :math:`\sigma = 1`, it reduces
to the CF of the standard normal r.v.

Th MGF:


.. math::
    M_X(t) = \exp\left (\mu t  + \frac{\sigma^2 t^2}{2}\right ).


Skewness is zero and Kurtosis is zero.



 
One sided Gaussian distribution
---------------------------------------



 
Truncated normal distribution
---------------------------------------

