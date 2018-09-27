Sparse solutions for under-determined linear systems
==============================================================


The discussion in this section is largely based on chapter 1 of 
:cite:`elad2010sparse`.

Consider a matrix :math:`\Phi \in \CC^{M \times N}` with :math:`M < N`. 

Define an under-determined system of linear equations:

.. math::

  \Phi x = y

where :math:`y \in \CC^M` is known and :math:`x \in \CC^N` is unknown. 

This system has :math:`N` unknowns and
:math:`M` linear equations. 
There are more unknowns than equations.

Let the columns of :math:`\Phi` be given by :math:`\phi_1, \phi_2, \dots, \phi_N`.

Column space of :math:`\Phi` (vector space spanned by all columns of :math:`\Phi`)  is denoted by :math:`\ColSpace(\Phi)`
i.e.

.. math::

  \ColSpace(\Phi) = \sum_{i=1}^{N} c_i \phi_i, \quad c_i \in \CC.


We know that :math:`\ColSpace(\Phi) \subset \CC^M`. 

Clearly :math:`\Phi x \in \ColSpace(\Phi)` for every :math:`x \in \CC^N`.  Thus if :math:`y \notin \ColSpace(\Phi)` then we have no solution. But, if :math:`y \in \ColSpace(\Phi)` then we have infinite number of solutions.

Let :math:`\NullSpace(\Phi)` represent the null space of :math:`\Phi` given by 

.. math::

  \NullSpace(\Phi) = \{ x \in \CC^N : \Phi x = 0\}.


Let :math:`\widehat{x}` be a solution of :math:`y = \Phi x`. And let :math:`z \in \NullSpace(\Phi)`. Then 

.. math::

  \Phi (\widehat{x} + z) = \Phi \widehat{x} + \Phi z = y + 0  = y.

Thus the set :math:`\widehat{x} + \NullSpace(\Phi)` forms the complete set of infinite solutions to the
problem :math:`y = \Phi x` where

.. math::

  \widehat{x} + \NullSpace(\Phi) = \{\widehat{x} + z \quad \Forall z \in \NullSpace(\Phi)\}.

.. example:: An under-determined system

  As a running example in this section, we will consider a simple under-determined system
  in :math:`\RR^2`. 
  The system is specified by
  
  .. math::

    \Phi  = 
    \begin{bmatrix}
    3 & 4
    \end{bmatrix}

  and
  
  .. math::

    x = \begin{bmatrix}
    x_1 \\
    x_2
    \end{bmatrix}

  with
  
  .. math::

    \Phi x = y = 12.

  where :math:`x` is unknown and :math:`y` is known.
  Alternatively 
  
  .. math::

    \begin{bmatrix}
    3 & 4
    \end{bmatrix}
    \begin{bmatrix}
    x_1 \\
    x_2
    \end{bmatrix}
    = 12

  or more simply
  
  .. math::

    3 x_1 + 4 x_2 = 12.

  The solution space of this system is a line in :math:`\RR^2` which is shown in  the figure below.

  .. image:: images/underdetermined_system.png


  Specification of the under-determined system as above, doesn't give us any reason to prefer one
  particular point on the line as the preferred solution.

  Two specific solutions are of interest:

  * :math:`(x_1, x_2) = (4,0)` lies on the :math:`x_1` axis.
  * :math:`(x_1, x_2) = (0,3)` lies on the :math:`x_2` axis.

  In both of these solutions, one component is 0, thus leading these solutions to be sparse.

  It is easy to visualize sparsity in this simplified 2-dimensional setup but situation becomes
  more difficult when we are looking at high dimensional signal spaces. We need well defined criteria
  to promote sparse solutions.


Regularization
------------------------


Are all these solutions equivalent or can we say  that one solution is better than the other in some sense? 
In order to suggest that some solution is better than other solutions, we need to define a criteria
for comparing two solutions.

In optimization theory, this idea is known as **regularization**. 

.. index:: Regularization

We define a cost function :math:`J(x) : \CC^N \to \RR` which defines the **desirability** of a given solution :math:`x` out
of infinitely possible solutions. The higher the cost, lower is the desirability of
the solution.

