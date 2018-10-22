Essential Operations
=========================

Dyadic Structure
--------------------------


Here we are looking at the Haar
wavelet decomposition of
finite dimensional signals.

We assume that a signal :math:`x \in \RR^N`
where :math:`N = 2^J` for some natural number
:math:`J`.

A single level wavelet decomposition splits a signal
into two parts, an approximation and a detail part.
Both of these parts have :math:`N/2` samples.
With Haar wavelets, we can decompose the signal
:math:`J` times.

We will denote the approximations and detail
components as :math:`a_j` and :math:`d_j`.

#. We start with :math:`a_J = x` which has
   :math:`N = 2^{J}` samples.
#. First decomposition splits :math:`a_{J}` into two
   parts :math:`a_{J-1}` and :math:`b_{J -1}`
   both of which have :math:`2^{J-1}` samples.
#. Second decomposition splits :math:`a_{J-1}` into two
   parts :math:`a_{J-2}` and :math:`b_{J -2}`
   both of which have :math:`2^{J-2}` samples.
#. Third decomposition splits :math:`a_{J-2}` into two
   parts :math:`a_{J-3}` and :math:`b_{J -3}`
   both of which have :math:`2^{J-3}` samples.
#. :math:`J`-th decomposition splits :math:`a_{1}` 
   into two parts :math:`a_{0}` and :math:`d_{0}`
   both of which have :math:`2^{0} = 1` samples.
#. No further decomposition is possible.

.. note::

    Depending upon a specific wavelet structure,
    :math:`J` decompositions may not be possible.


The overall decomposition process can be written
as

.. math::

    \begin{aligned}
    a_J &\to [a_{J-1}\quad d_{J-1}]\\
        &\to [a_{J-2}\quad d_{J-2}\quad d_{J-1}]\\
        &\to [a_{J-3}\quad d_{J-3}\quad d_{J-2}\quad d_{J-1}]\\
        & \dots \\
        &\to [a_{0}\quad d_{0}\quad d_{1}\quad \dots\quad d_{J-3}\quad d_{J-2}\quad d_{J-1}]
    \end{aligned}

At every level of decomposition, the 
number of coefficients in the decomposition
is exactly :math:`N = 2^J`.

The indices occupied by each level of decomposition
are given by

.. math::

    \begin{bmatrix}
    [1] & [2] & [3,4] & [5,8] & \dots & [2^{J-1}+1),2^{J}]
    \end{bmatrix}

This is the dyadic structure of the 
:math:`J` levels of decompositions.

.. example:: J=4 decomposition

    Consider the case with :math:`N=16`
    where :math:`J=4`. 4 levels of
    decomposition are possible with Haar wavelet.

    #. :math:`a_4` has 16 samples.
    #. :math:`a_3` and :math:`d_3` both have 8 samples each.
    #. :math:`a_2` and :math:`d_2` both have 4 samples each.
    #. :math:`a_1` and :math:`d_1` both have 2 samples each.
    #. :math:`a_0` and :math:`d_0` both have 1 samples each.

    No further decomposition is possible.

    :math:`d_j` has :math:`2^j` samples and
    occupies the indices between :math:`2^{j} +1`
    and :math:`2^{j+1}`.


Functions to work with dyadic structure
----------------------------------------------------

We provide a function to identify the
indices of :math:`j`-th decomposition::

    >> spx.wavelet.dyad(1)

    ans =

         3 4

    >> spx.wavelet.dyad(2)

    ans =

         5 6 7 8

    >> spx.wavelet.dyad(3)

    ans =

         9 10 11 12 13 14 15 16

    >> spx.wavelet.dyad(4)

    ans =

        17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32


A wavelet coefficient is indexed by
two numbers :math:`(j, k)`. Here,
:math:`j` denotes the resolution level
of the wavelet and :math:`k` denotes
the translation. We have
:math:`j >= 0` and :math:`0 \leq k <2^j`.

The absolute index is given by
:math:`2^j + k + 1`.

::

    >> spx.wavelet.dyad(1)

    ans =

         3  4

    >> spx.wavelet.dyad_to_index(1,0)

    ans =

         3

    >> spx.wavelet.dyad_to_index(1,1)

    ans =

         4

    >> spx.wavelet.dyad_to_index(3,2)

    ans =

        11

``dyad_length`` lets us the number of decompositions possible
for a vector::

    >> [N, J, c] = spx.wavelet.dyad_length(1:16)
    N =
        16
    J =
         4
    c =
      logical
       1

