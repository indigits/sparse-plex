Scripts
================

.. highlight:: matlab


Preamble
-------------------

::
    
    close all; clear all; clc;

Resetting random numbers::

    
    rng('default');


Export management flag::

    export = true;


Figures
---------------

Creating the figure manager::

    mf = MultiFigures();

Creating a figure::

    mf.newFigure('Example faces');


Exporting figures::

    if export
    export_fig images\figure_name.png -r120 -nocrop;
    export_fig images\figure_name.pdf;
    end


Typical steps in figures::

    xlabel('Principal angle (degrees)');
    ylabel('Number of subspace pairs');
    title('Distribution of principal angles over subspace pairs in signal space');
    grid on;