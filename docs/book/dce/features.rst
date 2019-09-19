Features
=======================

.. highlight:: matlab



Polynomial Features
--------------------------


Computing polynomial features for 1 dimensional data::

    >> x = [1 2 3 4]'

    x =

         1
         2
         3
         4

    >> spx.ml.features.polynomial(x, 3)

    ans =

         1     1     1     1
         1     2     4     8
         1     3     9    27
         1     4    16    64


Each row is 1 data sample. The data is one dimensional. 
We are computing features for a degree 3 polynomial.


Computing polynomial features for 2 dimensional data::

    >> X = [1 2; 2 3; 2 4;]

    X =

         1     2
         2     3
         2     4

    >> spx.ml.features.polynomial(X, 3)

    ans =

         1     1     2     1     2     4     1     2     4     8
         1     2     3     4     6     9     8    12    18    27
         1     2     4     4     8    16     8    16    32    64

