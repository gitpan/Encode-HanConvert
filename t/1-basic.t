#!/usr/bin/perl -w
# $File: //member/autrijus/Encode-HanConvert/t/1-basic.t $ $Author: autrijus $
# $Revision: #3 $ $Change: 3917 $ $DateTime: 2002/04/19 07:16:45 $

use strict;
use Test::More tests => 5;
use File::Spec;
use File::Basename;

my $path = dirname($0);

$SIG{__WARN__} = sub {};

use_ok('Encode::HanConvert');

is(big5_to_gb(_('daode.b5')), _('daode.gbk'), "big5_to_gb (function)");
is(gb_to_big5(_('daode.gbk')), _('daode_g.b5'), "gb_to_big5 (function)");

gb_to_big5($_ = _('zhengqi.gbk'));
is($_, _('zhengqi.b5'), "gb_to_big5 (inplace)");

big5_to_gb($_ = _('zhengqi.b5'));
is($_, _('zhengqi_b.gbk'), "big5_to_gb (inplace)");

sub _ { local $/; open _, File::Spec->catfile($path, $_[0]); return <_> }
