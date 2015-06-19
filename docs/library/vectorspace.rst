
Vector Spaces
================================

.. highlight:: matlab


Basis for intersection of two subspaces::

    result = CS_Spaces.insersection_space(A, B)



Orthogonal complement of A in B::

    result = CS_Spaces.orth_complement(A, B)

Principal angles between subspaces spanned by A and B::

    result = CS_Spaces.principal_angles_cos(A, B);
    result = CS_Spaces.principal_angles_radian(A, B);
    result = CS_Spaces.principal_angles_degree(A, B);

Smallest principal angle between subspaces spanned by A and B::

    result = CS_Spaces.smallest_angle_cos(A, B);
    result = CS_Spaces.smallest_angle_rad(A, B);
    result = CS_Spaces.smallest_angle_deg(A, B);

Principal angle between two orthogonal bases::

    result = CS_Spaces.principal_angles_orth_cos(A, B)
    result = CS_Spaces.smallest_angle_orth_cos(A, B);


Smallest angles between subspaces::

    result = CS_Spaces.smallest_angles_cos(subspaces, d)
    result = CS_Spaces.smallest_angles_rad(subspaces, d)
    result = CS_Spaces.smallest_angles_deg(subspaces, d)

Distance between subspaces based on Grassmannian space::

    result = CS_Spaces.subspace_distance(A, B)

This is computed as the operator norm of the difference between projection matrices for two subspaces.

Check if v in range of unitary matrix U::

    result = CS_Spaces.is_in_range_orth(v, U)

Check if v in range of A::

    result = CS_Spaces.is_in_range(v, A)

A basis for matrix A::

    result = CS_Spaces.find_basis(A)

Elementary matrices product and row reduced echelon form::

    [E, R] = CS_Spaces.elim(A)

Basis for null space of A::

    result = CS_Spaces.null_basis(A)

Bases for four fundamental spaces::

    [col_space, null_space, row_space, left_null_space]  = CS_Spaces.four_bases(A)
    [col_space, null_space, row_space, left_null_space]  = CS_Spaces.four_orth_bases(A)


Utility for constructing specific examples
-----------------------------------------------------    

Two spaces at a given angle::

    [A, B]  = CS_Spaces.two_spaces_at_angle(N, theta)

Three spaces at a given angle::

    [A, B, C] = CS_Spaces.three_spaces_at_angle(N, theta)


Three disjoint spaces at a given angle::

    [A, B, C] = CS_Spaces.three_disjoint_spaces_at_angle(N, theta)

Map data from k dimensions to n dimensions::

    result = CS_Spaces.k_dim_to_n_dim(X, n, indices)


Describing relations between three spaces::

    CS_Spaces.describe_three_spaces(A, B, C);


Usage::

    d = 4;
    theta = 10;
    n = 20;
    [A, B, C] = CS_Spaces.three_disjoint_spaces_at_angle(deg2rad(theta), d);
    CS_Spaces.describe_three_spaces(A, B, C);
    % Put them together
    X = [A B C];
    % Put them to bigger dimension
    X = CS_Spaces.k_dim_to_n_dim(X, n);
    % Perform a random orthonormal transformation
    O = orth(randn(n));
    X = O * X;

