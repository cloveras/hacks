#!/usr/bin/perl -w 

# splitlogs.pl
# Loops through gzipped access logs, splits them into one log per username:
# access.log.1.gz, access.log.2.gz, etc -> access.log.2016-03-10.username1, access.log.2016-03-10.username2, etc  

use strict;
use POSIX qw(strftime);
use IO::Uncompress::Gunzip qw($GunzipError);

# All logs are in the same directory: access.log.1.gz, access.log.2.gz, etc
my @logs = glob "./access.log.*.gz";
my $verbose = 0;
my $log = undef;
my $zlog = undef;
my $user = undef;
my %users = ();
my $today = strftime "%F", localtime;

# Loop through all logs, check every line..
foreach $log (@logs) {
    $zlog = IO::Uncompress::Gunzip->new($log) or die "$log: $GunzipError\n";
    while (<$zlog>) {
	$user = (split/\s+/)[2]; # Split by whitespace, username is 3rd item.
	next if $user eq "-"; # Skip lines without username.
	$users{$user} += 1; #Increment for this user.
    }

    # Create the new per-user access log.
    print "$log\n" if $verbose;
    foreach (sort keys %users) {
	print "\t$_: $users{$_}\n" if $verbose;	# Tell the human what is going on: Username and count.
	system("grep $_ $log > access.log.$today.$_"); # Quick and dirty..
    }
}
