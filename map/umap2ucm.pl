#!/usr/bin/perl
# $File: //member/autrijus/Encode-HanConvert/map/umap2ucm.pl $ $Author: autrijus $
# $Revision: #2 $ $Change: 3939 $ $DateTime: 2003/01/27 22:52:26 $

use strict;
use Encode 1.41;
use File::Spec;
use File::Basename;

my $path = dirname($0);
conv(File::Spec->catdir($path, 'b2g_map.txt') => 'trad-simp', 'gbk', 'big5');
conv(File::Spec->catdir($path, 'g2b_map.txt') => 'simp-trad', 'big5', 'gbk');

sub conv {
    my ($src, $target, $enc, $fenc) = @_;
    my %count;

    open IN, $src or die $!;
    open OUT, ">$target.ucm" or die $!;

    print OUT << ".";
# This is generated from $src -- please change that file instead.
# Yes, this .ucm map is not round-trip safe; HanConvert is a lossy operation.
<code_set_name> "$target"
.
    print OUT +HEADER();
    print OUT +B5HEADER() unless $target =~ /gbk/i;

    <IN>; <IN>;
    while (<IN>) {
	my $uchar = decode($enc, substr($_, 3, 2)) or next;
	my $fchar = encode_utf8(decode($fenc, substr($_, 0, 2))) or next;
	printf OUT "<U%04X> %s |%u\n",
		   ord($uchar),
		   join('', map sprintf('\\x%02X', ord($_)), split('', $fchar)),
		   0;	# XXX - suggestions welcome to the fallback char here
    }

    print OUT +B5FOOTER() unless $target =~ /gbk/i;
    print OUT +FOOTER();

    close OUT;
    close IN;
}

