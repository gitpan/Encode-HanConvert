#!/usr/bin/env perl
# $File: //member/autrijus/Encode-HanConvert/map/map2pm.pl $ $Author: autrijus $
# $Revision: #2 $ $Change: 647 $ $DateTime: 2002/08/15 15:17:46 $

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
	open INC, File::Spec->catdir($path, $1) or die $!;
	<INC>; <INC>;
	while (<INC>) {
	    $_ = substr($_, 0, 5);
	    s/\\/\\\\\\/g;
	    s/^/'/;
	    s/ /' => '/;
	    s/$/',/;
	    print OUT $_, "\n";
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
