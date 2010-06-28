#!/usr/bin/perl -w

# Convert filenames having the track number as the first two numbers in the
# filename with track names from the file 'info.xml' in the current
# directory with the structure
#
# <disc>
#    <album-wide tags>
#    <track>
#       <title>...<title>
#       <track-specific tags>
#    </track>
#    ...
# </disc>

use strict;
use XML::LibXML;

if (@ARGV eq 0)
{
   print "Usage: $0 <track> [...]\n";
   exit(1);
}

my $file = 'info.xml';
my $parser = XML::LibXML->new();
my $tree = $parser->parse_file($file);

my $root = $tree->getDocumentElement();
my @tracks = $root->getChildrenByTagName("track");

for (@ARGV)
{
   chomp();
   /([0-9][0-9]).*\.([A-Za-z0-9]{3,4})$/;
   my @titleNodes = $tracks[$1 - 1]->getChildrenByTagName("title");
   my $title = $titleNodes[0]->firstChild->nodeValue;
   my $num = $1;
   my $ext = $2;
   $title =~ s/[][ ?!'"():]/_/g;
   $title =~ s/[,.]//g;
   $title =~ s@/@--@g;
   $title =~ s/&/And/g;
   rename("$_", "$num-$title.$ext");
}