use constant HEADER => << '.';
<mb_cur_min> 1
<mb_cur_max> 2
<subchar> \x3F
#
CHARMAP
<U0000> \x00 |0 # NULL
<U0001> \x01 |0 # START OF HEADING
<U0002> \x02 |0 # START OF TEXT
<U0003> \x03 |0 # END OF TEXT
<U0004> \x04 |0 # END OF TRANSMISSION
<U0005> \x05 |0 # ENQUIRY
<U0006> \x06 |0 # ACKNOWLEDGE
<U0007> \x07 |0 # BELL
<U0008> \x08 |0 # BACKSPACE
<U0009> \x09 |0 # HORIZONTAL TABULATION
<U000A> \x0A |0 # LINE FEED
<U000B> \x0B |0 # VERTICAL TABULATION
<U000C> \x0C |0 # FORM FEED
<U000D> \x0D |0 # CARRIAGE RETURN
<U000E> \x0E |0 # SHIFT OUT
<U000F> \x0F |0 # SHIFT IN
<U0010> \x10 |0 # DATA LINK ESCAPE
<U0011> \x11 |0 # DEVICE CONTROL ONE
<U0012> \x12 |0 # DEVICE CONTROL TWO
<U0013> \x13 |0 # DEVICE CONTROL THREE
<U0014> \x14 |0 # DEVICE CONTROL FOUR
<U0015> \x15 |0 # NEGATIVE ACKNOWLEDGE
<U0016> \x16 |0 # SYNCHRONOUS IDLE
<U0017> \x17 |0 # END OF TRANSMISSION BLOCK
<U0018> \x18 |0 # CANCEL
<U0019> \x19 |0 # END OF MEDIUM
<U001A> \x1A |0 # SUBSTITUTE
<U001B> \x1B |0 # ESCAPE
<U001C> \x1C |0 # FILE SEPARATOR
<U001D> \x1D |0 # GROUP SEPARATOR
<U001E> \x1E |0 # RECORD SEPARATOR
<U001F> \x1F |0 # UNIT SEPARATOR
<U0020> \x20 |0 # SPACE
<U0021> \x21 |0 # EXCLAMATION MARK
<U0022> \x22 |0 # QUOTATION MARK
<U0023> \x23 |0 # NUMBER SIGN
<U0024> \x24 |0 # DOLLAR SIGN
<U0025> \x25 |0 # PERCENT SIGN
<U0026> \x26 |0 # AMPERSAND
<U0027> \x27 |0 # APOSTROPHE
<U0028> \x28 |0 # LEFT PARENTHESIS
<U0029> \x29 |0 # RIGHT PARENTHESIS
<U002A> \x2A |0 # ASTERISK
<U002B> \x2B |0 # PLUS SIGN
<U002C> \x2C |0 # COMMA
<U002D> \x2D |0 # HYPHEN-MINUS
<U002E> \x2E |0 # FULL STOP
<U002F> \x2F |0 # SOLIDUS
<U0030> \x30 |0 # DIGIT ZERO
<U0031> \x31 |0 # DIGIT ONE
<U0032> \x32 |0 # DIGIT TWO
<U0033> \x33 |0 # DIGIT THREE
<U0034> \x34 |0 # DIGIT FOUR
<U0035> \x35 |0 # DIGIT FIVE
<U0036> \x36 |0 # DIGIT SIX
<U0037> \x37 |0 # DIGIT SEVEN
<U0038> \x38 |0 # DIGIT EIGHT
<U0039> \x39 |0 # DIGIT NINE
<U003A> \x3A |0 # COLON
<U003B> \x3B |0 # SEMICOLON
<U003C> \x3C |0 # LESS-THAN SIGN
<U003D> \x3D |0 # EQUALS SIGN
<U003E> \x3E |0 # GREATER-THAN SIGN
<U003F> \x3F |0 # QUESTION MARK
<U0040> \x40 |0 # COMMERCIAL AT
<U0041> \x41 |0 # LATIN CAPITAL LETTER A
<U0042> \x42 |0 # LATIN CAPITAL LETTER B
<U0043> \x43 |0 # LATIN CAPITAL LETTER C
<U0044> \x44 |0 # LATIN CAPITAL LETTER D
<U0045> \x45 |0 # LATIN CAPITAL LETTER E
<U0046> \x46 |0 # LATIN CAPITAL LETTER F
<U0047> \x47 |0 # LATIN CAPITAL LETTER G
<U0048> \x48 |0 # LATIN CAPITAL LETTER H
<U0049> \x49 |0 # LATIN CAPITAL LETTER I
<U004A> \x4A |0 # LATIN CAPITAL LETTER J
<U004B> \x4B |0 # LATIN CAPITAL LETTER K
<U004C> \x4C |0 # LATIN CAPITAL LETTER L
<U004D> \x4D |0 # LATIN CAPITAL LETTER M
<U004E> \x4E |0 # LATIN CAPITAL LETTER N
<U004F> \x4F |0 # LATIN CAPITAL LETTER O
<U0050> \x50 |0 # LATIN CAPITAL LETTER P
<U0051> \x51 |0 # LATIN CAPITAL LETTER Q
<U0052> \x52 |0 # LATIN CAPITAL LETTER R
<U0053> \x53 |0 # LATIN CAPITAL LETTER S
<U0054> \x54 |0 # LATIN CAPITAL LETTER T
<U0055> \x55 |0 # LATIN CAPITAL LETTER U
<U0056> \x56 |0 # LATIN CAPITAL LETTER V
<U0057> \x57 |0 # LATIN CAPITAL LETTER W
<U0058> \x58 |0 # LATIN CAPITAL LETTER X
<U0059> \x59 |0 # LATIN CAPITAL LETTER Y
<U005A> \x5A |0 # LATIN CAPITAL LETTER Z
<U005B> \x5B |0 # LEFT SQUARE BRACKET
<U005C> \x5C |0 # REVERSE SOLIDUS
<U005D> \x5D |0 # RIGHT SQUARE BRACKET
<U005E> \x5E |0 # CIRCUMFLEX ACCENT
<U005F> \x5F |0 # LOW LINE
<U0060> \x60 |0 # GRAVE ACCENT
<U0061> \x61 |0 # LATIN SMALL LETTER A
<U0062> \x62 |0 # LATIN SMALL LETTER B
<U0063> \x63 |0 # LATIN SMALL LETTER C
<U0064> \x64 |0 # LATIN SMALL LETTER D
<U0065> \x65 |0 # LATIN SMALL LETTER E
<U0066> \x66 |0 # LATIN SMALL LETTER F
<U0067> \x67 |0 # LATIN SMALL LETTER G
<U0068> \x68 |0 # LATIN SMALL LETTER H
<U0069> \x69 |0 # LATIN SMALL LETTER I
<U006A> \x6A |0 # LATIN SMALL LETTER J
<U006B> \x6B |0 # LATIN SMALL LETTER K
<U006C> \x6C |0 # LATIN SMALL LETTER L
<U006D> \x6D |0 # LATIN SMALL LETTER M
<U006E> \x6E |0 # LATIN SMALL LETTER N
<U006F> \x6F |0 # LATIN SMALL LETTER O
<U0070> \x70 |0 # LATIN SMALL LETTER P
<U0071> \x71 |0 # LATIN SMALL LETTER Q
<U0072> \x72 |0 # LATIN SMALL LETTER R
<U0073> \x73 |0 # LATIN SMALL LETTER S
<U0074> \x74 |0 # LATIN SMALL LETTER T
<U0075> \x75 |0 # LATIN SMALL LETTER U
<U0076> \x76 |0 # LATIN SMALL LETTER V
<U0077> \x77 |0 # LATIN SMALL LETTER W
<U0078> \x78 |0 # LATIN SMALL LETTER X
<U0079> \x79 |0 # LATIN SMALL LETTER Y
<U007A> \x7A |0 # LATIN SMALL LETTER Z
<U007B> \x7B |0 # LEFT CURLY BRACKET
<U007C> \x7C |0 # VERTICAL LINE
<U007D> \x7D |0 # RIGHT CURLY BRACKET
<U007E> \x7E |0 # TILDE
<U007F> \x7F |0 # DELETE
<U0080> \x80 |0 # <control>
.

