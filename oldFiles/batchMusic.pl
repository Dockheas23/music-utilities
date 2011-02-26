#!/usr/bin/perl -w

my @initialPaths;
for (@ARGV) {
    chomp($currentDirectory = `pwd`);
    push(@initialPaths, /^[^\/]/ ? ($currentDirectory . "/" . $_) : $_);
}
batchRun(@initialPaths);

sub batchRun {
    for (@_) {
	chomp();
	if (/^(.*)\.flac$/) {
	    flac2mp4($_);
	}
	elsif (-d) {
	    my $fullPath = $_;
	    chomp($directoryName = `basename $_`);
	    mkdir($directoryName);
	    chdir($directoryName);
	    my @filesInDirectory = `ls $fullPath`;
	    s/(.*)/$fullPath\/$1/ for @filesInDirectory;
	    batchRun(@filesInDirectory);
	    chdir("..");
	}
    }
}

sub flac2mp4 {
    for (@_) {
	my $outputFile = `basename $_`;
	$outputFile =~ s/flac$/m4a/;
	chomp($outputFile);
	my $artist = `metaflac --show-tag=ARTIST "$_"`;
	$artist =~ s/^ARTIST=//;
	chomp($artist);
	my $album = `metaflac --show-tag=ALBUM "$_"`;
	$album =~ s/^ALBUM=//;
	chomp($album);
	my $genre = `metaflac --show-tag=GENRE "$_"`;
	$genre =~ s/^GENRE=//;
	chomp($genre);
	my $year = `metaflac --show-tag=DATE "$_"`;
	$year =~ s/^DATE=//;
	chomp($year);
	my $title = `metaflac --show-tag=TITLE "$_"`;
	$title =~ s/^TITLE=//;
	chomp($title);
	my $track = `metaflac --show-tag=TRACKNUMBER "$_"`;
	$track =~ s/^TRACKNUMBER=//;
	chomp($track);
	`flac -dcs "$_" | faac -o "$outputFile" --artist "$artist" \\
	--album "$album" --genre "$genre" --year "$year" --title "$title" \\
	--track "$track" -`;
    }
}
