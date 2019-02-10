Soft Thresholding
==================


.. definition::

    Given a function 
    :math:`f : \RR^n \to (-\infty, \infty]`, the
    **proximal mapping** of :math:`f` is the 
    operator given by

    .. math::

        \text{prox}_f(x) = \text{argmin}_u 
        \left \{ f(u) + \frac{1}{2} \| u - x \|_2^2 
        \right\} \quad \forall x \in \RR^n.


The proximal mapping in general is a point to
set mapping. i.e. it maps each point :math:`x \in \RR^n`
to a set of points in :math:`\RR^n` which
minimize the expression on the R.H.S.

When :math:`f` is a proper closed convex function, 
then the set :math:`\text{prox}_f(x)` is a singleton
for each :math:`x \in \RR^n`. In this case, proximal
mapping can be treated as a single valued mapping or a
function.


.. proposition::

    Let :math:`f(x) = c`, then :math:`\text{prox}_f(x) = x`.


.. proof::

    Let 

    .. math::

        g_x(u) = f(u) + \frac{1}{2} \| u - x \|_2^2 = c + \frac{1}{2} \| u - x \|_2^2.


    To minimize :math:`g` over :math:`u`, we differentiate :math:`g`
    w.r.t. :math:`u`.

    .. math::

        \frac{\partial g}{\partial u} = u - x.

    The minimum value is achieved at :math:`u = x`.


    A simpler argument is that :math:`g` is a constant plus a quadratic.
    Thus, the minimum of :math:`g` is achieved when the quadratic is
    0 which happens when :math:`x = u`.



.. proposition::

    Let :math:`f : \RR \to \RR` be defined as
    :math:`f(x) = x`, then :math:`\text{prox}_f(x) = x - 1`.


.. proof::

    Let 

    .. math::

        g_x(u) = f(u) + \frac{1}{2} (u - x)^2 = u + \frac{1}{2} (u - x)^2.

    To minimize :math:`g` over :math:`u`, we differentiate :math:`g`
    w.r.t. :math:`u`.

    .. math::

        \frac{\partial g}{\partial u} = 1 + u - x.

    The minimum value is achieved at :math:`u = x  - 1`.


.. proposition::

    Let :math:`f : \RR \to \RR` be defined as
    :math:`f(x) = \lambda x`, then :math:`\text{prox}_f(x) = x - \lambda`.


.. proposition::

    Let :math:`f` be defined as:

    .. math::

        f(x) = \begin{cases}
            \lambda x & \text{if $x \geq 0$}\\
            \infty & \text{otherwise}
        \end{cases}

    Then :math:`\text{prox}_f(x)` is :math:`[x - \lambda]_+`.

This is one-sided soft-thresholding.


.. proof::

    Note that :math:`f` is differentiable for :math:`x > 0`.
    :math:`\text{prox}_f(x)` is the minimizer of the function

    .. math::

        g(u) = \begin{cases}
        g_1(u) &  u \geq 0 \\
        \infty & u < 0
        \end{cases}

    where 

    .. math::

        g_1(u) = \lambda u + \frac{1}{2} (u - x)^2.

    :math:`g` is a proper, convex and closed function. 
    :math:`g` is differentiable for :math:`u > 0` with
    :math:`g'(u) = g_1'(u)` for :math:`u > 0`.  The
    only point where :math:`g` is non-differentiable is
    :math:`u = 0` in the domain of :math:`g` which is
    :math:`u \geq 0`.

    If :math:`g'(u) = 0`, then :math:`u` is a minimizer
    of :math:`g` (since it is a convex function). 

    :math:`g_1'(u) = 0` iff :math:`u = x - \lambda`. 
    If :math:`x > \lambda`, then :math:`g'(x-\lambda) = g_1'(x-\lambda) = 0`.
    Thus, :math:`\text{prox}_f(x) = x - \lambda` for :math:`x > \lambda`.

    Now if :math:`x \leq \lambda`, the :math:`g'(u)` is never 0
    wherever :math:`g` is differentiable. Since a minimum of 
    :math:`g` exists, it must be attained at a point of non-differentiability.
    The only point of non-differentiability is :math:`u = 0`. Thus,
    :math:`\text{prox}_f(x) = 0` for :math:`x \leq \lambda`.


    .. figure:: images/quadratic_with_restricted_domain.png

        The quadratic :math:`g(u) = 2u + \frac{1}{2} (u - 1)^2`. 
        If the :math:`2u` term was not present, the minimum
        would have been :math:`u = 1`. The term :math:`2u` 
        just shifts the minimum left by 2 to :math:`u = -1`. However,
        if the domain of the function is restricted to :math:`u \geq 0`
        (the red part of the graph), then the minimum is achieved 
        at :math:`u = 0`.

        For general :math:`g(u) = \lambda u + \frac{1}{2}(u - x)`
        with domain limited to :math:`u \geq 0`,
        as long as :math:`x \geq \lambda`, the minimum is achieved
        at :math:`u = x - \lambda`. For all :math:`x < \lambda`, the
        minimum is achieved at :math:`u = 0`.


