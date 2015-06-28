# This script summarizes the contents of the library
import os
from os import path 

# our imports
import pathsetup

text_files = 0
matlab_files = 0
num_classes = 0
num_functions = 0
num_scripts = 0
num_unit_tests = 0
classes = []
functions = []
unit_tests = []
scripts = []

for root, dirs, files in os.walk(pathsetup.library_dir):
    if 'bin' in dirs:
        dirs.remove('bin')  # don't visit bin directories
    for filename in files:
        filepath = path.join(root, filename);
        filename, extn = path.splitext(filename);
        if extn == '.m':
            matlab_files += 1
            if filename.startswith('test_'):
                num_unit_tests += 1
                unit_tests.append(filepath)
            else:
                mfile = open(filepath)
                detected  = False
                for line in mfile:
                    if 'classdef' in line:
                        num_classes += 1
                        detected = True
                        classes.append(filename)
                        break
                    elif 'function' in line:
                        num_functions += 1
                        functions.append(filename)
                        detected = True
                        break
                if not detected:
                    num_scripts += 1
                    scripts.append(filepath)

        elif extn == '.txt':
            text_files += 1

print 'Library directory: %s' % pathsetup.library_dir
print 'Text files: %d' % text_files
print 'Matlab files: %d' % matlab_files
print 'Classes: %d' % num_classes
print 'Functions: %d' % num_functions
print 'Unit test files: %d' % num_unit_tests
print 'Scripts: %d' % num_scripts

classes.sort()
functions.sort()
scripts.sort()
unit_tests.sort()

print '\nClasses:\n'
for classname in classes:
    print classname
print '\nFunctions: \n'
for funcname in functions:
    print funcname
print '\nScripts:\n'
for script_path in scripts:
    print script_path

print '\nUnit tests:\n'
for ut_path in unit_tests:
    print ut_path