.. index:: Desirability

Thus the goal of the optimization problem is to find a desired :math:`x` with minimum possible cost.

In optimization literature, the cost function is one type of **objective function**.
While the objective of an optimization problem might be either minimized or maximized, cost
is always minimized.

We can write this optimization problem as
  
.. math::

  \begin{aligned}
    & \underset{x}{\text{minimize}} 
    & &  J(x) \\
    & \text{subject to}
    & &  y = \Phi x.
  \end{aligned}



If :math:`J(x)` is convex, then its possible to find a global minimum cost solution over the solution set.

If :math:`J(x)` is not convex, then it may not be possible to find a global minimum, we may have to
settle with a local minimum. 

A variety of such cost function based criteria can be considered. 

:math:`l_2` Regularization
--------------------------------

One of the most common criteria is to choose a solution with the smallest :math:`l_2` norm.

The problem can then be reformulated as an optimization problem 
  
.. math::

  \begin{aligned}
    & \underset{x}{\text{minimize}} 
    & &  \| x \|_2 \\
    & \text{subject to}
    & &  y = \Phi x.
  \end{aligned}


In fact minimizing :math:`\| x \|_2` is same as minimizing its square :math:`\| x \|_2^2 = x^H x`.

So an equivalent formulation is 

  
.. math::

  \begin{aligned}
    & \underset{x}{\text{minimize}} 
    & &  x^H x \\
    & \text{subject to}
    & &  y = \Phi x.
  \end{aligned}


.. example:: Minimum :math:`l_2` norm solution for an under-determined system

  We continue with our running example.

  We can write :math:`x_2` as
  
  .. math::

  x_2 = 3 - \frac{3}{4} x_1.


  With this definition the squared :math:`l_2` norm of :math:`x` becomes
  
  .. math::

    \| x \|_2^2 = x_1^2 + x_2^2 &=  x_1^2 + \left ( 
    3 - \frac{3}{4} x_1 \right )^2\\
    & = \frac{25}{16} x_1^2 - \frac{9}{2} x_1 + 9.

  Minimizing  :math:`\| x \|_2^2` over all :math:`x` is same as minimizing over all :math:`x_1`.

  Since :math:`\| x \|_2^2` is a quadratic function of :math:`x_1`, we can simply differentiate
  it and equate to 0 giving us
  
  .. math::

    \frac{25}{8} x_1 -  \frac{9}{2} = 0  \implies x_1  = \frac{36}{25} = 1.44.

  This gives us
  
  .. math::

    x_2 = \frac{48}{25} = 1.92.


  Thus the optimal :math:`l_2` norm solution is obtained at :math:`(x_1, x_2) = (1.44, 1.92)`.

  We note that the minimum :math:`l_2` norm at this solution is
  
  .. math::

    \| x \|_2 = \frac{12}{5} = 2.4.


  It is instructive to note that the :math:`l_2` norm cost function prefers a non-sparse solution to the 
  optimization problem.

  We can view this solution graphically by drawing :math:`l_2` norm balls of different radii 
  in figure below. 
  The ball which just touches the solution space line (i.e. the line is tangent to the ball)
  gives us the optimal solution. 

  .. image:: images/underdetermined_system_l2_balls.png


  All other norm balls either don't touch the solution line at all, or they cross it at
  exactly two points.



A formal solution to :math:`l_2` norm minimization problem can be easily obtained using
Lagrange multipliers.

We define the Lagrangian
  
.. math::

  \mathcal{L}(x) = \|x\|_2^2 + \lambda^H (\Phi x  - y)

with :math:`\lambda \in \CC^M` being the Lagrange multipliers for the (equality) constraint set.

Differentiating :math:`\mathcal{L}(x)` w.r.t. :math:`x` we get
  
.. math::

  \frac{\partial \mathcal{L}(x)} {\partial x} = 2 x + \Phi^H \lambda.


By equating the derivative to :math:`0` we obtain the optimal value of :math:`x` as
  
.. math::

  x^* = - \frac{1}{2} \Phi^H \lambda.
  \label{eq:ssm:underdetermined_l2_optimal_value_expression_1}


