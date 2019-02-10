ADMM for Computing Subspace Preserving Representations
=============================================================

.. highlight:: matlab


.. contents::
    :local:


Linear Subspaces
------------------------


We solve the program

.. math::
    \min \| C \|_{1,1} \quad \text{ s.t. }  Y = Y C, \; \Diag(C) = 0. 



Affine Subspaces
---------------------------

We solve the program

.. math::

    \min \| C \|_{1,1} \quad \text{ s.t. }  Y = Y C, \; 
    \OneVec^T C = \OneVec^T, \; \Diag(C) = 0. 


Linear Subspaces with Noise
------------------------------

We solve the program

.. math::

    \min \| C \|_{1,1} + \frac{\lambda}{2} \| Z \|_F^2 
    \quad \text{ s.t. }  Y = Y C + Z, \; 
    \Diag(C) = 0. 


Eliminate Z from the program

.. math::

    \min \| C \|_{1,1} + \frac{\lambda}{2} \| Y - YC \|_F^2 
    \quad \text{ s.t. }  \Diag(C) = 0. 

Introduce an auxiliary matrix :math:`A` and consider the program

.. math::

    \min \| C \|_{1,1} + \frac{\lambda}{2} \| Y - YA \|_F^2 
    \quad \text{ s.t. }  A = C - \Diag(C). 

The two programs have same solution.

Adding the penalty terms for equality constraints

.. math::

    \min \| C \|_{1,1} + \frac{\lambda}{2} \| Y - YA \|_F^2 
    + \frac{\rho}{2} \| A - (C - \Diag(C)) \|_F^2 
    \quad \text{ s.t. }  A = C - \Diag(C). 

Adding the penalty term doesn't change the solution. The 
penalty term vanishes for any feasible solution. The
objective function is now strictly convex. 


Constructing the augmented Lagrangian

.. math::

    \LLL(C, A, \Delta) =  \min \| C \|_{1,1} + \frac{\lambda}{2} \| Y - YA \|_F^2 
    + \frac{\rho}{2} \| A - (C - \Diag(C)) \|_F^2 
    + \Trace(\Delta^T (A - (C - \Diag(C)))).


The ADMM algorithm would consist of

- Update :math:`A` based on :math:`(C^k, \Delta^k)`
- Update :math:`C` based on :math:`(A^{k+1}, \Delta^k)`
- Update :math:`\Delta` based on :math:`(A^{k+1}, C^{k+1})`

.. rubric:: :math:`A`-update

:math:`\LLL(C, A, \Delta)` is a quadratic in :math:`A`.
Differentiating w.r.t. :math:`A` gives us:

.. math::

    \lambda Y^T (YA - Y) + \rho (A - (C - \Diag(C))) + \Delta = 0.

Rearranging the terms we get:

.. math::

    (\lambda Y^T Y + \rho I )A = 
    \lambda Y^T Y + \rho (C - \Diag(C)) - \Delta.

Note that, by construction, we will ensure that :math:`\Diag(C) = 0`
for each iteration. Thus, :math:`A` is updated by 
solving the equation:

.. math::

    (\lambda Y^T Y + \rho I )A^{k+1} = 
    \lambda Y^T Y + \rho C^k - \Delta^k.


.. rubric:: :math:`C` update

Let's rewrite the augmented Lagrangian by removing the :math:`\Diag(C)`
terms as:

.. math::

    \LLL(C, A, \Delta) =  \min \| C \|_{1,1} + \frac{\lambda}{2} \| Y - YA \|_F^2 
    + \frac{\rho}{2} \| A - C \|_F^2 
    + \Trace(\Delta^T (A - C )).

Remove the terms which don't depend on :math:`C`

.. math::

    \min \| C \|_{1,1} + \frac{\rho}{2} \| C - A\|_F^2 - \Trace(\Delta^T C ).

A closed-form solution for the minimizer of this expression is

.. math::

    J = S_{\frac{1}{\rho}} (A^{k+1} + \Delta^k / \rho)

where :math:`S` is the element wise soft thresholding or shrinkage
operator.

We obtain :math:`C` from :math:`J` by:

.. math::

    C^{k+1} = J - \Diag(J).

Note that this construction ensures that :math:`\Diag(C)` is always 0.

.. rubric:: :math:`\Delta` update

We perform the gradient ascent update of :math:`\Delta` as

.. math::

    \Delta^{k+1} = \Delta^k + \rho (A^{k+1} - C^{k+1}).



Linear Subspaces with Noise and Outliers
-------------------------------------------------

We solve the program

.. math::

    \min \| C \|_{1,1}  + \lambda_e \| E \|_{1,1} + \frac{\lambda_z}{2} \| Z \|_F^2 
    \quad \text{ s.t. }  Y = Y C + E + Z, \; 
    \Diag(C) = 0. 


Affine Subspaces with Noise
-------------------------------------

We solve the program

.. math::

    \min \| C \|_{1,1} + \frac{\lambda}{2} \| Z \|_F^2 
    \quad \text{ s.t. }  Y = Y C + Z, \; 
    \OneVec^T C = \OneVec^T, \; \Diag(C) = 0. 


Affine Subspaces with Noise and Outliers
---------------------------------------------


We solve the program

.. math::

    \min \| C \|_{1,1}  + \lambda_e \| E \|_{1,1} + \frac{\lambda_z}{2} \| Z \|_F^2 
    \quad \text{ s.t. }  Y = Y C + E + Z, \; 
    \OneVec^T C = \OneVec^T, \; \Diag(C) = 0. 



