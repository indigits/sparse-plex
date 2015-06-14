% The library contains several unit tests written using
% XUnit test framework. To execute these tests, the
% library must be installed.
close all; clear all; clc;
globals = spx_setup();
cd (fullfile(globals.commons, 'tests'));
runtests;

cd (fullfile(globals.dictionary, 'tests'));
runtests;


% Finally return to the main directory
cd(globals.root);
