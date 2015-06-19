Printing utilities
=======================================


Latex
-----------------------------


Printing a vector in a format suitable for Latex::

    >> SPX_Latex.printVector([1, 2, 3, 4])
    \begin{pmatrix}
    1 & 2 & 3 & 4
    \end{pmatrix}


Printing a matrix in a format suitable for Latex::

    SPX_Latex.printMatrix(randn(3, 4))
    \begin{bmatrix}
    -0.340285 & 1.13915 & 0.65748 & 0.0187744\\
    -0.925848 & 0.427361 & 0.584246 & -0.425961\\
    0.00532169 & 0.181032 & -1.61645 & -2.03403
    \end{bmatrix}

