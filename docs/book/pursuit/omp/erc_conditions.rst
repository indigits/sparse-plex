 
Exact recovery conditions
==========================================

Recall the :math:`(\mathcal{D}, K)`-:textsc:`exact-sparse` problem
discussed in :ref:`sec:ssm:sparse_approximation_problem`. 
OMP is a good and fast algorithm for solving this problem.

In terms of theoretical understanding, it is quite useful to 
know of certain conditions under which a sparse representation
can be exactly recovered from a given signal using OMP. 
Such guarantees are known as *exact recovery guarantees*.

In this section, following Tropp in :cite:`tropp2004greed`, 
we will closely look at some conditions under which OMP is
guaranteed to recover the solution for 
:math:`(\mathcal{D}, K)`-:textsc:`exact-sparse` problem.

We rephrase the OMP algorithm following the conventions in 
:math:`(\mathcal{D}, K)`-:textsc:`exact-sparse` problem.

.. figure:: images/algorithm_omp_x_alpha_version.png


It is known that :math:`x = \Phi \alpha` where :math:`\alpha` contains 
at most :math:`K` non-zero entries. 
Both the support and entries of :math:`\alpha` are known.
OMP is only given :math:`\Phi`, :math:`x` and :math:`K` and is estimating 
:math:`\alpha`. The estimate returned by OMP is denoted as
:math:`\widehat{\alpha}`.

Let :math:`\Lambda_{\text{opt}} = \supp(\alpha)` be the set of indices at which 
optimal representation :math:`\alpha` has non-zero entries.
Then we can write


.. math:: 

    x  = \sum_{i \in \Lambda} \alpha_i \phi_i.


From the synthesis matrix :math:`\Phi` we can extract a :math:`N \times K` matrix :math:`\Phi_{\text{opt}}` whose columns are
indexed by :math:`\Lambda_{\text{opt}}`. 

.. math:: 

    \Phi_{\text{opt}} \triangleq \begin{bmatrix} \phi_{\lambda_1} & \dots & \phi_{\lambda_K} \end{bmatrix} 

where :math:`\lambda_i \in \Lambda_{\text{opt}}`.
Thus, we can also write

.. math:: 

    x  = \Phi_{\text{opt}}  \alpha_{\text{opt}}

where :math:`\alpha_{\text{opt}} \in \CC^K` is a vector of :math:`K` complex entries.

Now the columns of optimum :math:`\Phi_{\text{opt}}` are linearly independent. Hence :math:`\Phi_{\text{opt}}` has full column rank.

We define another matrix :math:`\Psi_{\text{opt}}` whose columns are the remaining :math:`D - K` columns of :math:`\Phi`. Thus
:math:`\Psi_{\text{opt}}` consists of atoms or columns which do not participate in the optimum representation of :math:`x`.

OMP starts with an empty support. In every step, it picks up one column from :math:`\Phi` and adds to the
support of approximation. If we can ensure that it never selects any column from :math:`\Psi_{\text{opt}}`
we will be guaranteed that correct :math:`K` sparse representation is recovered.

We will use mathematical induction and assume that OMP has succeeded in its first :math:`k` steps
and has chosen :math:`k` columns from :math:`\Phi_{\text{opt}}` so far. At this point it is left with
the residual :math:`r^k`. 

In :math:`(k+1)`-th iteration, we compute inner product of :math:`r^k` with all columns in :math:`\Phi` and choose the column
which has highest inner product. 

We note that maximum value of inner product of :math:`r^k` with any of the columns in :math:`\Psi_{\text{opt}}` is given by


.. math:: 

    \| \Psi_{\text{opt}}^H r^k \|_{\infty}.


Correspondingly, maximum value of inner product of :math:`r^k` with any of 
the columns in :math:`\Phi_{\text{opt}}` is given by


.. math:: 

    \| \Phi_{\text{opt}}^H r^k \|_{\infty}.


Actually since we have already shown that :math:`r^k` is 
orthogonal to the columns already chosen, hence they will not contribute 
to this equation.

In order to make sure that none of the columns in 
:math:`\Psi_{\text{opt}}` is selected, we need


.. math:: 

    \| \Psi_{\text{opt}}^H r^k \|_{\infty} < \| \Phi_{\text{opt}}^H r^k \|_{\infty}.



.. _def:greedy:omp:greedy_selection_ratio:

