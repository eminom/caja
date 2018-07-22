#!/usr/bin/env perl -w
use 5.022;
use strict;
use warnings;
use POSIX ":sys_wait_h";
use Time::HiRes qw ( time alarm sleep );

sub doElicit{
	my $name = shift // die "no input";
	my $cmd = "sacar -o outx -r \"$name\" 2>/dev/null";
	my @out = `$cmd`;
	die "error on <$name>: $?" if $?;
	@out;
}

my $startT = time;
my @files = doElicit("<?>");
my $factor = 4;
if($#ARGV>=0){
	$factor = int($ARGV[0]);
	say "using factor $factor";
}
sub goOne{
	my $f = shift // die "not f present";
	for(0..$#files){
		my $a = $files[$_];
		chomp($a);
		if($_ % $factor == $f){
			doElicit($a);
			say $a;
		}
	}
}

my @pids;
for(0..$factor-1){
	defined(my $pid = fork) or die "cannot fork";
	unless($pid){
		goOne($_);
		exit;
	}
	push @pids, $pid;
}

#say "wait for all.";
for(@pids){
	waitpid($_, 0);
	die "error code: $?" if $?;
}

say "time elapsed:", time() - $startT;
my $count = $#files + 1;
say "$count file(s) downloaded";

