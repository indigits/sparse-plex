Printing utilities
=======================================

.. highlight:: matlab


Sparse signals
--------------------


Printing a sparse signal as pairs of
locations and values::

    >> x = [0 0 0  1 0 0 -1 0 0 -2 0 0 -3 0 0 7 0 0 4 0 0 -6];
    >> spx.io.print.sparse_signal(x)
    (4,1) (7,-1) (10,-2) (13,-3) (16,7) (19,4) (22,-6)   N=22, K=7


Printing the non-zero entries in a signal
in descending order of magnitude with
location and value::

    >> spx.io.print.sorted_sparse_signal(x)
    Index:  Value
      16:   7.000000
      22:   -6.000000
      19:   4.000000
      13:   -3.000000
      10:   -2.000000
       4:   1.000000
       7:   -1.000000


Latex
-----------------------------


Printing a vector in a format suitable for Latex::

    >> SPX_Latex.printVector([1, 2, 3, 4])
    \begin{pmatrix}
    1 & 2 & 3 & 4
    \end{pmatrix}


Printing a matrix in a format suitable for Latex::

    >> SPX_Latex.printMatrix(randn(3, 4))
    \begin{bmatrix}
    -0.340285 & 1.13915 & 0.65748 & 0.0187744\\
    -0.925848 & 0.427361 & 0.584246 & -0.425961\\
    0.00532169 & 0.181032 & -1.61645 & -2.03403
    \end{bmatrix}


Printing a vector as a set in Latex::

    >> SPX_Latex.printSet([1, 2, 3, 4])
    \{ 1 , 2 , 3 , 4 \} 


SciRust
----------------

SciRust is a related scientific computing
library developed by us. Some helper
functions have been written to 
convert MATLAB data into SciRust compatible
Rust source code.

Printing a matrix for consumption in SciRust 
source code::

    >> SPX_SciRust.printMatrix(magic(3))
    matrix_rw_f64(3, 3, [
            8.0, 1.0, 6.0,
            3.0, 5.0, 7.0,
            4.0, 9.0, 2.0
            ]);