.. definition:: 

     .. index:: Greedy selection ratio

    We define a ratio
    
    
    .. math::
        :label: eq:greedy:omp:greedy_selection_ratio
    
        \rho(r^k) \triangleq \frac{\| \Psi_{\text{opt}}^H r^k \|_{\infty}}{\| \Phi_{\text{opt}}^H r^k \|_{\infty}}.
    
    This ratio is known as **greedy selection ratio**.



We can see that as long as :math:`\rho(r^k) < 1`, OMP will make a 
right decision at :math:`(k+1)`-th stage. If :math:`\rho(r^k) = 1` then
there is no guarantee that OMP will make the right decision. 
We will assume pessimistically that 
OMP makes wrong decision in such situations.

We note that this definition of :math:`\rho(r^k)` looks very similar to matrix 
:math:`p`-norms defined in 
:ref:`sec:mat:p_norm`. 
It is suggested to review the properties of :math:`p`-norms for matrices at this point.

We now present a condition which guarantees that :math:`\rho(r^k) < 1` is always satisfied.


.. index:: Exact recovery condition for OMP

.. _thm:greedy:omp_exact_recovery_sufficient_condition:

.. theorem:: 


    A sufficient condition for Orthogonal Matching Pursuit to resolve :math:`x` completely in :math:`K` steps is that
    
    
    .. math::
        :label: eq:greedy:omp_exact_recovery_sufficient_condition
    
        \underset{\psi}{\max} \| \Phi_{\text{opt}}^{\dag} \psi \|_1 < 1,
    
    where :math:`\psi` ranges over columns in :math:`\Psi_{\text{opt}}`.
    
    Moreover, Orthogonal Matching Pursuit is a correct algorithm for :math:`(\mathcal{D}, K)`-:textsc:`exact-sparse` problem
    whenever the condition holds for every superposition of :math:`K` atoms from :math:`\DD`.




