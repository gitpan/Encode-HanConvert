# $File: //member/autrijus/Encode-HanConvert/HanConvert.pm $ $Author: autrijus $
# $Revision: #5 $ $Change: 3369 $ $DateTime: 2002/03/06 12:27:48 $

package Encode::HanConvert;
use 5.007002;

our $VERSION = '0.03';
our @EXPORT = qw(
    big5_to_gb trad_to_simp big5_to_simp gb_to_trad big5_to_trad gb_to_simp
    gb_to_big5 simp_to_trad simp_to_big5 trad_to_gb trad_to_big5 simp_to_gb
);

our @EXPORT_OK = qw(simple trad);

no warnings 'redefine';

use base 'Exporter';
use Encode qw|encode decode from_to|;
use XSLoader;

XSLoader::load('Encode::HanConvert',$VERSION);

sub big5_to_gb ($) {
    local $^W; # shuts Encode::HZ's redefine warnings up
    require Encode::CN;

    local $_[0] = $_[0] if defined wantarray;
    from_to($_[0], 'big5-simp' => 'cp936');
    return $_[0];
}

sub gb_to_big5 ($) {
    require Encode::TW;

    local $_[0] = $_[0] if defined wantarray;
    from_to($_[0], 'gbk-trad' => 'big5');
    return $_[0];
}

sub trad_to_simp ($) {
    local $^W;
    require Encode::CN;

    return decode('cp936', encode('gbk-trad', $_[0]))
	if (defined wantarray);

    $_[0] = decode('cp936', encode('gbk-trad', $_[0]));
}

sub simp_to_trad ($) {
    require Encode::TW;

    return decode('big5', encode('big5-simp', $_[0]))
	if (defined wantarray);

    $_[0] = decode('big5', encode('big5-simp', $_[0]));
}

sub big5_to_simp ($) {
    return decode('big5-simp', $_[0]) if (defined wantarray);
    $_[0] = decode('big5-simp', $_[0]);
}

sub simp_to_big5 ($) {
    return encode('big5-simp', $_[0]) if (defined wantarray);
    $_[0] = encode('big5-simp', $_[0]);
}

sub gb_to_trad ($) {
    return decode('gbk-trad', $_[0]) if (defined wantarray);
    $_[0] = decode('gbk-trad', $_[0]);
}

sub trad_to_gb ($) {
    return encode('gbk-trad', $_[0]) if (defined wantarray);
    $_[0] = encode('gbk-trad', $_[0]);
}

# For completeness' sake...

sub big5_to_trad ($) {
    require Encode::TW;
    return decode('big5', $_[0]) if (defined wantarray);
    $_[0] = decode('big5', $_[0]);
}

sub trad_to_big5 ($) {
    require Encode::TW;
    return encode('big5', $_[0]) if (defined wantarray);
    $_[0] = encode('big5', $_[0]);
}

sub gb_to_simp ($) {
    local $^W;
    require Encode::CN;
    return decode('cp936', $_[0]) if (defined wantarray);
    $_[0] = decode('cp936', $_[0]);
}

sub simp_to_gb ($) {
    local $^W;
    require Encode::CN;
    return encode('cp936', $_[0]) if (defined wantarray);
    $_[0] = encode('cp936', $_[0]);
}

# Lingua::ZH::HanConvert drop-in replacement -- not exported by default

sub trad { simp_to_trad($_[0]) };
sub simple { trad_to_simp($_[0]) };

1;

__END__

=head1 NAME

Encode::HanConvert - Traditional and Simplified Chinese mappings

=head1 VERSION

This document describes version 0.03 of Encode::HanCovert, released
March 7, 2002.

=head1 SYNOPSIS

As command line utilities:

B<b2g.pl> [ I<inputfile> ...] > I<outputfile>

B<g2b.pl> [ I<inputfile> ...] > I<outputfile>

In your program:

    use Encode::HanConvert; # needs perl 5.7.2 or better

    # Conversion between Chinese encodings
    $euc_cn = big5_to_gb($big5); # Big5 to GBK
    $big5 = gb_to_big5($euc_cn); # GBK to Big5

    # Conversion between Perl's Unicode strings
    $simp = trad_to_simp($trad); # Traditional to Simplified
    $trad = simp_to_trad($simp); # Simplified to Traditional

    # Conversion between Chinese encoding and Unicode strings
    $simp = big5_to_simp($big5); # Big5 to Simplified
    $big5 = simp_to_big5($simp); # Simplified to Big5
    $trad = gb_to_trad($euc_cn); # GBK to Traditional
    $euc_cn = trad_to_gb($trad); # Traditional to GBK

    # For completeness' sake... (no conversion, just encode/decode)
    $simp = gb_to_simp($euc_cn); # GBK to Simplified
    $euc_cn = simp_to_gb($simp); # Simplified to GBK
    $trad = big5_to_trad($big5); # Big5 to Traditional
    $big5 = trad_to_big5($trad); # Traditional to Big5

    # All functions may be used in void context to transform $_[0]
    big5_to_gb($string); # transform $string from big5 to gb

    # Drop-in replacement functions for Lingua::ZH::HanConvert
    use Encode::HanConvert qw(trad simple); # not exported by default

    $simp = simple($trad); # Traditional to Simplified
    $trad = trad($simp);   # Simplified to Traditional

