#!/usr/bin/python3

import sys, os, re
from xml.dom import minidom

if len(sys.argv) == 1:
    print('Usage: {} <track> [...]\n'.format(os.path.basename(sys.argv[0])))
    sys.exit(1)

dom = minidom.parse('info.xml')
root = dom.documentElement
tracks = root.getElementsByTagName('track')

for arg in sys.argv[1:]:
    match = re.search(r'(\d\d).*\.(\w{3,4})$', arg)
    (num, ext) = match.group(1, 2)
    node = tracks.item(int(num) - 1)
    title = node.getElementsByTagName('title').item(0).firstChild.nodeValue
    title = re.sub(r'[][ ?!\'"():]', '_', title)
    title = re.sub(r'[,.]', '', title)
    title = re.sub(r'/', '--', title)
    title = re.sub(r'&', 'And', title)
    os.rename(arg, num + '-' + title + '.' + ext)
