#!/usr/bin/perl -w

# Adds vorbis comments to arguments (.flac files) with the current directory
# containing a file 'info.xml' having the following structure,
#
# <disc>
#    <album-wide tags>
#    <track>
#       <track-specific tags>
#    </track>
#    ...
# </disc>

use strict;
use XML::LibXML;

my $file = 'info.xml';
my $parser = XML::LibXML->new();
my $tree = $parser->parse_file($file);

my $root = $tree->getDocumentElement();
my @tracks = $root->getElementsByTagName("track");
my @tags;

foreach my $node ($root->childNodes) {
   if ($node->nodeType != 3 && $node->nodeName ne "track") {
      my $tagName = uc($node->nodeName);
      my $tagValue = $node->firstChild->nodeValue;
      $tagValue =~ s/["\$\\]/\\$&/g;   # To allow special chars in tags
      push @tags, $tagName, $tagValue;
   }
}

foreach (@ARGV) {
   my $trackNum;
   my $options;
   my %tagsAdded;
   my @trackTags;
   my @albumTags = @tags;

   chomp();
   ($trackNum) = /^([0-9]{2})-.*$/;
   $trackNum =~ s/^0//;
   my $track = $tracks[$trackNum - 1];
   foreach my $node ($track->childNodes) {
      if ($node->nodeType != 3) {
	 my $tagName = uc($node->nodeName);
	 my $tagValue = $node->firstChild->nodeValue;
	 $tagValue =~ s/["\$\\]/\\$&/g;   # To allow special chars in tags
	 push @trackTags, $tagName, $tagValue;
      }
   }
   while ((my $tagName = shift @trackTags) &&
      (my $tagValue = shift @trackTags)) {
	 $options .= "--set-tag=\"$tagName=$tagValue\" ";
	 $tagsAdded{$tagName} = 1;
   }
   while ((my $tagName = shift @albumTags) &&
      (my $tagValue = shift @albumTags)) {
      if (! exists($tagsAdded{$tagName})) {   # track tags override album tags
	 $options .= "--set-tag=\"$tagName=$tagValue\" ";
      }
   }
   `metaflac $options \"$_\"`;
}