Plugging this solution back into the constraint :math:`\Phi x= y` gives us
  
.. math::

  \Phi x^* = - \frac{1}{2} (\Phi \Phi^H) \lambda= y\implies \lambda = -2(\Phi \Phi^H)^{-1} y.


In above we are implicitly assuming that :math:`\Phi` is a full rank matrix thus, :math:`\Phi \Phi^H` is invertible
and positive definite.

Putting :math:`\lambda` back in above we obtain
the well known closed form least squares solution using pseudo-inverse solution
  
.. math::

  x^* = \Phi^H (\Phi \Phi^H)^{-1} y = \Phi^{\dag} y.


We would like to mention that there are several iterative approaches to solve the :math:`l_2` norm minimization
problem (like gradient descent and conjugate descent).  For large systems, they are more effective
than computing the pseudo-inverse. 

The beauty of :math:`l_2` norm minimization lies in its simplicity and availability of closed form
analytical solutions. This has led to its prevalence in various fields of science and engineering.
But :math:`l_2` norm is by no means the only suitable cost function. Rather the simplicity of :math:`l_2` norm
often drives engineers away from trying other possible cost functions. In the sequel, we will
look at various other possible cost functions.

Convexity
------------------
Convex optimization
problems have a unique feature that it is possible to find the global optimal solution if
such a solution exists. 

The solution space  :math:`\Omega = \{x : \Phi x = y\}` is convex.
Thus the feasible set of solutions for the optimization problem
is also convex. All it remains is to make sure that we choose a cost function
:math:`J(x)` which happens to be convex. This will ensure that a global minimum can be found through
convex optimization techniques. Moreover, if :math:`J(x)` is strictly convex, then it is guaranteed
that the global minimum solution is *unique*. Thus even though, we may not have
a nice looking closed form expression for the solution of a strictly convex cost function minimization problem,
the guarantee of the existence and uniqueness of solution as well as well developed algorithms
for solving the problem make it very appealing to choose cost functions which are convex.

We remind that all :math:`l_p` norms with :math:`p \geq 1` are convex functions.
In particular :math:`l_{\infty}` and :math:`l_1` norms are very interesting and popular where
  
.. math::

  l_{\infty}(x) = \max(x_i), \, 1 \leq i \leq N

and
  
.. math::

  l_1(x) = \sum_{i=1}^{N} |x_i|.


In the following section we will attempt to find a unique solution to our 
optimization problem using :math:`l_1` norm.

:math:`l_1` Regularization
-----------------------------------

In this section we will restrict our attention to the
Euclidean space case where :math:`x \in \RR^N`,
:math:`\Phi \in \RR^{M \times N}` and :math:`y \in \RR^M`.

We choose our cost function :math:`J(x) = l_1(x)`.

The cost minimization problem can be reformulated as
  
.. math::

  \begin{aligned}
    & \underset{x}{\text{minimize}} 
    & &  \| x \|_1 \\
    & \text{subject to}
    & &  \Phi x = y.
  \end{aligned}


.. example:: Minimum :math:`l_1` norm solution for an under-determined system

  We continue with our running example.


  Again we can view this solution graphically by drawing :math:`l_1` norm balls of different radii 
  in  the figure below. 
  The ball which just touches the solution space line
  gives us the optimal solution. 

  .. image:: images/underdetermined_system_l1_balls.png

  As we can see from the figure the minimum :math:`l_1` norm solution is given by :math:`(x_1,x_2)  = (0,3)`.

  It is interesting to note that :math:`l_1` norm solution promotes sparser solutions while
  :math:`l_2` norm solution promotes solutions in which signal energy is distributed amongst
  all of its components.



It's time to have a closer look at our cost function :math:`J(x) = \|x \|_1`. This function
is convex yet not strictly convex. 

