#!/usr/bin/perl -w
# $File: //member/autrijus/Encode-HanConvert/t/1-basic.t $ $Author: autrijus $
# $Revision: #3 $ $Change: 3917 $ $DateTime: 2002/04/19 07:16:45 $

use strict;
use Test;
use File::Spec;
use File::Basename;

BEGIN { plan tests => 5 }

my $path = dirname($0);

$SIG{__WARN__} = sub {};

ok(eval 'use Encode::HanConvert; 1');

ok(big5_to_gb(_('daode.b5')), _('daode.gbk'));   # "big5_to_gb (function)"
ok(gb_to_big5(_('daode.gbk')), _('daode_g.b5')); # "gb_to_big5 (function)"

gb_to_big5($_ = _('zhengqi.gbk'));
ok($_, _('zhengqi.b5')); # "gb_to_big5 (inplace)"

big5_to_gb($_ = _('zhengqi.b5'));
ok($_, _('zhengqi_b.gbk')); # "big5_to_gb (inplace)"

sub _ { local $/; open _, File::Spec->catfile($path, $_[0]); return <_> }
