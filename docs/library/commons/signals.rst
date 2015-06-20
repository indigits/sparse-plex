Signals
========================

Our focus is usually on finite 
dimensional signals. Such signals
are usually stored as column vectors
in MATLAB. A set of signals with same
dimensions can
be stored together in the form of
a matrix where each column of the matrix
is one signal.  Such a matrix of
signals is called a ``signal matrix``.

In this section we describe some
helper utility functions which provide
extra functionality on top of existing
support in MATLAB.

``SPX_Signals.findFirstLessEqEnergy`` 
finds the first signal in a signal matrix ``X``
with an energy less than or equal to 
a given ``threshold`` energy::

    [x, i] = SPX_Signals.findFirstLessEqEnergy(X, threshold);

``x`` is the first signal with energy less
than the given threshold. 
``i`` is the index of the column in ``X`` holding
this signal.


