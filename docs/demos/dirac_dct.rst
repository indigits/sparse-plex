Dirac DCT Tutorial
==========================

.. highlight:: matlab

This tutorial is based on ``examples\\ex_dirac_dct_two_ortho_basis.m``.

In this tutorial we will:

* Construct a DCT basis
* Construct a Dirac-DCT dictionary.
* Construct a signal which is a mixture of few
  impulses and a few sinusoids.
* Construct its representation in the DCT basis.
* Recover its representation in Dirac-DCT dictionary
  using following sparse recovery algorithms
  
  * Matching Pursuit
  * Orthogonal Matching Pursuit
  * Basis Pursuit

* Measure the recovery error for different sparse
  recovery algorithms.

Signal space dimension::

    N = 256;

Dirac basis::

    I = eye(N);

DCT basis::

    Psi = dctmtx(N)';


Visualizing the DCT basis::

    imagesc(Psi) ;
    colormap(gray);
    colorbar;
    axis image;
    title('\Psi');

.. image:: images/dct_256.png


Combining the Dirac and  DCT orthonormal bases to form a two-ortho dictionary::

    Phi = [I  Psi];

Visualizing the dictionary::

    imagesc(Phi) ;
    colormap(gray);
    colorbar;
    axis image;
    title('\Phi');


.. image:: images/dirac_dct_256.png


Constructing a signal which is a combination of impulses and cosines::

    alpha = zeros(2*N, 1);
    alpha(20) = 1;
    alpha(30) = -.4;
    alpha(100) = .6;
    alpha(N + 4) = 1.2;
    alpha(N + 58) = -.8;
    x = Phi * alpha;
    K  = 5;


.. image:: images/impulse_cosine_combination_signal.png


Finding the representation in DCT basis::

    x_dct = Psi' * x;

.. image:: images/impulse_cosine_dct_basis.png


Sparse representation in the Dirac DCT dictionary

.. image:: images/impulse_cosine_dirac_dct.png


Obtaining the sparse representation using matching pursuit algorithm::

    solver = spx.pursuit.single.MatchingPursuit(Phi, K);
    result = solver.solve(x);
    mp_solution = result.z;
    mp_diff = alpha - mp_solution;
    % Recovery error
    mp_recovery_error = norm(mp_diff) / norm(x);

.. image:: images/dirac_dct_mp_solution.png

Matching pursuit recovery error: 0.0353.



Obtaining the sparse representation using orthogonal matching pursuit algorithm::

    solver = spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K);
    result = solver.solve(x);
    omp_solution = result.z;
    omp_diff = alpha - omp_solution;
    % Recovery error
    omp_recovery_error = norm(omp_diff) / norm(x);

.. image:: images/dirac_dct_omp_solution.png

Orthogonal Matching pursuit recovery error: 0.0000.

Obtaining a sparse approximation via basis pursuit::


    solver = spx.pursuit.single.BasisPursuit(Phi, x);
    result = solver.solve_l1_noise();
    l1_solution = result;
    l1_diff = alpha - l1_solution;
    % Recovery error
    l1_recovery_error = norm(l1_diff) / norm(x);

.. image:: images/dirac_dct_l_1_solution.png


l_1 recovery error: 0.0010.