.. example:: :math:`\| x\|_1` is not strictly convex

  Consider again :math:`x \in \RR^2`. For :math:`x \in \RR_+^2` (the first quadrant), 
  
  .. math::

    \|x \|_1 = x_1 + x_2.

  Hence for any :math:`c_1, c_2 \geq 0` and :math:`x, y \in \RR_+^2`:
  
  .. math::

    \|(c_1 x + c_2 y)\|_1 =  (c_1 x + c_2 y)_1 + (c_1 x + c_2 y)_2 = c_1 \| x\|_1 + c_2 \| y \|_1.

  Thus, :math:`l_1`-norm is not strictly convex.
  Consequently, a unique solution may not exist for :math:`l_1` norm minimization problem.

  As an example consider the under-determined system
  
  .. math::

    3 x_1 + 3 x_2 = 12.

  We can easily visualize that the solution line will pass through points :math:`(0,4)` and
  :math:`(4,0)`. Moreover, it will be clearly parallel with :math:`l_1`-norm ball of radius :math:`4` in
  the first quadrant. See again the figure above.
  This gives us infinitely possible solutions to the minimization problem.

  We can still observe that 

  * These solutions are gathered in a small line segment that
    is bounded (a bounded convex set) and
  * There exist two solutions :math:`(4,0)` and :math:`(0,4)` amongst these
    solutions which have only 1 non-zero component.

For the :math:`l_1` norm minimization problem since :math:`J(x)` is not strictly convex,
hence a unique solution may not be guaranteed. In specific cases, there may be
infinitely many solutions. Yet what we can claim is
\begin{itemize}
\item these solutions are gathered in a set that is bounded and convex, and
\item among these solutions, there exists at least one solution with at most
:math:`M` non-zeros (as the number of constraints in :math:`\Phi x = y`).
\end{itemize}
\todo{Provide reference to the claim that solution set is convex and bounded}
\todo{Show that at least one solution exists with :math:`M` sparsity level}

.. theorem::

  Let :math:`S` denote the solution set of :math:`l_1` norm minimization problem.
  :math:`S`
  contains at least one solution :math:`\widehat{x}` with
  :math:`\| \widehat{x} \|_0 = M`.


