#!/usr/bin/perl
# $File: //member/autrijus/Encode-HanConvert/map/map2pm.pl $ $Author: autrijus $
# $Revision: #6 $ $Change: 4445 $ $DateTime: 2003/02/27 12:09:56 $

use strict;
use File::Spec;
use File::Basename;

my $path = dirname($0);

open IN, File::Spec->catfile(
    $path, qw(.. lib Encode HanConvert Perl.pm-orig),
) or die $!;

open OUT, '>'. File::Spec->catfile(
    $path, qw(.. lib Encode HanConvert Perl.pm),
) or die $!;

while (<IN>) {
    print OUT $_;
    if (/### include (\S+)/) {
	my $file = $1;
	my $is_utf8 = ($file =~ /utf8/);
	open INC, File::Spec->catdir($path, $file) or die $!;
	<INC>; <INC>;
	while (<INC>) {
	    $_ = substr($_, 0, 5) . "\n" unless $is_utf8;
	    s/\\/\\\\\\/g;
	    s/^/'/;
	    s/ /', '/;
	    s/$/',/;
	    print OUT $_;
	}
	close INC;
    }
    elsif (/### perl (\S+) ###/) {
	print OUT "=begin comment\n" unless $] >= $1;
    }
    elsif (/### \/perl (\S+) ###/) {
	print OUT "=end comment\n=cut\n" unless $] >= $1;
    }
}

close OUT;