.. proposition::

    Let :math:`f : \RR \to \RR` be defined as
    :math:`f(x) = \lambda |x|`, then 

    .. math::

        \text{prox}_f(x) = [|x| - \lambda]_+ \sgn(x).


.. proof::

    Note that :math:`f` is differentiable for :math:`x \neq 0`.
    :math:`\text{prox}_f(x)` is the minimizer of the function

    .. math::

        g(u) = \begin{cases}
        g_1(u) = \lambda u + \frac{1}{2} (u - x)^2 &  u \geq 0 \\
        g_2(u) = -\lambda u + \frac{1}{2} (u - x)^2 & u < 0
        \end{cases}


    If a minimizer is obtained at :math:`u > 0`, then 
    :math:`0 = f'(u) = g_1'(u) = \lambda + u - x` giving
    us :math:`u = x - \lambda`. Since, we assumed that :math:`u > 0`,
    hence :math:`x > \lambda`. In other words,
    if :math:`x > \lambda`, then :math:`u = x - \lambda` is the
    minimizer. Similarly, for :math:`x < -\lambda`, :math:`u = x + \lambda`
    is the minimizer. For :math:`-\lambda \leq x \leq \lambda`, the minimizer
    is at the only point of non-differentiability for :math:`g_1` which is
    :math:`u = 0`. Thus

    .. math::

        \text{prox}_f(x) = \begin{cases}
        x - \lambda & x > \lambda \\
        0 & -\lambda \leq x \leq \lambda \\
        x + \lambda & x < -\lambda 
        \end{cases}

This is nothing but shrinkage operator or soft thresholding operator.

.. definition::

    The **soft thresholding operator** :math:`S: \RR \to \RR` is
    defined as:

    .. math::

        S_{\kappa}(x) = \begin{cases}
        x - \kappa & x > \kappa \\
        0 & |x| \leq \kappa \\
        x + \kappa & x < -\kappa
        \end{cases}.

    An equivalent definition is
    
    .. math::
        S_{\kappa}(x) = (x - \kappa)_+ - (-x-\kappa)_+.



.. proposition::

    The minimizer of 

    .. math::

        f(x) = \lambda |x|  + \frac{1}{2} (x - u)^2

    is :math:`S_{\lambda}(u)`.

This is a straight-forward application of the proximal operator
result above.


.. proposition::

    The minimizer of 

    .. math::

        f(x) = \lambda |x|  + \frac{\rho}{2} (x - u)^2

    is :math:`S_{\lambda/\rho}(u)`.


.. proof::

    .. math::

        f(x) = \begin{cases}
        f_1(x) = \lambda x + \frac{\rho}{2} (x - u)^2 &  x \geq 0 \\
        f_2(x) = -\lambda x + \frac{\rho}{2} (x - u)^2 & x < 0
        \end{cases}.

    :math:`f` is differentiable everywhere except at :math:`x = 0`.

    If a minimizer is obtained at :math:`x > 0`, then

    .. math::

        0 = f'(x) = f_1'(x) = \lambda + \rho (x - u)

    giving us :math:`x = u - \frac{\lambda}{\rho}`. This holds
    true if :math:`u > \frac{\lambda}{\rho}`. Rest of the argument
    is similar.




.. definition::

    **Element-wise soft thresholding** operator 
    :math:`S_{\lambda} : \RR^n \to \RR^n` is defined as


    .. math::

        S_{\lambda}(x_i) = \begin{cases}
        x_i - \lambda & x_i > \lambda \\
        0 & |x_i| \leq \lambda \\
        x_i + \lambda & x_i < -\lambda
        \end{cases}.


.. proposition::

    The minimizer of :math:`f: \RR^n \to \RR` defined as

    .. math::

        f(x) = \lambda \|x\|_1  + \frac{\rho}{2} \|x - u\|_2^2

    is :math:`S_{\lambda/\rho}(u)` (applied element-wise).


.. proof::

    The result follows from the fact that :math:`f(x)` is
    separable as :math:`f(x) = \sum f_i(x_i)` where 

    .. math::
        f_i(x) = \lambda |x_i|  + \frac{\rho}{2} (x_i - u_i)^2.



.. definition::

    **Element-wise soft thresholding** operator over matrices
    :math:`S_{\lambda} : \RR^{m\times n} \to \RR^{m\times n}` is defined as


    .. math::

        S_{\lambda}(x_{ij}) = \begin{cases}
        x_{ij} - \lambda & x_{ij} > \lambda \\
        0 & |x_{ij}| \leq \lambda \\
        x_{ij} + \lambda & x_{ij} < -\lambda
        \end{cases}.


.. proposition::

    The minimizer of :math:`f: \RR^{m \times n} \to \RR` defined as

    .. math::

        f(X) = \lambda \|X\|_{1,1}  + \frac{\rho}{2} \|X - U\|_F^2

    is :math:`S_{\lambda/\rho}(U)` (applied element-wise).

See :ref:`sec:mat:row_column_norms` for formal definition of 
:math:`\| \cdot \|_{1,1}` norm. It is essentially the absolute sum
of all elements of a matrix.

.. proof::

    The result follows from the fact that :math:`f(x)` is
    separable over all elements of :math:`X`.