Here N is the length of the vector, 
J is the possible number of decompositions, 
and c is consistency indicating whether N is a 
power of 2 or not.

``cut_dyadic`` cuts a signal to the
length which is the nearest power of 2::

    >> spx.wavelet.cut_dyadic(1:15)

    ans =

         1  2  3  4  5  6  7  8


Periodic Convolution
-------------------------------


Usual convolution of a signal :math:`x` of length N 
with a filter :math:`h` of length M 
results in a signal :math:`y` of length N+M-1.

.. math::
    y[n] = \sum_{k=1}^M h[k] x[n-k + 1]

The assumption here is that :math:`x[n] =0` 
for :math:`n <=0` and :math:`n > N`. 

Here is an example::

    >> conv([3 1 2], [1 2 2 1])

    ans =

         3  7 10  9  5  2

This is not suitable for an orthogonal wavelet decomposition 
of a signal. We are interested in periodic
or circular convolution which is defined by

.. math::
    y[n] = \sum_{k=1}^M h[k]  x[((n-k) \mod N)  + 1]


Periodic Extension
""""""""""""""""""""""""""""""""""""""
To construct the periodic extension of a vector, 
we provide following methods:

* ``repeat_vector_at_start`` repeats values from the end of a vector
  to its beginning.
* ``repeat_vector_at_end`` repeats values from the start of a vector
  to its end.

::

    >> spx.vector.repeat_vector_at_start(1:10, 4)

    ans =

         7  8  9 10  1  2  3  4  5  6  7  8  9 10

    >> spx.vector.repeat_vector_at_end(1:10, 4)

    ans =

         1  2  3  4  5  6  7  8  9 10  1  2  3  4


Computing the Periodic Convolution
""""""""""""""""""""""""""""""""""""""""""

We provide a method called ``iconv`` to compute the 
periodic convolution. Let's go through the steps of
periodic convolution one by one.

.. example:: Periodic convolution of constant sequence with difference filter

    Let's take an example signal::

        >> x = [1 1 1 1 1 1]

        x =

             1  1  1  1  1  1

    And an example filter::


        >> f = [1 -1]

        f =

             1 -1

    Let's get the length of signal::


        >> n = length(x)

        n =

             6

    And the length of filter::

        >> p = length(f)

        p =

             2

    Extend the signal at the start by p values (from the end)::

        >> x_padded =  spx.vector.repeat_vector_at_start(x, p)

        x_padded =

             1  1  1  1  1  1  1  1

    Perform full convolution on the extended signal::

        >> y_padded = filter(f, 1, x_padded)

        y_padded =

             1  0  0  0  0  0  0  0


    Drop the first p values from it to get the periodic convolution output::

        >> y = y_padded((p+1):(n+p))

        y =

             0  0  0  0  0  0


The same can be achieved by a single function call::

    >> spx.wavelet.iconv(f,x)

    ans =

         0  0  0  0  0  0


.. example:: Same vs Periodic Convolution

    MATLAB has a same convolution feature. This is different
    from periodic convolution::

        >> u = [-1 2 3 -2 0 1 2];
        >> v = [2 -1];
        >> conv(u,v,'same')

        ans =

             5  4 -7  2  2  3 -2

        >> spx.wavelet.iconv(v, u)

        ans =

            -4  5  4 -7  2  2  3


.. example:: Periodic convolution with time reversed filter

    There is another function for computing the convolution
    of a signal with the time reversed version of a filter.

    ::

        >> spx.wavelet.aconv(v, u)

        ans =

            -4  1  8 -4 -1  0  5

        >> spx.wavelet.iconv(v(length(v):-1:1), u)

        ans =

             5 -4  1  8 -4 -1  0

    Notice the slight difference in the two outputs.
    ``aconv`` output is circular shifted by 1.


Upsampling
------------------


Upsampling introduces zeros between individual samples.

Upsampling by a factor of 2::

    >> spx.wavelet.up_sample([-1 2 3 -2 0 1 2])

    ans =

        -1  0  2  0  3  0 -2  0  0  0  1  0  2  0


Upsampling by a factor of 3::

    >> spx.wavelet.up_sample([-1 2 3 -2 0 1 2], 3)

    ans =

        -1  0  0  2  0  0  3  0  0 -2  0  0  0  0  0  1  0  0  2  0  0

The second argument is the upsampling factor.