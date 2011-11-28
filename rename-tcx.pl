#!/usr/bin/perl -w
#
# Loops through all .tcx/.TCX files in the current directory, and renames them to YYYY-MM-DD-HHMMSS-Sport.tcx,
# where "Sport" is "Biking", "Other", etc as in the file.
# 
# Makes "YYYY/MM" directories and moves the files into them based on their date.
#
# Made as a quick hack, and I hope this is useful for someone.
# Christian Løverås (cl@superelectric.net)

use strict;
use File::Copy;

opendir(DIR, ".");
my @files = grep(/\.tcx$/i, readdir(DIR));
closedir(DIR);

my $file = undef;
my $sport;
my $file_new = undef;
my $year = undef;
my $month = undef;
my $cmd = undef;
my $counter = 0;

foreach $file (@files) {

    print "$file\n";
    unless (open(F, $file)) {
	warn $!;
	next;
    }
    while (<F>) {
	next unless /Activity Sport/;
	chomp;
	
	# Get activity type
	$_ =~ s/^.*Sport="(.*)".*/$1/; 
	$file_new = $_;
	print "\t$file_new\n";

	# Get date
	$_ = <F>;
	chomp;
	$_ =~ s/.*(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}).*/$1-$2-$3-$4$5$6/;
	$year = "$1";
	$month = "$2";
	$file_new = $_ . "-$file_new" . ".tcx";
    }
    close(F);
    
    # Create directory/directories
    unless (-d "$year") {
	mkdir "$year", 0755;
    }
    unless (-d "$year/$month") {
	mkdir "$year/$month", 0755;
    }

    # If this file seems to be a duplicate, add "duplicate" suffix.
    if (-e "$year/$month/$file_new") {
	$file_new .= "-duplicate";
    }
    
    # Move and rename file
    print "\tmove($file $year/$month/$file_new)\n";
    move("$file", "$year/$month/$file_new");      
    
}
