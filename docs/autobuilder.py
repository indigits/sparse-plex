"""
Builds the documentation automatically on file change!
"""

import time, os, sys
import imp
import signal, subprocess
import ctypes

# Hashmap to keep track of the file modification time
_mtimes = {}

# Lets watch only for these extensions (only a handful of files)
_watchext = [".rst"]
_watchlist = []
_ignores = ()
_modpath = os.getcwd ()


def walk_callback (arg, dirname, fnames):
    """ Callback from file tree walk (os.path.walk) """
    for i in fnames:
        if ".svn" in dirname or ".git" in dirname:
            # lets just ignore any .svn or .git folders in the codebase
            continue
        ignore_file = False
        for ignore in _ignores:
            if ignore in dirname:
                #print "Ignoring:", os.path.join (dirname, i)
                ignore_file = True
                break
        if ignore_file:
            continue
        file, ext = os.path.splitext (i)
        if ext in _watchext:
            _watchlist.append ( os.path.join (dirname, i) )
            pass

def prepare_watchlist():
    # reset the list of watched files
    _watchlist = []
    # fill the list of watched files
    os.path.walk (_modpath, walk_callback, _modpath)


def code_changed ():
    """ Monitors the code change """
    global _mtimes
    for filename in _watchlist:
        stat = os.stat(filename)
        mtime = stat.st_mtime
        if os.name == "nt":
            mtime -= stat.st_ctime
        if filename not in _mtimes:
            _mtimes[filename] = mtime
            continue
        if mtime != _mtimes[filename]:
            _mtimes = {}
            return True
    return False


def load ():
    """ Load the builder, should work on Windows as well """
    # This is not a good idea since if I am doing editing and suddenly this code runs
    if sys.platform == 'win32':
        os.system (r"buildhtml.bat")
        pass
    else:
        os.system ("sphinx-build -b html . ./_html")


if __name__ == "__main__":
    # we prepare a fresh list of files to be wached
    prepare_watchlist()
    print "Watching for changes..."
    while True:
        try:
            if code_changed ():
                # we rebuild the documentation
                load ()
                # we prepare the list of files to be watched again
                # this is necessary since new files may have been introduced since last build.
                prepare_watchlist()
            time.sleep (1)
        except KeyboardInterrupt:
            print "\nQuitting!"
            sys.exit (0)

