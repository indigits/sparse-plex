
 
Expectation-Maximization for K-subspaces
----------------------------------------------------

The EM method can
be adapted for fitting of subspaces also. We 
need to assume a statistical mixture model for the dataset.

We assume that the dataset :math:`Y` is sampled from
a mixture of :math:`K` component distributions where
each component is centered around a subspace. A 
latent (hidden) discrete random variable :math:`z \in \{1, \dots, K \}`
picks the component distribution from which a sample :math:`y`
is drawn. Let the :math:`k`-th component be centered around
the subspace :math:`\UUU_k` which has an orthogonal basis
:math:`Q_k`. Then, we can write


.. math::
    y = Q_k \alpha + B_k \beta

where :math:`B_k \in \RR^{M \times (M - D_k)}` is
an orthonormal basis for the subspace :math:`\UUU_k^{\perp}`,
:math:`Q_k \alpha_k` is the component of :math:`y_k` lying perfectly
in :math:`\UUU_k` and :math:`B_k \beta_k` is the component lying
in :math:`\UUU_k^{\perp}` representing the projection error
(to the subspace).
We will assume that both :math:`\alpha` and :math:`\beta` are
sampled from multivariate isotropic normal distributions,
i.e. :math:`\alpha \sim \NNN(0, \sigma'^2_{k} I)` 
and :math:`\beta \sim \NNN(0, \sigma^2_{k} I)`.
Assuming that :math:`\alpha` and :math:`\beta` are independent,
the covariance matrix for :math:`y` is given by


.. math::
    \Sigma_k^{-1} = \sigma'^{-2}_k Q_k Q_k^T + \sigma^{-2}_k B_k B_k^T. 

Since :math:`y` is expected to be very close the to the subspace
:math:`\UUU_k`, hence :math:`\sigma^2_k \ll \sigma'^2_k`. In the limit
:math:`\sigma'^2_k \to \infty`, we have :math:`\Sigma_k^{-1} \to \sigma^{-2}_k B_k B_k^T`. Basically, this means that :math:`y` is 
uniformly distributed in the subspace and its location
inside the subspace (given by :math:`Q_k \alpha`) is not important
to us. All we care about is that :math:`y` should belong to
one of the subspaces :math:`\UUU_k` with :math:`B_k \beta` capturing
the projection error being small and normally distributed.

The component distributes therefore are:


.. math::
    f(y | z = k)  = \frac{1}{(2 \pi \sigma_k^2)^{(M - D_k)/2}}
    \exp \left ( - \frac{y^T B_k B_k^T y}{2 \sigma_k^2}\right ).

:math:`z` is multinomial distributed with 
:math:`p (z = k) = \pi_k`. 
The parameter set for this model is then 
:math:`\theta = \{\pi_k, B_k, \sigma_K \}_{k=1}^K`
which is unknown and needs to be estimated from
the dataset :math:`Y`. 
The marginal distribution :math:`f(y| \theta)` and
the incomplete likelihood function :math:`l(Y | \theta)` can be
derived just like :ref:`here <sec:em>`. We again introduce
auxiliary variables :math:`w_{sk}` and convert the ML estimation
problem into an iterative estimation problem. 

Estimates for :math:`\hat{w}_{sk}` in the E-step remain the
same.

Estimates of parameters in :math:`\theta` in M-step are computed
as follows. We compute the weighted sample covariance matrix
for the :math:`k`-th cluster as


.. math::
    \hat{\Sigma}_k = \sum_{s=1}^S w_{sk} y_s y_s^T.

:math:`\hat{B}_k` is the eigenvectors associated with the
smallest :math:`M - D_k` eigenvalues of :math:`\hat{\Sigma}_k`.
:math:`\pi_k` and :math:`\sigma_k` are estimated as follows:


.. math::
    \hat{\pi_k} = \frac{\sum_{s=1}^S w_{sk}}{S}.
 


.. math::
    \hat{\sigma}^2_k = 
    \frac{\sum_{s=1}^S w_{sk} \| \hat{B}^2_k y_s \|_2^2 }
    {(M - D_k) \sum_{s=1}^S w_{sk}}.

The primary conceptual difference between 
:math:`K`-subspaces and EM algorithm is: At each
iteration, :math:`K`-subspaces gives a definite assignment
of every point to one of the subspaces; while 
EM views the membership as a random variable 
and uses its expected value :math:`\sum_{s=1}^S w_{ks}`
to give a "probabilistic" assignment of a data point
to a subspace.

Both of these algorithms require number of subspaces
and the dimension of each subspace as input and depend
on a good initialization of subspaces to converge
to an optimal solution.