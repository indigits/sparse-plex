.. _sec:em:
 
Expectation Maximization
----------------------------------------------------

Expectation-Maximization (EM) :cite:`dempster1977maximum` method is a maximum
likelihood based estimation paradigm. It requires 
an explicit probabilistic model of the mixed data-set.
The algorithm estimates model parameters and the
segmentation of data in Maximum-Likelihood (ML) sense.

We assume that :math:`y_s` are samples drawn from 
multiple "component" distributions and each 
component distribution is centered around a mean.
Let there be :math:`K` such component distributions.
We introduce a latent (hidden) discrete random
variable :math:`z \in \{1, \dots, K\}` associated with the
random variable  :math:`y` such that :math:`z_s = k` if :math:`y_s`
is drawn from :math:`k`-th component distribution. The
random vector :math:`(y, z) \in \RR^M \times \{1, \dots, K\}` 
completely describes the event that a point :math:`y`
is drawn from a component indexed by the value of :math:`z`.

We assume that :math:`z` is subject to a multinomial (marginal)
distribution. i.e.:


.. math::
    p(z= k) = \pi_k \geq 0, \quad 
    \pi_1 + \dots + \pi_K = 1.

Each component distribution can then be modeled as a
conditional (continuous) distribution :math:`f(y | z)`. If
each of the components is a multivariate normal distribution,
then we have :math:`f(y | z = k) \sim \NNN(\mu_k, \Sigma_k)`
where :math:`\mu_k` is the mean and :math:`\Sigma_k` is the covariance
matrix of the :math:`k`-th component distribution.
The parameter set for this model is then 
:math:`\theta = \{\pi_k, \mu_k, \Sigma_K \}_{k=1}^K`
which is unknown in general and needs to be estimated from
the dataset :math:`Y`. 

With :math:`(y, z)` being the complete random 
vector, the marginal PDF of :math:`y` given :math:`\theta` is given by


.. math::
    f(y | \theta) = \sum_{z = 1}^K f(y | z, \theta) p (z | \theta)
    = \sum_{z = 1}^K \pi_k f(y | z=k, \theta).

The log-likelihood function for the dataset 
:math:`Y = \{ y_s\}_{s=1}^N` is given by


.. math::
    l (Y; \theta) = \sum_{s=1}^S \ln f(y_s | \theta).

An ML estimate of the parameters, namely :math:`\hat{\theta}_{\ML}` 
is obtained by maximizing :math:`l (Y; \theta)` over the
parameter space. 
The statistic :math:`l (Y; \theta)` is called
*incomplete log-likelihood function*
since it is marginalized over :math:`z`
It is very difficult to compute and maximize directly. The EM method provides an alternate
means of maximizing :math:`l (Y; \theta)` by
utilizing the latent r.v. :math:`z`.

We start with noting that 


.. math:: 

    f(y | \theta) p ( z | y , \theta) = f(y, z | \theta), 



.. math:: 

    \sum_{k=1}^K p(z = k | y , \theta) = 1.

Thus, :math:`l (Y; \theta)` can be rewritten as


.. math::
    \begin{aligned}
    l (Y; \theta) &= \sum_{s=1}^S 
    \sum_{k=1}^K p(z_s = k | y_s , \theta)
    \ln \frac{f(y_s, z_s =k | \theta)}{p(z_s=k | y_s, \theta)}\\
    &= \sum_{s, k}  p(z_s = k | y_s , \theta) 
    \ln f(y_s, z_s =k | \theta) \\
    &- \sum_{s, k}  p(z_s = k | y_s , \theta) 
    \ln p(z_s=k | y_s, \theta) .
    \end{aligned}

The first term is 
*expected complete log-likelihood function*
and the second term is the 
*conditional entropy* of :math:`z_s` given :math:`y_s` 
and :math:`\theta`.

Let us introduce auxiliary variables
:math:`w_{sk} (\theta) = p(z_s = k | y_s , \theta)`.
:math:`w_{sk}` basically represents the expected membership
of :math:`y_s` in the :math:`k`-th cluster.
Put :math:`w_{sk}` in a matrix :math:`W (\theta)` and write:


.. math::
    l'(Y; \theta, W) = \sum_{s=1}^S \sum_{k=1}^K 
    w_{sk} \ln f(y_s, z_s =k | \theta).



.. math::
    h( z | y;  W) = - \sum_{s=1}^S \sum_{k=1}^K 
    w_{sk} \ln w_{sk}.

Then, we have


.. math::
    l(Y; \theta, W) = l'(Y; \theta, W)  + h( z | y;  W)

where, we have written :math:`l` as a function of 
both :math:`\theta` and :math:`W`. An iterative maximization
approach can be introduced as follows:

*  Maximize :math:`l(Y; \theta, W)` w.r.t. :math:`W` keeping 
   :math:`\theta` as constant.
*  Maximize :math:`l(Y; \theta, W)` w.r.t. :math:`\theta` keeping
   :math:`W` as constant.
*  Repeat the previous two steps till convergence. 

This is essentially the EM algorithm. Step 1 is known
as *E-step* and step 2 is known as the *M-step*.
In the E-step, we are estimating the expected membership
of each sample being drawn from each component distribution.
In the M-step, we are maximizing the 
expected complete log-likelihood
function as the conditional entropy term 
doesn't depend on :math:`\theta`.

Using Lagrange multiplier, we can show that the optimal
:math:`\hat{w}_{sk}` in the E-step is given by


.. math::
    \hat{w}_{sk} = \frac{\pi_k f(y_s | z_s = k, \theta )}
    {\sum_{l=1}^K \pi_l f(y_s | z_s = l, \theta )}.


A closed form solution for the :math:`M`-step depends on the
particular choice of the component distributions.
We provide a closed form solution for the special
case when each of the components is an
isotropic normal distribution (:math:`\NNN(\mu_k, \sigma_k^2 I)`).


.. math::
    \begin{aligned}
    &\hat{\mu_k} = \frac{\sum_{s=1}^S w_{sk} y_s}
    {\sum_{s=1}^S w_{sk}},\\
    &\hat{\sigma}_k^2 = \frac{\sum_{s=1}^S w_{sk} \| y_s - \mu_k \|_2^2}
    {M \sum_{s=1}^S w_{sk}},\\
    &\hat{\pi_k} = \frac{\sum_{k=1}^K w_{sk}}{K}.
    \end{aligned}

In :math:`K`-means, each :math:`y_s` gets hard assigned to
a specific cluster. In EM, we have a soft assignment
given by :math:`w_{sk}`. 


EM-method is a good method for a hybrid dataset
consisting of mixture of component distributions. 
Yet, its applicability is limited. We need to have
a good idea of the number of components beforehand.
Further, for a Gaussian Mixture Model (GMM), 
it fails to work if the variance in 
some of the directions is arbitrarily small :cite:`vapnik2013nature`. For example, a subspace like 
distribution is one where the data has large variance
within a subspace but almost zero variance orthogonal
to the subspace. The EM method tends to fail with 
subspace like distributions.



