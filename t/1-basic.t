#!/usr/bin/perl -w
# $File: //member/autrijus/Encode-HanConvert/t/1-basic.t $ $Author: autrijus $
# $Revision: #3 $ $Change: 2675 $ $DateTime: 2002/12/11 16:37:28 $

use strict;
use Test;
use File::Spec;
use File::Basename;

#BEGIN { plan tests => ($] >= 5.006 ? 9 : 5) }
BEGIN { plan tests => 5 }

my $path = dirname($0);

$SIG{__WARN__} = sub {};

ok(eval 'use Encode::HanConvert::Perl; 1');

ok(big5_to_gb(_('daode.b5')), _('daode.gbk'));   # "big5_to_gb (function)"
ok(gb_to_big5(_('daode.gbk')), _('daode_g.b5')); # "gb_to_big5 (function)"

gb_to_big5($_ = _('zhengqi.gbk'));
ok($_, _('zhengqi.b5')); # "gb_to_big5 (inplace)"

big5_to_gb($_ = _('zhengqi.b5'));
ok($_, _('zhengqi_b.gbk')); # "big5_to_gb (inplace)"

exit;

exit unless $] >= 5.006;

ok(trad_to_simp(_('daode.b5u')), _('daode.gbku'));   # "trad_to_simp (function)"
ok(simp_to_trad(_('daode.gbku')), _('daode_g.b5u')); # "simp_to_trad (function)"
exit;

simp_to_trad($_ = _('zhengqi.gbku'));
ok($_, _('zhengqi.b5u')); # "simp_to_trad (inplace)"

trad_to_simp($_ = _('zhengqi.b5u'));
ok($_, _('zhengqi_b.gbku')); # "trad_to_simp (inplace)"

sub _ { local $/; open _, File::Spec->catfile($path, $_[0]); return <_> }