.. proof::

  We have

  * :math:`S` is  convex and bounded.
  * :math:`\Phi x^* = y \, \Forall x^* \in S`.
  * Since :math:`\Phi \in \RR^{M \times N}` is full rank and :math:`M < N`, hence :math:`\text{rank}(\Phi) = M`.


  Let :math:`x^* \in S` be an optimal solution with :math:`\| x^* \|_0 = L > M`.

  Consider the :math:`L` columns of :math:`\Phi` which correspond to :math:`\supp(x^*)`. 

  Since :math:`L > M` and :math:`\text{rank}(\Phi) = M` hence these columns linearly dependent.

  Thus there exists a vector :math:`h \in \RR^N` with :math:`\supp(h) \subseteq \supp(x^*)` such that 
    
  .. math::

    \Phi h = 0.


  Note that since we are only considering those columns of :math:`\Phi` which correspond to
  :math:`\supp(x)`, hence we require :math:`h_i = 0` whenever :math:`x^*_i = 0`.

  Consider a new vector 
    
  .. math::

    x = x^* + \epsilon h

  where :math:`\epsilon` is small enough such that every element in :math:`x` has the same sign as :math:`x^*`.

  As long as
    
  .. math::

    |\epsilon| \leq \underset{i \in \supp(x^*)}{\min} \frac{|x^*_i|}{|h_i|} = \epsilon_0

  such an :math:`x` can be constructed.

  Note that :math:`x_i = 0` whenever :math:`x^*_i = 0`.

  Clearly
    
  .. math::

    \Phi x = \Phi (x^* + \epsilon h) = y + \epsilon 0 = y.


  Thus :math:`x` is a feasible solution to the problem 
  :eq:`l1_norm_minimization_problem` though
  it need not be an optimal solution.

  But since :math:`x^*` is optimal hence, we must assume that :math:`l_1` norm of :math:`x` is
  greater than or equal to the :math:`l_1` norm of :math:`x^*`
    
  .. math::

    \|x \|_1 = \|x^* + \epsilon h \|_1  \geq \| x^* \|_1 \Forall |\epsilon| \leq \epsilon_0.


  Now look at :math:`\|x \|_1` as a function of :math:`\epsilon` in the region :math:`|\epsilon| \leq \epsilon_0`.

  In this region, :math:`l_1` function is continuous and differentiable since
  all vectors :math:`x^* + \epsilon h` have the same sign pattern. 
  If we define :math:`y^* = | x^* |` (the vector of absolute values), then
    
  .. math::

    \| x^* \|_1 = \| y^* \|_1 = \sum_{i=1}^N y^*_i.

  Since the sign patterns don't change, hence
    
  .. math::

    |x_i| = |x^*_i   + \epsilon h_i | = y^*_i + \epsilon h_i \sgn(x^*_i).

  Thus
    
  .. math::

    \begin{aligned}
    \|x \|_1 &= \sum_{i=1}^N |x_i| \\
    &= \sum_{i=1}^N \left (y^*_i + \epsilon h_i \sgn(x^*_i) \right) \\
    &= \| x^* \|_1 + \epsilon \sum_{i=1}^N h_i \sgn(x^*_i)\\
    &= \| x^* \|_1 + \epsilon h^T \sgn(x^*).
    \end{aligned}

  The quantity :math:`h^T \sgn(x^*)` is a constant.
  The inequality :math:`\|x \|_1 \geq \| x^* \|_1` 
  applies to both positive and negative values of :math:`\epsilon` in the region :math:`|\epsilon | \leq \epsilon_0`.
  This is possible only when inequality is in fact an equality. 

  This implies that the addition / subtraction of :math:`\epsilon h` under these conditions does not change
  the :math:`l_1` length of the solution. Thus, :math:`x \in S` is also an optimal solution.

  This can happen only if
    
  .. math::

    h^T \sgn(x^*) = 0.


  We now wish to tune :math:`\epsilon` such that one entry in :math:`x^*` gets nulled while keeping
  the solutions :math:`l_1` length.

  We choose :math:`i` corresponding to :math:`\epsilon_0` (defined above) and pick
    
  .. math::

    \epsilon = \frac{-x^*_i}{h_i}.

  Clearly for the corresponding
    
  .. math::

    x  = x^* + \epsilon h

  the :math:`i`-th entry is nulled while others keep their sign and the :math:`l_1` norm is also preserved.
  Thus, we have got a new optimal solution with :math:`L-1` non-zeros at the most. It is possible
  that more than 1 entries get nulled this operation.

  We can repeat this procedure till we are left with :math:`M` non-zero elements. 

  Beyond this
  we may not proceed since :math:`\text{rank}(\Phi) = M` hence we cannot say that corresponding columns
  of :math:`\Phi` are linearly dependent.


We thus note that :math:`l_1` norm has a tendency to prefer sparse solutions. This is a
well known and fundamental property of linear programming.

:math:`l_1` norm minimization problem as a linear programming problem
------------------------------------------------------------------------

We now show that :math:`l_1` norm minimization problem in :math:`\RR^N` 
is in fact a linear programming problem.

Recalling the problem:
    
.. math::
  :label: l1_norm_minimization_problem

  \begin{aligned}
    & \underset{x \in \RR^N}{\text{minimize}} 
    & &  \| x \|_1 \\
    & \text{subject to}
    & &  y = \Phi x.
  \end{aligned}


Let us write :math:`x` as :math:`u  - v`  where :math:`u, v \in \RR^N` are both non-negative vectors such that
:math:`u` takes all positive entries in :math:`x` while :math:`v` takes all the negative entries in :math:`x`.

.. example:: :math:`x = u - v`

  Let 
    
  .. math::

  x = (-1, 0 , 0 , 2, 0 , 0, 0, 4, 0, 0, -3, 0 , 0 , 0 , 0, 2 , 10).

  Then
    
  .. math::

  u = (0, 0 , 0 , 2, 0 , 0, 0, 4, 0, 0, 0, 0 , 0 , 0 , 0, 2 , 10).

  And
    
  .. math::

  v = (1, 0 , 0 , 0, 0 , 0, 0, 0, 0, 0, 3, 0 , 0 , 0 , 0, 0 , 0).


  Clearly :math:`x  = u - v`.


