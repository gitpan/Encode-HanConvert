#!/usr/local/bin/perl
# $File: //member/autrijus/Encode-HanConvert/bin/g2b.pl $ $Author: autrijus $
# $Revision: #6 $ $Change: 3917 $ $DateTime: 2002/04/19 07:16:45 $

$VERSION = '0.04';

=head1 NAME

g2b.pl - Convert from GBK (CP936) to Big5

=head1 SYNOPSIS

B<g2b.pl> [ I<inputfile> ...] > I<outputfile>

=head1 DESCRIPTION

The B<b2g.pl>/B<g2b.pl> utility reads files sequentially, convert them
between GBK and Big5, then writing them to the standard output.  The
file operands are processed in command-line order.  If file is a single
dash (C<->) or absent, this program reads from the standard input.

Example usage:

    % g2b.pl < gbk.txt > big5.txt

=cut

use strict;

(system("perldoc", $0), exit) if (grep /^-h/i, @ARGV);

$SIG{__WARN__} = sub {};

require Encode::HanConvert;
while (<>) { Encode::HanConvert::gb_to_big5($_); print }

__END__

=head1 SEE ALSO

L<b2g.pl>, L<Encode::HanConvert>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2002 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
