Getting Started
================================


Requirements
---------------------------

While much of the library can be used on stock MATLAB
distribution with standard toolboxes, some parts of
the library are dependent on some specific third party
libraries. These dependencies are explained below.

MATLAB toolboxes

* Signal processing toolbox
* Image processing toolbox
* Statistics toolbox
* Optimization toolbox


Third party library dependencies

* CVX http://cvxr.com/cvx/





Installation
---------------------

* Download ``sparse-plex`` library from http://indigits.github.io/sparse-plex/.
* Unzip it in a suitable folder.
* Add following commands to your MATLAB startup script:

  * Change directory to the root directory of ``sparse-plex``.
  * Run ``spx_setup`` function.
  * Change back to whatever directory you want to be in.

Getting acquainted
---------------------------

The online library documentation includes a number of step-by-step
demonstrations. Follow these tutorials to get familiar with the
library.

Running examples
----------------------

* Change directory to the root directory of ``sparse-plex``.
* Go into ``examples`` directory.
* Browse the examples.
* Run the example you want.

Checking the source code
-----------------------------

* Change directory to the root directory of ``sparse-plex``.
* Go into ``library`` directory.
* Browse the source code.



Verifying the installation
----------------------------------

You will require MATLAB XUnit test framework to run the unit tests
included with the library.

* Change directory to the root directory of ``sparse-plex``.
* Execute the ``run_all_unit_tests.m`` script.
* Verify that all unit tests pass.


Building documentation
------------------------------

Only if you really want to do it!

You will require Python Sphinx and other related packages like
Pygments library etc. to build the documentation from scratch.

* Change directory to the root directory of ``sparse-plex``.
* Go into ``docs`` directory.
* Build the documentation using Sphinx tool chain. 