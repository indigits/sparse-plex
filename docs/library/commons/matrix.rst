.. _sec:library:commons:matrix:

Working with matrices
========================

.. highlight:: matlab


Simple checks on matrices
---------------------------------------------------

Let us create a simple matrix::

    A = magic(3);

Checking whether the matrix is a square matrix::

    spx.matrix.is_square(A)

Checking if it is symmetric::

    spx.matrix.is_symmetric(A)

Checking if it is a Hermitian matrix::

    spx.matrix.is_hermitian(A)


Checking if it is a positive definite matrix::

    spx.matrix.is_positive_definite(A)


Matrix utilities
---------------------------------------------------

``spx.matrix.off_diagonal_elements`` returns
the off-diagonal elements of a given matrix
in a column vector arranged in column major order.

::

    A = magic(3);
    spx.matrix.off_diagonal_elements(A)'
    ans =
        3     4     1     9     6     7    



``spx.matrix.off_diagonal_matrix`` zeros out
the diagonal entries of a matrix and
returns the modified matrix::

    spx.matrix.off_diagonal_matrix(A)
    ans =

         0     1     6
         3     0     7
         4     9     0

``spx.matrix.off_diag_upper_tri_matrix`` returns 
the off diagonal part of the upper triangular part
of a given matrix and zeros out the remaining entries::

    spx.matrix.off_diag_upper_tri_matrix(A)

    ans =

         0     1     6
         0     0     7
         0     0     0

``spx.matrix.off_diag_upper_tri_elements`` returns the
elements in the off diagonal part of the upper 
triangular part of a matrix arranged in column major 
order::

    spx.matrix.off_diag_upper_tri_elements(A)'

    ans =

         1     6     7


``spx.matrix.nonzero_density`` returns the ratio
of total number of non-zero elements in a matrix
with the size of the matrix::

    spx.matrix.nonzero_density(A)
    ans = 1


diagonally dominant matrices
-----------------------------------------

Checking whether a matrix is diagonally dominant::

    spx.matrix.is_diagonally_dominant(A)


Making a matrix diagonally dominant::

    A = spx.matrix.make_diagonally_dominant(A)

Both these functions have an extra parameter 
named ``strict``. When set to true, strict
diagonal dominance is considered / enforced. 