use constant B5HEADER => << '.';
<U0081> \x81 |0 # <control>
<U0082> \x82 |0 # BREAK PERMITTED HERE
<U0083> \x83 |0 # NO BREAK HERE
<U0084> \x84 |0 # <control>
<U0085> \x85 |0 # NEXT LINE
<U0086> \x86 |0 # START OF SELECTED AREA
<U0087> \x87 |0 # END OF SELECTED AREA
<U0088> \x88 |0 # CHARACTER TABULATION SET
<U0089> \x89 |0 # CHARACTER TABULATION WITH JUSTIFICATION
<U008A> \x8A |0 # LINE TABULATION SET
<U008B> \x8B |0 # PARTIAL LINE DOWN
<U008C> \x8C |0 # PARTIAL LINE UP
<U008D> \x8D |0 # REVERSE LINE FEED
<U008E> \x8E |0 # SINGLE SHIFT TWO
<U008F> \x8F |0 # SINGLE SHIFT THREE
<U0090> \x90 |0 # DEVICE CONTROL STRING
<U0091> \x91 |0 # PRIVATE USE ONE
<U0092> \x92 |0 # PRIVATE USE TWO
<U0093> \x93 |0 # SET TRANSMIT STATE
<U0094> \x94 |0 # CANCEL CHARACTER
<U0095> \x95 |0 # MESSAGE WAITING
<U0096> \x96 |0 # START OF GUARDED AREA
<U0097> \x97 |0 # END OF GUARDED AREA
<U0098> \x98 |0 # START OF STRING
<U0099> \x99 |0 # <control>
<U009A> \x9A |0 # SINGLE CHARACTER INTRODUCER
<U009B> \x9B |0 # CONTROL SEQUENCE INTRODUCER
<U009C> \x9C |0 # STRING TERMINATOR
<U009D> \x9D |0 # OPERATING SYSTEM COMMAND
<U009E> \x9E |0 # PRIVACY MESSAGE
<U009F> \x9F |0 # APPLICATION PROGRAM COMMAND
<U00A0> \xA0 |0 # NO-BREAK SPACE
.

use constant B5FOOTER => << '.';
<U00FA> \xFA |0 # LATIN SMALL LETTER U WITH ACUTE
<U00FB> \xFC |0 # LATIN SMALL LETTER U WITH CIRCUMFLEX
<U00FD> \xFD |0 # LATIN SMALL LETTER Y WITH ACUTE
<U00FE> \xFE |0 # LATIN SMALL LETTER THORN
.

use constant FOOTER => << '.';
<U00FF> \xFF |0 # LATIN SMALL LETTER Y WITH DIAERESIS
END CHARMAP
.
