
 
Two variables
===================================================


Let :math:`X` and :math:`Y` be two random variables and let :math:`F_(X, Y)(x, y)` be their joint CDF.



.. math::
    \lim_{\substack{x \to -\infty\\ y \to -\infty}} F_{X, Y} (x, y)  = 0.



.. math::
    \lim_{\substack{x \to \infty\\ y \to \infty}} F_{X, Y} (x, y)  = 1.


Right continuity:


.. math::
    \lim_{x \to x_0^+} F_{X, Y} (x, y)  = F_{X, Y} (x_0, y).



.. math::
    \lim_{y \to y_0^+} F_{X, Y} (x, y)  = F_{X, Y} (x, y_0).


The joint probability density function is given by :math:`f_{X, Y} (x, y)`. It satisfies :math:`f_{X, Y} (x, y) \geq 0` and


.. math::
    \int_{-\infty}^{\infty} \int_{-\infty}^{\infty} f_{X, Y} (x, y) d y d x = 1.


The joint CDF and joint PDF  are related by


.. math::
    F_{X, Y} (x, y) = \PP (X \leq x, Y \leq y) = \int_{-\infty}^{x} \int_{-\infty}^{y} f_{X, Y} (u , v) d v d u.

Further


.. math::
    \PP (a \leq X \leq b, c \leq Y \leq d) = \int_{a}^{b} \int_{c}^{d} f_{X, Y} (u , v) d v d u.

The marginal probability is


.. math::
    \PP (a \leq X \leq b) = \PP (a \leq X \leq b, -\infty \leq Y \leq \infty) = \int_{a}^{b} \int_{-\infty}^{\infty} f_{X, Y} (u , v) d v d u.

We define the marginal density functions as


.. math::
    f_X(x) = \int_{-\infty}^{\infty} f_{X, Y} (x, y) d y

and


.. math::
    f_Y(y) = \int_{-\infty}^{\infty} f_{X, Y} (x, y) d x.

We can now write


.. math::
    \PP (a \leq X \leq b) =  \int_{a}^{b} f_X(x) d x.

Similarly


.. math::
    \PP (c \leq Y \leq d) =  \int_{c}^{d} f_Y(y) d y.


 
Conditional density
----------------------------------------------------

We define


.. math::
    \PP (a \leq x \leq b | y = c) = \int_{a}^{b} f_{X | Y}(x | y = c) d x.

We have


.. math::
    f_{X | Y}(x | y = c) = \frac{f_{X, Y} (x, c)}{f_{Y} (c)}.

In other words


.. math::
    f_{X | Y}(x | y = c) f_{Y} (c) = f_{X, Y} (x, c).

In general we write


.. math::
    f_{X | Y}(x | y) f_Y(y) = f_{X, Y} (x, y).

Or even more loosely as


.. math::
    f(x | y) f(y) = f(x, y).

More identities


.. math::
    f(x | y \leq d) = \frac{ \int_{-\infty}^d  f(x, y)  d y} {\PP (y \leq d)}.


 
Independent variables
----------------------------------------------------

If :math:`X` and :math:`Y` are independent then


.. math::
    f_{X, Y}(x, y)  = f_X(x) f_Y(y).



.. math::
    f(x | y)  = \frac{f(x, y)}{f(y)} = \frac{f(x) f(y)}{f(y)} = f(x).

Similarly


.. math::
    f(y | x) = f(y).

The CDF also is separable


.. math::
    F_{X, Y}(x, y)  = F_X(x) F_Y(y).










