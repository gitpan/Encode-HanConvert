#!/usr/local/bin/perl
# $File: //member/autrijus/Encode-HanConvert/bin/g2b.pl $ $Author: autrijus $
# $Revision: #2 $ $Change: 3341 $ $DateTime: 2002/03/03 21:43:55 $

$VERSION = '0.02';

=head1 NAME

b2g.pl, g2b.pl - Convert between GB2312 (EUC-CN) <=> Big5 conversion

=head1 SYNOPSIS

B<b2g.pl> [ I<file> ...]
B<g2b.pl> [ I<file> ...]

=head1 DESCRIPTION

The B<b2g.pl>/B<g2b.pl> utility reads files sequentially, convert them
between GB2312 and Big5, then writing them to the standard output.  The
file operands are processed in command-line order.  If file is a single
dash (C<->) or absent, this program reads from the standard input.

Example usage:

    % g2b.pl < gb2312.txt > big5.txt

=cut

use utf8;
use strict;
use Encode::HanConvert;

print_usage() if (grep /^-h/i, @ARGV);

if ($0 =~ /b2g[^\\\/]*$/i) {
    require Encode::CN;
    binmode STDIN, ':encoding(big5-simp)';
    binmode STDOUT, ':encoding(euc-cn)';
}
else {
    require Encode::TW;
    binmode STDIN, ':encoding(euc-cn-trad)';
    binmode STDOUT, ':encoding(big5)';
}

unshift(@ARGV, '-') unless @ARGV;

while (my $ARGV = shift) {
    open(STDIN, $ARGV);
    print <STDIN>;
}

sub print_usage {
    system("perldoc", $0);
}
