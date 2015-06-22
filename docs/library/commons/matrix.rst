Working with matrices
========================

.. highlight:: matlab


Simple checks on matrices
---------------------------------------------------

Let us create a simple matrix::

    A = magic(3);

Checking whether the matrix is a square matrix::

    SPX_Mat.is_square(A)

Checking if it is symmetric::

    SPX_Mat.is_symmetric(A)

Checking if it is a Hermitian matrix::

    SPX_Mat.is_hermitian(A)


Checking if it is a positive definite matrix::

    SPX_Mat.is_positive_definite(A)


Matrix utilities
---------------------------------------------------

``SPX_Mat.off_diagonal_elements`` returns
the off-diagonal elements of a given matrix
in a column vector arranged in column major order.

::

    A = magic(3);
    SPX_Mat.off_diagonal_elements(A)'
    ans =
        3     4     1     9     6     7    



``SPX_Mat.off_diagonal_matrix`` zeros out
the diagonal entries of a matrix and
returns the modified matrix::

    SPX_Mat.off_diagonal_matrix(A)
    ans =

         0     1     6
         3     0     7
         4     9     0

``SPX_Mat.off_diag_upper_tri_matrix`` returns 
the off diagonal part of the upper triangular part
of a given matrix and zeros out the remaining entries::

    SPX_Mat.off_diag_upper_tri_matrix(A)

    ans =

         0     1     6
         0     0     7
         0     0     0

``SPX_Mat.off_diag_upper_tri_elements`` returns the
elements in the off diagonal part of the upper 
triangular part of a matrix arranged in column major 
order::

    SPX_Mat.off_diag_upper_tri_elements(A)'

    ans =

         1     6     7


``SPX_Mat.nonzero_density`` returns the ratio
of total number of non-zero elements in a matrix
with the size of the matrix::

    SPX_Mat.nonzero_density(A)
    ans = 1


diagonally dominant matrices
-----------------------------------------

Checking whether a matrix is diagonally dominant::

    SPX_Mat.is_diagonally_dominant(A)


Making a matrix diagonally dominant::

    A = SPX_Mat.make_diagonally_dominant(A)

Both these functions have an extra parameter 
named ``strict``. When set to true, strict
diagonal dominance is considered / enforced. 

