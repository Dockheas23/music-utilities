#!/usr/bin/perl -w

use strict;
use CDDB_get "get_cddb";

my $filename = @ARGV == 0 ? "info.xml" : $ARGV[0];
open (OUTFILE, '>', $filename);
my %config;
$config{input}=1;

my %cd = get_cddb(\%config);

unless(defined $cd{title}) {
   die "no cddb entry found";
}

print(OUTFILE "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
print(OUTFILE "<disc>\n");
print(OUTFILE "<artist>$cd{artist}</artist>\n");
print(OUTFILE "<album>$cd{title}</album>\n");
print(OUTFILE "<genre>$cd{cat}</genre>\n");
print(OUTFILE "<date>TBC</date>\n");

my $i = 0;
foreach my $trackName (@{$cd{track}})
{
   print(OUTFILE "\n<track>\n");
   print(OUTFILE "<title>$trackName</title>\n");
   print(OUTFILE "<tracknumber>", ++$i, "</tracknumber>\n");
   print(OUTFILE "</track>\n");
}
print(OUTFILE "</disc>\n");
