#!/usr/bin/python3

import os, sys, re
from xml.etree import ElementTree

tree = ElementTree.parse('info.xml')
root = tree.getroot()

tracks = tree.findall('track')
albumTags = {node.tag: node.text for node in root.getchildren()
        if node.tag != 'track'}

for arg in sys.argv[1:]:
    trackNum = re.match(r'\d{2}', arg)
    track = tracks[int(trackNum.group(0)) - 1]
    trackTags = {node.tag: node.text for node in track.getchildren()}
    options = ""
    tagsAdded = {}
    for tagName, tagValue in trackTags.items():
        options += '--set-tag="' + tagName.upper() + '=' + tagValue + '" '
        tagsAdded[tagName] = 1
    for tagName, tagValue in albumTags.items():
        if tagName not in tagsAdded:
            options += '--set-tag="' + tagName.upper() + '=' + tagValue + '" '
    os.system('metaflac ' + options + arg)
