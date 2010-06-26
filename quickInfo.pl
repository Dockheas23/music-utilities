#!/usr/bin/perl -w

use strict;

my $interactive = "true" if (@ARGV == 0);

print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
print("<disc>\n");
print(STDERR "Enter artist: ") if ($interactive);

my $artist = <>;
chomp($artist);
print("<artist>$artist</artist>\n");
print(STDERR "Enter album: ") if ($interactive);

my $album = <>;
chomp($album);
print("<album>$album</album>\n");
print(STDERR "Enter genre: ") if ($interactive);

my $genre = <>;
chomp($genre);
print("<genre>$genre</genre>\n");
print(STDERR "Enter date: ") if ($interactive);

my $date = <>;
chomp($date);
print("<date>$date</date>\n");
print(STDERR "Enter discnumber (Leave blank if only one): ") if ($interactive);

my $disc = <>;
chomp($disc);
if ($disc ne "") {
   print("<discnumber>$disc</discnumber>\n");
   $disc = <> if (! $interactive);
}

print(STDERR "Enter each track name and press return (Ctrl-D when done)\n")
   if ($interactive);
my $i = 0;
while (<>) {
   chomp();
   print("\n<track>\n");
   print("<title>$_</title>\n");
   print("<tracknumber>", ++$i, "</tracknumber>\n");
   print("</track>\n");
}
print("</disc>\n");
