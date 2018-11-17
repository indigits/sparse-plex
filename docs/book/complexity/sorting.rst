.. _sec:complexity:sorting:
 
Sorting
===================================================

We sometimes need sorting and searching
operations on arrays of numbers in 
the numerical algorithms. This section summarizes
results related to number of operations needed
to perform various
sorting and searching tasks on arrays.
These results are collected from or based
on the approach in :cite:`sedgewick2013introduction`.
Fundamental operations in these algorithms
are comparison, load, store and exchanges of
array elements.

Finding the maximum of an array of length n
takes :math:`n-1 \approx n` comparisons. We assume
the first entry as maximum, keep comparing
with other entries in array, and change the
maximum if the entry in array is larger.
On an average, half of these comparisons
will also require changing the maximum entry.
Apart from finding the largest entry, we are
often required to find its location too. 
Location will be updated whenever maximum value
is updated.
If we have
to find :math:`k` largest entries in the array
(along with their indices), we can
work iteratively: find maximum, set the corresponding
entry in array to small enough value (0 for positive valued
array, :math:`-\infty` for real array), find the second largest
entry and so on.  This would require :math:`kn` comparisons
approximately.
Considering additional book-keeping cost, the
flop count can be put at :math:`2kn`. 
If the array is needed further, we can
put the :math:`k` largest entries back in the array.

Theorem 1.3 in :cite:`sedgewick2013introduction` suggests
that quicksort algorithm on average uses 
:math:`(n-1)/2` partitioning stages, 
:math:`2n\ln{n}  -1.846n` compares and
:math:`.333 n \ln{n} -.865 n` exchanges to sort
an array of n randomly ordered distinct elements.

Our needs for sorting also require us to store
the indices of entries in sorted array in the original
array. This is done by creating an index array and
performing exchanges on the index array whenever 
exchanges are done in the original array. Keeping
these extra operations in mind,
We will use a conservative estimate of :math:`4n \ln{n}`
flops for sorting an array. Once the array is
sorted, picking the :math:`k` largest entries requires
:math:`k` iterations. It is noted here that when :math:`n`
is small (say less than 1000), then an efficient
implementation of quicksort can actually beat 
the naive way of finding :math:`k` largest entries 
discussed above. This will be our preferred
approach in this work.

