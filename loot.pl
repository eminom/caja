#!/usr/bin/perl -w

use 5.022;
use warnings;
use strict;
use File::Basename;

my $addr = $ARGV[0] // "myhost:16666";

sub sacarUn{
	my $name = shift || die "no input file";
	my $bname = basename($name);

	if($bname =~ m/^\~\$/){
		#say "bingo";
		return "echo { $bname }";
	}
	return "sacar -r -bind :8800 -addr ${addr} \"${name}\" 2>/dev/null";
}

sub isException{
	my $name = shift || die;
	return $name =~ /(\.log|\.tlog|\.sdf|\.obj|\.exe|\.ilk|\.pdb)$/imxs;
}

my $cmd = sacarUn("<?>");
my @out = `$cmd`;
die "list file info failed" if $?;

for my$f(@out){
	chomp($f);
	my $cmd = sacarUn($f);
	next if isException($f);
	say $f;

	`$cmd`;
	die "cannot download $f" if $?;
}

say "done";



