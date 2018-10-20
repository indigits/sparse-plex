Run Length Encoding
===========================

.. highlight:: matlab


Run length encoding is a common operation in
compression applications. In this article,
we discuss how to do this efficiently in MATLAB
using vectorization techniques.


Let's consider a simple sequence of integers::

    x = [0 0 0 0 0 0 0 4  4 4 3 3 2 2 2 2 2 2 2 1 1 0 0 0 0 0 2 3 9 5 5 5 5 5 5]

The sequence has 35 elements. 

First step is change detection::

    >> diff_positions = find(diff(x) ~= 0)
    diff_positions =

         7    10    12    19    21    26    27    28    29

Note that these positions are 0 based indexes. The
first difference is occurring at x(8).

We can use this to compute the runs of each symbol::

    >> runs = diff([0 diff_positions numel(x)])
    runs =

         7     3     2     7     2     5     1     1     1     6

The start position for the first symbol of each run
can also be easily obtained::


    >> start_positions  = [1 (diff_positions + 1)]
    start_positions =

         1     8    11    13    20    22    27    28    29    30

We can now pick up the symbols from x::

    >> symbols = x(start_positions)
    symbols =

         0     4     3     2     1     0     2     3     9     5

Combine the symbols and their runs::

    >> encoding = [symbols; runs]
    encoding =

         0     4     3     2     1     0     2     3     9     5
         7     3     2     7     2     5     1     1     1     6

Flatten the encoding::

    >> encoding = encoding(:)';
    >> fprintf('%d ', encoding)
    0 7 4 3 3 2 2 7 1 2 0 5 2 1 3 1 9 1 5 6 >> 


We can cross check that the length of the encoded sequence
is correct::

    >> total_symbols = sum(runs)
    total_symbols =

        35

We can check the length of the encoded sequence::

    >> >> numel(encoding)

    ans =

        20

It is indeed less than 35. The gain is not much
since there were many symbols with just one occurrence.


The decoding can be easily done using a for loop::

    x_dec = [];
    for i=1:numel(encoding) / 2
        symbol = encoding(i*2 -1);
        run_length = encoding(i*2);
        x_dec = [x_dec symbol * ones([1, run_length])];
    end

Let's print the decoded sequence::

    >> fprintf('%d ', x_dec);
    0 0 0 0 0 0 0 4 4 4 3 3 2 2 2 2 2 2 2 1 1 0 0 0 0 0 2 3 9 5 5 5 5 5 5 

Verify that the decoded sequence is indeed same as original
sequence::

    >> sum(x_dec - x)
    ans =

         0


The library provides useful methods for performing
run length encoding and decoding.

Encoding::

    >> x = [0 0 0 0 3 3 3 2 2];
    >> encoding = spx.dsp.runlength.encode(x)

    encoding =

         0     4     3     3     2     2
    
Decoding::

    >> spx.dsp.runlength.decode(encoding)

    ans =

         0     0     0     0     3     3     3     2     2

