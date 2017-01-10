Combinatorics
============================

.. highlight:: matlab



Steiner Systems
---------------------------


Steiner system with block size 2::

    v = 10;
    m = spx.discrete.steiner_system.ss_2(v);


Steiner system with block size 3  (STS Steiner Triple System)::

    m = spx.discrete.steiner_system.ss_3(v);


Bose construction for STS system for v = 6n + 3 ::

    m = spx.discrete.steiner_system.ss_3_bose(v);


Verify if a given incidence matrix is a Steiner system::

    spx.discrete.steiner_system.is_ss(M, k)

Latin square construction::


    spx.discrete.steiner_system.commutative_idempotent_latin_square(n)


Verify if a table is a Latin square::

    spx.discrete.steiner_system.is_latin_square(table)





