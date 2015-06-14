% The library contains several unit tests written using
% XUnit test framework. To execute these tests, the
% library must be installed.

globals = spx_setup();
cd (fullfile(globals.commons, 'tests'));
runtests;

% Finally return to the main directory
cd(globals.spx);
