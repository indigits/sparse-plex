Matrix Calculus
==========================



Trace
---------------

In this section, we collect several results related
to derivatives of traces of functions of a matrix 
:math:`X`.

.. formula::

    .. math::

        \frac{\partial \Trace(A X B)}{\partial X} = A^T B^T

Here is a size argument which is helpful in 
remembering the result.
Trace can be computed only of square matrices. 
Assume that :math:`X` is of size :math:`m \times n`
and let :math:`A` be of size :math:`p \times m`.
Then, since :math:`A X B` must be square, hence
:math:`B` must be of size :math:`n \times p`.
Then the number of rows of :math:`A` and columns
of :math:`B` match. Hence, :math:`BA` and :math:`A^T B^T` 
are valid multiplications with sizes :math:`n \times m`
and :math:`m \times n`. 
The size of :math:`X` and 
:math:`\frac{\partial \Trace(A X B)}{\partial X}`
are both :math:`m \times n` which forces the choice
of result.

.. formula::

    .. math::

        \frac{\partial \Trace(A X^T B)}{\partial X} = B A


Following the size argument earlier, :math:`BA`
has the size identical to :math:`X`.

Some of the implications are listed here.

.. formula::

    .. math::

        \frac{\partial \Trace(A X)}{\partial X} = A^T

    .. math::

        \frac{\partial \Trace(X B)}{\partial X} = B^T

    .. math::

        \frac{\partial \Trace(A X^T)}{\partial X} = A

    .. math::

        \frac{\partial \Trace(X^T B)}{\partial X} = B

Note that in each case, dimensionally, we just have
to achieve that the derivative has same size as
:math:`X`.

.. formula::

    .. math::

        \begin{aligned}
        \frac{\partial \Trace(AXBXC)}{\partial X}   &= A^T (BXC)^T + (AXB)^T C^T\\
        &=  A^T C^T X^T B^T + B^T X^T A^T C^T 
        \end{aligned}

.. proof::

    We differentiate separately for each appearance of
    :math:`X` treating rest of the terms as constant and
    then add up the derivatives.

    If :math:`A` is size :math:`p \times m`,
    :math:`X` is size :math:`m \times n`,
    then :math:`B` must be size :math:`n \times m`
    and :math:`C` must be size :math:`m \times p`
    to make :math:`AXBXC` a square matrix of size :math:`p \times p`.


Frobenius Norm
-----------------------------------------------

The Frobenius norm squared is easily expressed
in the form of trace:

.. math::

    \| X \|_F^2 = \Trace (X X^T).


.. formula::

    .. math::

        \frac{\partial \| X \|_F^2}{\partial X} 
        = 2X.


.. proof::

    .. math::

        \| X \|_F^2 = \Trace(X X^T)  
        = \Trace(I X X^T) = \Trace (X X^T I).

    We differentiate separately for each appearance of
    :math:`X` treating rest of the terms as constant and
    then add up the derivatives.

    .. formula::

        .. math::

            \frac{\partial \| X - A \|_F^2}{\partial X} 
            = 2(X-A).


    .. math::

        \Trace ((X-A)(X-A)^T) = \Trace(XX^T - AX^T - XA^T + AA^T).

    We get the result by differentiating each term in the sum separately. 


.. formula::

    .. math::

        \frac{\partial \| A X \|_F^2}{\partial X} 
        = 2(A^T A) X.

.. proof::

    We expand the Frobenius norm terms:

    .. math::

        \| A X \|_F^2 = \Trace ((A X) (A X)^T) 
        = \Trace (A X X^T A^T).

    Differentiating for each appearance of :math:`X`
    separately, we will get

    .. math::

         A^T (X^T A^T)^T +  A^T (A X) 
         = 2 (A^T A) X

    Dimensionally, if :math:`X` is of size :math:`m \times n`,
    then :math:`A` is of size :math:`p \times m` and 
    :math:`A^T A` is of size :math:`m \times m`. Thus
    size of :math:`X` and :math:`A^T A X` are same 
    as expected.


.. formula::

    .. math::

        \frac{\partial \| X B \|_F^2}{\partial X} 
        = 2 X B B^T.

.. proof::

    We expand the Frobenius norm terms:

    .. math::

        \| X B \|_F^2 = \Trace ((X B) (X B)^T) 
        = \Trace (X B B^T X^T).

    Differentiating for each appearance of :math:`X`
    separately, we will get

    .. math::

        (B B^T X^T)^T + (X B B^T) = 2 X B B^T.

    Dimensionally, :math:`B` is of size :math:`n \times p`
    and :math:`BB^T` is of size :math:`n \times n` which
    post-multiplies with :math:`X` without changing size.


.. formula::

    .. math::

        \frac{\partial \| A X  - B \|_F^2}{\partial X} 
        = 2(A^T A) X - 2 A^T B = 2 A^T (AX -B).


.. proof::

    We expand the Frobenius norm terms:

    .. math::

        \| A X - B\|_F^2 = \Trace ((A X - B) (A X - B)^T) 
        = \Trace (A X X^T A^T  - B X^T A^T - A X B^T + B B^T ).

    Differentiating each term separately, we get:

    .. math::

        2(A^T A) X - A^T B - A^T B = 2A^T(AX - B).

.. formula::

    .. math::

        \frac{\partial \| X B  - C \|_F^2}{\partial X} 
        = 2X (B B^T) - 2 C B^T = 2 (X B - C) B^T.


.. proof::

    We expand the Frobenius norm terms:

    .. math::

        \| X B - C\|_F^2 = \Trace ((X B - C) (X B - C)^T) 
        = \Trace(X B B^T X^T - C B^T X^T - X B C^T + CC^T).

    Differentiating each term separately, we get:

    .. math::

        2 X (BB^T) - C B^T - (B C^T)^T = 2( X B - C) B^T.

