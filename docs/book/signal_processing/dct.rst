Discrete Cosine Transform
=================================

The discussion in this article is based on :cite:`strang1999discrete`.

There are four types of DCT transforms DCT-1, DCT-2, DCT-3 and DCT-4.

Consider the second difference equation: 

.. math::
    y(n) = - x (n -1) + 2 x(n) - x(n + 1)


For finite signals :math:`x \in \RR^N`, the equation 
can be implemented by a linear transformation:

.. math:: 
    y = A x

where :math:`A` is a circulant matrix:

.. math::

    A = \begin{bmatrix}
    2  & -1 &     &    &    &  -1\\
    -1 & 2  & -1  &    &    &    \\
       & -1 & 2  & -1  &    &    \\
       &    &    & \ddots  &    &   \\
       &    &    & -1  & 2  &  -1\\
    -1 &    &    &     & -1 &   2
    \end{bmatrix}

The unspecified values are 0. We can write the individual 
linear equations as:

.. math::

    \begin{aligned}
    y_1 &= - x_{N}   + 2 x_1 - x_2 \\
    y_j &= - x_{j-1} + 2 x_j - x_{j +1} \quad \forall 1 < j < N \\
    y_N &= - x_{N_1} + 2 x_N - x_1 
    \end{aligned}

The first and last equations are boundary conditions while the
middle one represents the ordinary second difference equation.

The rows 1 and N of :math:`A` are the boundary rows
while all other rows are interior rows.

The interior rows correspond to the computation
:math:`- x_{j-1} + 2 x_j - x_{j +1}` which is the
discretization of the second order derivative :math:`-x''`.
The negative sign on the derivative makes the matrix :math:`A`
positive semi definite. This ensures that no eigen values of
:math:`A` are negative.

In the first and last rows, we need the values of 
:math:`x_0` and :math:`x_{N + 1}`. In the periodic 
extension, we assume that :math:`x_0 = x_N` and :math:`x_{N + 1} = x_1`.
This gives the :math:`-1` entries in the corners of :math:`A`
as shown above.

With :math:`\omega = \exp(2\pi i / N)`, it turns out that

.. math::

    v_k = (1, \omega^k, \omega^{2k}, \dots, \omega^{(N-1)k})

are eigen vectors for :math:`A` for :math:`0 \leq k \leq N -1`.
The corresponding eigen values are :math:`(2 - 2 \cos(2\pi k / N)`.

The eigen vectors are nothing but the basis vectors for DFT basis.
Note that the eigen values satisfy a relationship
:math:`\lambda_k = \lambda_{N -k}`. So the linear combinations
of the eigen vectors :math:`v_k` and :math:`v_{N -k}` 
are also eigen vectors.

It turns out that the real and imaginary parts of the
vector :math:`v_k` are also eigen vectors of :math:`A`.
They can be easily constructed as linear combinations 
of :math:`v_k` and :math:`v_{N -k}`.

We define:

.. math::

    c_k = \Re(v_k) = \left ( 1, \cos \frac{2\pi k}{ N},
    \cos \frac{4\pi k}{ N}, \dots, \cos \frac{2 (N -1)\pi k}{ N}
     \right ).

.. math::

    s_k = \Im(v_k) = \left ( 0, \sin \frac{2\pi k}{ N},
    \sin \frac{4\pi k}{ N}, \dots, \sin \frac{2 (N -1)\pi k}{ N}
     \right )

The exception to this rule is :math:`\lambda_0` for which
:math:`c_0 = (1, 1, \dots, 1)` and :math:`s_0 = (0, 0, \dots, 0)`
where :math:`s_0` is not an eigen vector while :math:`c_0` is.

For even :math:`N`, there is another exception at :math:`\lambda_{N/2}`
with :math:`c_{N/2} = (1, -1, \dots, 1, -1)` and 
:math:`s_0 = (0, 0, \dots, 0)`.

These two eigen vectors have length :math:`\sqrt{N`
while other eigen vectors :math:`c_k` and :math:`s_k`
have length :math:`\sqrt{N/ 2}`.


TBD
