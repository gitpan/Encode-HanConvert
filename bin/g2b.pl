# $File: //member/autrijus/Encode-HanConvert/bin/g2b.pl $ $Author: autrijus $
# $Revision: #1 $ $Change: 3336 $ $DateTime: 2002/03/03 00:54:35 $

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
    print <<'.';
USAGE: b2g [OPTIONS] [FILES] [-]

  Reads Simplified Chinese text from FILES, and outputs Traditional Chinese.

USAGE: g2b [OPTIONS] [FILES] [-]

  Reads Traditional Chinese text from FILES, and outputs Simplified Chinese.

.
    exit;
}
