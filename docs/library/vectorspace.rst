
Vector Spaces
================================

.. highlight:: matlab


Our work is focused on finite dimensional 
vector spaces :math:`\mathbb{R}^N` or :math:`\mathbb{C}^N`. 
We represent a vector space by a basis
in the vector space. In this section,
we describe several useful functions
for working with one or more vector spaces
(represented by one basis per vector space).



Basis for intersection of two subspaces::

    result = SPX_Spaces.insersection_space(A, B)



Orthogonal complement of A in B::

    result = SPX_Spaces.orth_complement(A, B)

Principal angles between subspaces spanned by A and B::

    result = SPX_Spaces.principal_angles_cos(A, B);
    result = SPX_Spaces.principal_angles_radian(A, B);
    result = SPX_Spaces.principal_angles_degree(A, B);

Smallest principal angle between subspaces spanned by A and B::

    result = SPX_Spaces.smallest_angle_cos(A, B);
    result = SPX_Spaces.smallest_angle_rad(A, B);
    result = SPX_Spaces.smallest_angle_deg(A, B);

Principal angle between two orthogonal bases::

    result = SPX_Spaces.principal_angles_orth_cos(A, B)
    result = SPX_Spaces.smallest_angle_orth_cos(A, B);


Smallest angles between subspaces::

    result = SPX_Spaces.smallest_angles_cos(subspaces, d)
    result = SPX_Spaces.smallest_angles_rad(subspaces, d)
    result = SPX_Spaces.smallest_angles_deg(subspaces, d)

Distance between subspaces based on Grassmannian space::

    result = SPX_Spaces.subspace_distance(A, B)

This is computed as the operator norm of the difference between projection matrices for two subspaces.

Check if v in range of unitary matrix U::

    result = SPX_Spaces.is_in_range_orth(v, U)

Check if v in range of A::

    result = SPX_Spaces.is_in_range(v, A)

A basis for matrix A::

    result = SPX_Spaces.find_basis(A)

Elementary matrices product and row reduced echelon form::

    [E, R] = SPX_Spaces.elim(A)

Basis for null space of A::

    result = SPX_Spaces.null_basis(A)

Bases for four fundamental spaces::

    [col_space, null_space, row_space, left_null_space]  = SPX_Spaces.four_bases(A)
    [col_space, null_space, row_space, left_null_space]  = SPX_Spaces.four_orth_bases(A)


Utility for constructing specific examples
-----------------------------------------------------    

Two spaces at a given angle::

    [A, B]  = SPX_Spaces.two_spaces_at_angle(N, theta)

Three spaces at a given angle::

    [A, B, C] = SPX_Spaces.three_spaces_at_angle(N, theta)


Three disjoint spaces at a given angle::

    [A, B, C] = SPX_Spaces.three_disjoint_spaces_at_angle(N, theta)

Map data from k dimensions to n dimensions::

    result = SPX_Spaces.k_dim_to_n_dim(X, n, indices)


Describing relations between three spaces::

    SPX_Spaces.describe_three_spaces(A, B, C);


Usage::

    d = 4;
    theta = 10;
    n = 20;
    [A, B, C] = SPX_Spaces.three_disjoint_spaces_at_angle(deg2rad(theta), d);
    SPX_Spaces.describe_three_spaces(A, B, C);
    % Put them together
    X = [A B C];
    % Put them to bigger dimension
    X = SPX_Spaces.k_dim_to_n_dim(X, n);
    % Perform a random orthonormal transformation
    O = orth(randn(n));
    X = O * X;

