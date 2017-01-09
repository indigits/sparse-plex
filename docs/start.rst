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
* LRS library https://github.com/andrewssobral/lrslibrary
* Wavelab http://statweb.stanford.edu/~wavelab/
* 

We repeat that only some parts of the library and 
examples depend on the third party libraries. You
can install them on need basis. You don't need to
install them in advance.



Installation
---------------------

* Download ``sparse-plex`` library from http://indigits.github.io/sparse-plex/.
* Unzip it in a suitable folder.
* Add following commands to your MATLAB startup script:

  * Change directory to the root directory of ``sparse-plex``.
  * Run ``spx_setup`` function.
  * Change back to whatever directory you want to be in.

.. note::

    Make sure that MATLAB has write permissions to
    the directory in which you install sparse-plex.
    Some functions in sparse-plex create  
    some MAT files for caching
    of intermediate results. 
    Moreover, the sparse-plex setup script also
    creates a local settings file. For creating these
    files, write access is needed.

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
  
  * The source code for ``spx`` library is maintained in ``+spx`` directory.
  * Unit-tests for the library are maintained in ``tests`` directory.




Verifying the installation
----------------------------------

You will require MATLAB XUnit test framework to run the unit tests
included with the library.

* Change directory to the root directory of ``sparse-plex``.
* Move to the directory ``library\\tests``.
* Execute the ``runalltests.m`` script.
* Verify that all unit tests pass.

Configuring test data directories
----------------------------------------

Several examples in sparse-plex are developed
on top of standard data sets. These include
(but not limited to):

* Standard test images
* Yale Extended B Faces database (cropped images)

In order to execute these examples, access to the
data is needed. The data is not distributed along
with this software. You can download data and store
it on your computer wherever you wish. In order
to provide access to this data, you need to tell
sparse-plex where does the data lie. This can
be done by changing ``spx_local.ini`` file. 
When you download and unzip the library, this file
doesn't exist. When you run ``spx_setup``, ``spx_defaults.ini`` is copied into ``spx_local.ini``. 

All you need to do is to point to the right directories
which hold the test datasets.

Specific settings in ``spx_local.ini`` are:

* ``standard_test_images_dir``
* ``yale_faces_db_dir``

For more information, read the file.

Building documentation
------------------------------

Only if you really want to do it!

You will require Python Sphinx and other related packages like
Pygments library etc. to build the documentation from scratch.

* Change directory to the root directory of ``sparse-plex``.
* Go into ``docs`` directory.
* Build the documentation using Sphinx tool chain. 