#!/usr/bin/python3

import os, sys, re
from xml.etree import ElementTree

def get_tags(parent_node):
    result = {}
    for node in parent_node.getchildren():
        if node.tag != 'track':
            if node.tag not in result:
                result[node.tag] = [node.text]
            else:
                result[node.tag].append(node.text)
    return result

tree = ElementTree.parse('info.xml')
root = tree.getroot()

tracks = tree.findall('track')
albumTags = get_tags(root)
if not 'artist' in albumTags:
    albumTags['artist'] = ['Various']
albumTags['albumartist'] = albumTags['artist']

for arg in sys.argv[1:]:
    trackNum = re.match(r'\d{2}', arg)
    track = tracks[int(trackNum.group(0)) - 1]
    trackTags = get_tags(track)
    options = ""
    tagsAdded = {}
    for tagName, tagValues in trackTags.items():
        for tagValue in tagValues:
            tagString = tagName.upper() + '=' + tagValue.strip()
            options += '-t "' + tagString.replace('"', r'\"') + '" '
            tagsAdded[tagName] = 1
    for tagName, tagValues in albumTags.items():
        for tagValue in tagValues:
            if tagName not in tagsAdded:
                tagString = tagName.upper() + '=' + tagValue.strip()
                options += '-t "' + tagString.replace('"', r'\"') + '" '
    os.system('vorbiscomment -w ' + options + arg)
