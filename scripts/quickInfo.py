#!/usr/bin/python3

import sys
from xml.dom import minidom

xmlDoc = minidom.getDOMImplementation().createDocument(None, 'disc', None)
rootNode = xmlDoc.documentElement

for tagName in ['artist', 'album', 'genre', 'date', 'discnumber']:
    print('Enter', tagName + ': ', file=sys.stderr)
    tagValue = sys.stdin.readline().strip()
    if tagValue != "":
        newNode = rootNode.appendChild(xmlDoc.createElement(tagName))
        newNode.appendChild(xmlDoc.createTextNode(tagValue))

print('Enter each track name and press return (Ctrl-D when done)',
        file=sys.stderr)
tracks = sys.stdin.readlines()
for i in range(len(tracks)):
    trackTag = rootNode.appendChild(xmlDoc.createElement('track'))
    titleTag = trackTag.appendChild(xmlDoc.createElement('title'))
    trackNumTag = trackTag.appendChild(xmlDoc.createElement('tracknumber'))
    trackNumTag.appendChild(xmlDoc.createTextNode(str(i + 1)))
    titleTag.appendChild(xmlDoc.createTextNode(tracks[i].strip()))

xmlDoc.writexml(sys.stdout, addindent='    ', newl='\n', encoding='utf-8')
