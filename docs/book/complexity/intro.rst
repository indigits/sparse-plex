.. _ch:complexity:

Introduction
=======================

This chapters provides a framework for 
analysis of computational complexity
of sparse recovery algorithms. 
See :cite:`golub2012matrix` for a detailed study of matrix computations.

The table below summarizes the flop counts 
for various basic operations. A detailed derivation of these
flop counts is presented in :ref:`sec:complexity:basic_operations`.


.. _tbl:complexity:basic_operations:

.. list-table:: Summary of flop counts for various basic operations
    :header-rows: 1

    * - Operation 
      - Description 
      - Parameters 
      - Flop Counts 
    * - :math:`y = \text{abs}(x)`  
      - Absolute values 
      - :math:`x \in \RR^n` 
      - :math:`n`
    * - :math:`\langle x, y \rangle` 
      - Inner product 
      - :math:`x, y \in \RR^n` 
      - :math:`2n` 
    * - :math:`[v, i] = \text{max}(\text{abs}(x))`  
      - Find maximum value by magnitude 
      - :math:`x \in \RR^n` 
      - :math:`2n`
    * - :math:`y = A x` 
      - Matrix vector multiplication 
      - :math:`A \in \RR^{m \times n}, x \in \RR^n` 
      - :math:`2mn` 
    * - :math:`C = AB` 
      - Matrix multiplication 
      - :math:`A \in \RR^{m \times n}, B \in \RR^{n \times p}` 
      - :math:`2mnp`
    * - :math:`y = A x` 
      - :math:`A` is diagonal 
      - :math:`A \in \RR^{n\times n}, x \in \RR^n` 
      - :math:`n` 
    * - :math:`y = A x` 
      - :math:`A` is lower triangular 
      - :math:`A \in \RR^{n\times n}, x \in \RR^n` 
      - :math:`n(n+1)` 
    * - :math:`(I + u v^T)x` 
      -  
      - :math:`x, u, v \in \RR^n` 
      - :math:`4n` 
    * - :math:`G = A^TA` 
      - Gram matrix (symmetric) 
      - :math:`A \in \RR^{m \times n}` 
      - :math:`mn^2` 
    * - :math:`F = AA^T` 
      - Frame operator (symmetric) 
      - :math:`A \in \RR^{m \times n}` 
      - :math:`nm^2` 
    * - :math:`\| x \|_2^2` 
      - Squared :math:`\ell_2` norm 
      - :math:`x \in \RR^n` 
      - :math:`2n - 1` 
    * - :math:`\| x \|_2` 
      - :math:`\ell_2` norm 
      - :math:`x \in \RR^n` 
      - :math:`2n` 
    * - :math:`x(:) = c`  
      - Set to a constant value
      - :math:`x \in \RR^n` 
      - :math:`n`
    * - Swap rows in :math:`A`  
      - elementary row operation
      - :math:`A \in \RR^{m \times n}` 
      - :math:`3n`
    * - :math:`A(i, :) = \alpha A(i, :)`  
      - Scale a row 
      - :math:`A \in \RR^{m \times n}` 
      - :math:`2n`
    * - Solve :math:`L x = b`  
      - Lower triangular system 
      - :math:`L \in \RR^{n \times n}` 
      - :math:`n^2`
    * - Solve :math:`U x = b`  
      - Upper triangular system 
      - :math:`U \in \RR^{n \times n}` 
      - :math:`n^2`
    * - Solve :math:`Ax =b`  
      - Gaussian elimination, :math:`A` full rank 
      - :math:`A\in \RR^{n \times n}` 
      - :math:`\frac{2\, n^3}{3} + \frac{n^2}{2} - \frac{7\, n}{6}`
    * - :math:`A = QR`  
      - QR factorization 
      - :math:`A \in \RR^{m \times n}` 
      - :math:`2mn^2`
    * - Solve :math:`\| A x  - b \|_2^2`  
      - Least squares through QR 
      - :math:`A \in \RR^{m \times n}` 
      - :math:`2mn^2 + 2mn + n^2`
    * - :math:`A^TA x = A^T b`  
      - Least squares through Cholesky :math:`A^T A = L L^T` 
      - :math:`A \in \RR^{m \times n}` 
      - :math:`mn^2 + \frac{1}{3} n^3`


.. disqus::
