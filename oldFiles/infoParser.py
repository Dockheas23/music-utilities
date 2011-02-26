from xml.dom import minidom

class InfoParser:
    def __init__(self, infoFile):
        doc = minidom.parse(infoFile).documentElement
        aTags = {}
        tTags = {}
        for tag in doc.childNodes:
            if tag.nodeType == tag.ELEMENT_NODE:
                if tag.nodeName == "track":
                    num, tags = self.getTrack(tag)
                    tTags[num] = tags
                else:
                    if tag.nodeName not in aTags:
                        aTags[tag.nodeName] = set()
                    aTags[tag.nodeName].add(tag.firstChild.nodeValue)
        self.albumTags = aTags
        self.trackTags = tTags

    def getTrack(self, trackTag):
        tags = {}
        numTag = trackTag.getElementsByTagName("tracknumber").item(0)
        num = numTag.firstChild.nodeValue
        for tag in trackTag.childNodes:
            if tag.nodeType == tag.ELEMENT_NODE:
                if tag.nodeName not in tags:
                    tags[tag.nodeName] = set()
                tags[tag.nodeName].add(tag.firstChild.nodeValue)
        return num, tags