.. proof:: 

    In  :eq:`eq:greedy:omp_exact_recovery_sufficient_condition` :math:`\Phi_{\text{opt}}^{\dag}` is the pseudo-inverse
    of :math:`\Phi` 
    
    
    .. math:: 
    
        \Phi_{\text{opt}}^{\dag} = (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1} \Phi_{\text{opt}}^H.
    
    
    
    What we need to show is if :eq:`eq:greedy:omp_exact_recovery_sufficient_condition` holds true then
    :math:`\rho(r^k)` will always be less than 1.
    
    We note that the projection operator for the column span of :math:`\Phi_{\text{opt}}` is given by 
    
    
    .. math:: 
    
        \Phi_{\text{opt}} (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1} \Phi_{\text{opt}}^H
        = (\Phi_{\text{opt}}^{\dag})^H \Phi_{\text{opt}}^H.
    
    
    We also note that by assumption since :math:`x \in \ColSpace(\Phi_{\text{opt}})` and
    the approximation at the :math:`k`-th step, :math:`x^k = \Phi \alpha^k  \in \ColSpace(\Phi_{\text{opt}})`, hence
    :math:`r^k = x - x^k` also belongs to :math:`\ColSpace(\Phi_{\text{opt}})`.
    
    Thus
    
    
    .. math:: 
    
        r^k = (\Phi_{\text{opt}}^{\dag})^H \Phi_{\text{opt}}^H r^k
    
    i.e. applying the projection operator for :math:`\Phi_{\text{opt}}` on :math:`r^k` doesn't change it.
    
    Using this we can rewrite :math:`\rho(r^k)` as
    
    
    .. math:: 
    
        \rho(r^k) = \frac{\| \Psi_{\text{opt}}^H r^k \|_{\infty}}{\| \Phi_{\text{opt}}^H r^k \|_{\infty}}
        = \frac{\| \Psi_{\text{opt}}^H (\Phi_{\text{opt}}^{\dag})^H \Phi_{\text{opt}}^H r^k \|_{\infty}}
        {\| \Phi_{\text{opt}}^H r^k \|_{\infty}}.
    
    
    We see :math:`\Phi_{\text{opt}}^H r^k` appearing both in numerator and denominator. 
    
    Now consider the matrix :math:`\Psi_{\text{opt}}^H (\Phi_{\text{opt}}^{\dag})^H` 
    and recall the definition of matrix :math:`\infty`-norm from :ref:`here <def:mat:p_matrix_norm>`
    
    
    .. math:: 
    
        \| A\|_{\infty} = \underset{x \neq 0}{\max } \frac{\| A x \|_{\infty}}{\| x \|_{\infty}} 
        \geq  \frac{\| A x \|_{\infty}}{\| x \|_{\infty}} \Forall x \neq 0.
    
    Thus
    
    
    .. math:: 
    
        \| \Psi_{\text{opt}}^H (\Phi_{\text{opt}}^{\dag})^H \|_{\infty} \geq \frac{\| \Psi_{\text{opt}}^H (\Phi_{\text{opt}}^{\dag})^H \Phi_{\text{opt}}^H r^k \|_{\infty}}
        {\| \Phi_{\text{opt}}^H r^k \|_{\infty}}
    
    which gives us
    
    
    .. math:: 
    
        \rho(r^k)  \leq \| \Psi_{\text{opt}}^H (\Phi_{\text{opt}}^{\dag})^H \|_{\infty} 
        = \| \left ( \Phi_{\text{opt}}^{\dag} \Psi_{\text{opt}} \right )^H \|_{\infty}.
    
    
    Finally we recall that :math:`\| A\|_{\infty}` is max row sum norm while
    :math:`\| A\|_1` is max column sum norm. Hence
    
    
    .. math:: 
    
        \| A\|_{\infty} = \| A^T \|_1= \| A^H \|_1
    
    which means
    
    
    .. math:: 
    
        \| \left ( \Phi_{\text{opt}}^{\dag} \Psi_{\text{opt}} \right )^H \|_{\infty} 
        = \| \Phi_{\text{opt}}^{\dag} \Psi_{\text{opt}} \|_1.
    
    Thus
    
    
    .. math:: 
    
        \rho(r^k) \leq \| \Phi_{\text{opt}}^{\dag} \Psi_{\text{opt}} \|_1.
    
    
    Now the columns of :math:`\Phi_{\text{opt}}^{\dag} \Psi_{\text{opt}}`  are nothing but
    :math:`\Phi_{\text{opt}}^{\dag} \psi` where :math:`\psi` ranges over columns of :math:`\Psi_{\text{opt}}`.
    
    Thus in terms of max column sum norm
    
    
    .. math:: 
    
        \rho(r^k) \leq \underset{\psi}{\max} \| \Phi_{\text{opt}}^{\dag} \psi \|_1.
    
    Thus assuming that OMP has made :math:`k` correct decision and :math:`r^k` 
    lies in :math:`\ColSpace( \Phi_{\text{opt}})`, :math:`\rho(r^k) < 1` whenever
    
    
    .. math::
        \underset{\psi}{\max} \| \Phi_{\text{opt}}^{\dag} \psi \|_1 < 1.
    
    
    Finally the initial residual :math:`r^0 = 0` which always lies in column space of :math:`\Phi_{\text{opt}}`.
    By above logic, OMP will always select an optimal column in each step. Since
    the residual is always orthogonal to the columns already selected, hence it will never
    select the same column twice. Thus in :math:`K` steps it will retrieve all :math:`K` atoms which
    comprise :math:`x`. 


 
Babel function estimates
----------------------------------------------------


There is a small problem with :ref:`this result <thm:greedy:omp_exact_recovery_sufficient_condition>`.
Since we don't know the support a-priori hence its not possible to verify that 


.. math:: 

     \underset{\psi}{\max} \| \Phi_{\text{opt}}^{\dag} \psi \|_1 < 1

holds. 
Of course, verifying this for all :math:`K` column sub-matrices is 
computationally prohibitive. 

It turns out that Babel function (recall from :ref:`sec:ssm:babel`) is there to help.
We show how Babel function guarantees that exact recovery condition for OMP holds.


.. _thm:greedy:omp_exact_recovery_babel_function:

.. theorem:: 


    Suppose that :math:`\mu_1` is the Babel function for a dictionary :math:`\DD` with synthesis
    matrix :math:`\Phi`. The exact recovery condition holds whenever
    
    
    .. math::
        :label: eq:greedy:omp_exact_recovery_babel_function
    
        \mu_1 (K - 1) + \mu_1(K) < 1.
    
    Thus, Orthogonal Matching Pursuit is a correct algorithm for :math:`(\mathcal{D}, K)`-:textsc:`exact-sparse` problem
    whenever :eq:`eq:greedy:omp_exact_recovery_babel_function` holds. 
    
    In other words, for sufficiently small :math:`K` for which :eq:`eq:greedy:omp_exact_recovery_babel_function`
    holds, OMP will recover any arbitrary superposition of :math:`K` atoms from :math:`\DD`.




