#!/usr/bin/env perl
# $File: //member/autrijus/Encode-HanConvert/map/map2pm.pl $ $Author: autrijus $
# $Revision: #1 $ $Change: 3918 $ $DateTime: 2002/04/19 07:17:06 $

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
	    s/\\/\\\\/g;
	    s/^/'/;
	    s/ /' => '/;
	    s/$/',/;
	    print OUT $_;
	}
	close INC;
    }
}

close OUT;
