#!/usr/bin/python3

import sys, os, re
from xml.dom import minidom

if len(sys.argv) == 1:
    print('Usage: {} <track> [...]\n'.format(os.path.basename(sys.argv[0])))
    sys.exit(1)

ORIGINAL_DIR = os.getcwd()

# Replacements for special characters in filenames
substitutions = [ # (pattern, replacement)
        (r'[][ ?!\'"():]', '_'),
        (r'[,.]', ''),
        (r'/', '--'),
        (r'&', 'And'),
        ]

dirs = {os.path.dirname(x) for x in sys.argv[1:]}
files = {d:
        [os.path.basename(f) for f in sys.argv[1:] if os.path.dirname(f) == d]
        for d in dirs}

for directory, fileList in files.items():
    if directory != '': os.chdir(directory)
    try:
        dom = minidom.parse('info.xml')
    except IOError:
        print("Error opening info.xml in directory ", d, file=sys.stderr)
    root = dom.documentElement
    tracks = root.getElementsByTagName('track')
    for fileName in fileList:
        match = re.search(r'(\d\d).*\.(\w{3,4})$', fileName)
        num, ext = match.group(1, 2)
        node = tracks.item(int(num) - 1).getElementsByTagName('title').item(0)
        title = node.firstChild.nodeValue.strip()
        for pattern, replacement in substitutions:
            title = re.sub(pattern, replacement, title)
        os.rename(fileName, num + '-' + title + '.' + ext)

os.chdir(ORIGINAL_DIR)
