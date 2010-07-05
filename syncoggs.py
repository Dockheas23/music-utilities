#!/usr/bin/python3

import glob, os, shutil, sys
from os.path import exists, splitext, dirname, getmtime, join

flacs = os.path.expanduser('~/Music/FLAC_Music')
oggs = os.path.expanduser('~/Music/Ogg_Music')

# Change values for sourcedir and destdir if supplied on command line
try:
    flacs = sys.argv[1]
    oggs = sys.argv[2]
except IndexError:
    pass

os.chdir(flacs)
for filename in glob.iglob('*/*/*.flac'):
    sourcedir = dirname(filename)
    oggfilename = join(oggs, splitext(filename)[0] + '.ogg')
    destdir = dirname(oggfilename)
    if not exists(destdir):
        shutil.copytree(sourcedir, destdir)
        for flacfile in glob.iglob()
    if not exists(oggfilename) or getmtime(filename) > getmtime(oggfilename):
        print('XXX: ' + filename + ' needs to be refreshed')
