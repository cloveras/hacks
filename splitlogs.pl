#!/usr/bin/perl -w 

# splitlogs.pl
# Loops through gzipped access logs, splits them into one log per username:
# access.log.1.gz, access.log.2.gz, etc -> access.log.2016-03-10.username1, access.log.2016-03-10.username2, etc  

use strict;
use POSIX qw(strftime);
use IO::Uncompress::Gunzip qw($GunzipError);

# All logs are in the same directory: access.log.1.gz, access.log.2.gz, etc

my @logs = glob "./access.log.*.gz";
my $log = undef;
my $verbose = 0;
my $user = "";
my %users = ();
my $zlog = undef;
my $today = strftime "%F", localtime;

foreach $log (@logs) {
    $zlog = IO::Uncompress::Gunzip->new($log) or die "IO::Uncompress::Gunzip failed: $GunzipError\n";
    while (<$zlog>) {
	$user = (split/\s+/)[2]; # Split by whitespace, use 3rd column.
	next if $user eq "-";
	$users{$user} += 1;
    }

    # Tell the human what is going on, and create separate logs.
    print "$log\n" if $verbose;
    foreach (sort keys %users) {
	print "\t$_: $users{$_}\n" if $verbose;	
	system("grep $_ $log > access.log.$today.$_");
    }
}