.. proof:: 

    We can write
    
    
    .. math:: 
    
         \underset{\psi}{\max} \| \Phi_{\text{opt}}^{\dag} \psi \|_1 
         =  \underset{\psi}{\max} \| (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1} \Phi_{\text{opt}}^H \psi \|_1 
    
    
    We recall from :ref:`here <lem:mat:operator_norm_subordinate>` that operator-norm is subordinate i.e.
    
    
    .. math:: 
    
        \| A x \|_1 \leq \| A \|_1 \| x \|_1.
    
    
    Thus with :math:`A = (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1}` we have
    
    
    .. math:: 
    
        \| (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1} \Phi_{\text{opt}}^H \psi \|_1
        \leq  \| (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1} \|_1 \| \Phi_{\text{opt}}^H \psi \|_1.
    
    With this we have
    
    
    .. math::
         \underset{\psi}{\max} \| \Phi_{\text{opt}}^{\dag} \psi \|_1  \leq 
         \| (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1} \|_1 \underset{\psi}{\max} \| \Phi_{\text{opt}}^H \psi \|_1.
    
    
    Now let us look at :math:`\| \Phi_{\text{opt}}^H \psi \|_1` closely. There are :math:`K` columns in 
    :math:`\Phi_{\text{opt}}`. For each column we compute its inner product with :math:`\psi`. And then
    absolute sum of the inner product. 
    
    Also recall the definition of Babel function:
    
    
    .. math:: 
    
        \mu_1(K) = \underset{|\Lambda| = K}{\max} \; \underset {\psi}{\max} 
        \sum_{\Lambda} | \langle \psi, \phi_{\lambda} \rangle |.
    
    
    Clearly 
    
    
    .. math::
        \underset{\psi}{\max} \| \Phi_{\text{opt}}^H \psi \|_1 
        = \underset{\psi}{\max}  \sum_{\Lambda_{\text{opt}}} | \langle \psi, \phi_{\lambda_i} \rangle | \leq \mu_1(K). 
    
    
    We also need to provide a bound on :math:`\| (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1} \|_1` which
    requires more work.
    
    First note that since all columns in :math:`\Phi` are unit norm, hence the diagonal of 
    :math:`\Phi_{\text{opt}}^H \Phi_{\text{opt}}` contains unit entries. Thus we can write
    
    
    .. math:: 
    
        \Phi_{\text{opt}}^H \Phi_{\text{opt}} = I_K + A
    
    where :math:`A` contains the off diagonal terms in :math:`\Phi_{\text{opt}}^H \Phi_{\text{opt}}`.
    
    Looking carefully , each column of :math:`A` lists the inner products between one atom of :math:`\Phi_{\text{opt}}`
    and the remaining :math:`K-1` atoms. By definition of Babel function
    
    
    .. math:: 
    
        \|A \|_1 = \max_{k} \sum_{j \neq k} | \langle \phi_{\lambda_k} \phi_{\lambda_j} \rangle | \leq \mu_1(K -1).
    
    
    Now whenever :math:`\| A \|_1 < 1` then the Von Neumann series :math:`\sum(-A)^k` converges to the inverse
    :math:`(I_K + A)^{-1}`.
    
    Thus we have
    
    
    .. math::
        \begin{aligned}
        \| (\Phi_{\text{opt}}^H \Phi_{\text{opt}})^{-1} \|_1 &= \| ( I_K + A )^{-1} \|_1 \\
        &= \| \sum_{ k = 0}^{\infty} (-A)^k \|_1\\
        & \leq \sum_{ k = 0}^{\infty}  \| A\|^k_1 \\
        &= \frac{1}{1 - \| A \|_1}\\
        & \leq \frac{1}{1 - \mu_1(K-1)}.
        \end{aligned}
    
    
    Thus putting things together we get
    
    
    .. math:: 
    
         \underset{\psi}{\max} \| \Phi_{\text{opt}}^{\dag} \psi \|_1  
         \leq \frac{\mu_1(K)}{1  - \mu_1(K-1)}.
    
    Thus whenever 
    
    
    .. math:: 
    
        \mu_1 (K - 1) + \mu_1(K) < 1.
    
    we have
    
    
    .. math:: 
    
        \frac{\mu_1(K)}{1  - \mu_1(K-1)} < 1 \implies \underset{\psi}{\max} \| \Phi_{\text{opt}}^{\dag} \psi \|_1   < 1.

.. disqus::