=head1 DESCRIPTION

This module is an attempt to solve most common problems occured in
Traditional vs. Simplified Chinese conversion, in an efficient,
flexible way, without resorting to external tools or modules.

After installing this module, you'll have two additional encoding
formats: 'big5-simp' maps Big5 into Unicode's Simplified Chinese
(and vice versa), and 'gbk-trad' maps CP936 (better known as GBK)
into Unicode's Traditional Chinese and back.

The module exports various C<xxx_to_yyy> functions by default, where
xxx and yyy are one of C<big5>, C<gb> (GBK/CP936), C<simp> (simplified
Chinese unicode), or C<trad> (traditional Chinese unicode).

You may also import C<simple> and C<trad>, which are aliases for
C<simp_to_trad> and C<trad_to_simp>; this is provided as a drop-in
replacement for programs using L<Lingua::ZH::HanConvert>.

Since this is built on L<Encode>'s architecture, you may also use
the line discipline syntax to perform the conversion implicitly
(before 5.7.3, you need to use 'cp936' in place of 'gbk'):

    require Encode::CN;
    open BIG5, ':encoding(big5-simp)', 'big5.txt';  # as simplified
    open EUC,  '>:encoding(gbk)',      'gbk.txt';   # as gbk
    print EUC, <BIG5>;

    require Encode::TW;
    open EUC,  ':encoding(gbk-trad)',  'gbk.txt';   # as traditional
    open BIG5, '>:encoding(big5)',     'big5.txt';  # as big-5
    print BIG5, <EUC>;

Or, more interestingly:

    use encoding 'big5-simp';
    print "¤¤¤å"; # prints simplified chinese in unicode

=head1 COMPARISON

Although L<Lingua::ZH::HanConvert> module already provides mapping
between Simplified and Traditional Unicode characters, it depend on
other modules (L<Text::Iconv> or L<Encode>) to provide the necessary
mapping with B<Big5> and B<GBK> encodings.

Also, L<Encode::HanConvert> loads up much faster:

    0.148u 0.046s 0:00.19 94.7% # Encode::HanConvert
    7.096u 0.015s 0:07.23 98.2% # Lingua::ZH::HanConvert (v0.12)

The difference in actual conversion is much higher. Use 32k text of
trad=>simp as an example:

    0.082u 0.031s 0:00.12 91.6% # iconv | b2g | iconv
    0.324u 0.015s 0:00.35 94.2% # Encode::HanConvert
   23.715u 0.054s 0:24.51 96.9% # Lingua::ZH::HanConvert (v0.12)

The C<b2g> above refers to Yeung and Lee's HanZi Converter, an external
utility that maps big5 to gb2312 and back; C<iconv> refers to GNU
libiconv. If you don't mind the overhead of calling external process,
their result is nearly identical with this module.

=head1 CAVEATS

Please note that from versino 0.03 and above, this module support the
more expressive range B<GBK> instead of B<EUC-CN>. This may cause
incompatibilities with older fonts. Existing program should rename
C<euc-cn-trad> into C<gbk-trad>; sorry for the inconvenience.

This module does not preserve one-to-many mappings; it blindly chooses
the most frequently used substitutions, instead of presenting the user
multiple choices. This can be remedied by a dictionary-based post
processor that restores the correct character.

=head1 ACKNOWLEDGEMENTS

The conversion table used in this module comes from various sources,
including B<Lingua::ZH::HanConvert> by David Chan, B<hc> by Ricky
Yeung & Fung F. Lee, and B<Doggy Chinese Big5-GB Conversion Master>
from Doggy Digital Creative Inc. (L<http://www.miniasp.com/>).

The F<*.enc> files are checked against test files generated by GNU
libiconv with kind permission from Bruno Haible. The F<compile> and
F<encode.h> are lifted from the B<Encode> distribution, which is
part of the standard perl distribution.

Kudos to Nick Ing-Simmons, Dan Kogai and Jarkko Hietaniemi for 
showing me how to use B<Encode> and PerlIO. Thanks!

=head1 SEE ALSO

L<Encode>, L<Lingua::ZH::HanConvert>, L<Text::Iconv>

The F<b2g.pl> and F<g2b.pl> utilities installed with this module.

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2002 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