We note here that by definition
    
.. math::

  \supp(u) \cap \supp(v) = \EmptySet

i.e. support of :math:`u` and :math:`v` do not overlap.

We now construct a vector
    
.. math::

  z = \begin{bmatrix}
  u \\ v
  \end{bmatrix} \in \RR^{2N}.


We can now verify that
    
.. math::

  \| x \|_1 = \|u\|_1 + \| v \|_1 = 1^T z.


And 
    
.. math::

  \Phi x = \Phi (u - v) = \Phi u - \Phi v = 
  \begin{bmatrix}
  \Phi & -\Phi
  \end{bmatrix}
  \begin{bmatrix}
  u \\ v
  \end{bmatrix}
  = \begin{bmatrix}
  \Phi & -\Phi
  \end{bmatrix} z 

where  :math:`z \succeq 0`.

Hence the optimization problem :eq:`l1_norm_minimization_problem` can be recast as
    
.. math::
  :label: l1_norm_minimization_problem_as_lp

  \begin{aligned}
    & \underset{z \in \RR^{2N}}{\text{minimize}} 
    & &  1^T z \\
    & \text{subject to}
    & &  \begin{bmatrix} \Phi & -\Phi \end{bmatrix} z = y\\
    & \text{and}
    & & z \succeq 0.
  \end{aligned}


This optimization problem has the classic Linear Programming structure since the
objective function is affine as well as constraints are affine.

Let :math:`z^* =\begin{bmatrix} u^* \\ v^* \end{bmatrix}` be an optimal solution to the
problem :eq:`l1_norm_minimization_problem_as_lp`.  

In order to show that the two optimization problems are equivalent, we need
to verify that our assumption about the decomposition of :math:`x` into positive entries in :math:`u` 
and negative entries in :math:`v` is indeed satisfied by the optimal solution :math:`u^*` and :math:`v^*`.
i.e. support of :math:`u^*` and :math:`v^*` do not overlap.

Since :math:`z \succeq 0` hence :math:`\langle u^* , v^* \rangle  \geq 0`. If support of :math:`u^*` and :math:`v^*` 
don't overlap, then we  have :math:`\langle u^* , v^* \rangle = 0`. And if they overlap then
:math:`\langle u^* , v^* \rangle > 0`.

Now for the sake of contradiction, let us assume that support of :math:`u^*` and :math:`v^*` do overlap for 
the optimal solution :math:`z^*`.

Let :math:`k` be one of the indices at which both :math:`u_k \neq 0` and :math:`v_k \neq 0`. Since :math:`z \succeq 0`, 
hence :math:`u_k > 0` and :math:`v_k > 0`.

Without loss of generality let us assume that :math:`u_k > v_k > 0`.

In the equality constraint
    
.. math::

  \begin{bmatrix} \Phi & -\Phi \end{bmatrix} \begin{bmatrix} u \\ v \end{bmatrix} = y


Both of these coefficients multiply the same column of :math:`\Phi` with opposite signs giving us a term
    
.. math::

  \phi_k (u_k - v_k). 


Now if we replace the two entries in :math:`z^*` by
    
.. math::

  u_k'  = u_k - v_k

and
    
.. math::

  v_k' = 0

to obtain an new vector :math:`z'`, 
we see that there is no impact in the equality constraint 
    
.. math::

  \begin{bmatrix} \Phi & -\Phi \end{bmatrix} z = y.

Also the positivity constraint
    
.. math::

  z \succeq 0

is satisfied. This means that :math:`z'` is a feasible solution.

On the other hand the objective function :math:`1^T z` value reduces by :math:`2 v_k` for :math:`z'`. 
This contradicts our assumption that :math:`z^*` is the optimal solution.

Hence for the optimal solution of :eq:`l1_norm_minimization_problem_as_lp`
we have
    
.. math::

  \supp(u^*) \cap \supp(v^*) = \EmptySet

thus 
    
.. math::

  x^* = u^* - v^*

is indeed the desired solution for the optimization problem :eq:`l1_norm_minimization_problem`.


Bibliography
-------------------


.. bibliography:: ../../sksrrcs.bib

