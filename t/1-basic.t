#!/usr/bin/perl -w

use blib;
use strict;
use Test::More tests => 5;
use Cwd qw|abs_path getcwd|;

my $cwd = getcwd();
my $path = abs_path($0);
$path =~ s/[\w\-]+.t$//i;

chdir($path);

no warnings 'internal';

use_ok('Encode::HanConvert');

is(big5_to_gb(_('daode.b5')), _('daode.gbk'), "big5_to_gb (function)");
is(gb_to_big5(_('daode.gbk')), _('daode_g.b5'), "gb_to_big5 (function)");

gb_to_big5($_ = _('zhengqi.gbk'));
is($_, _('zhengqi.b5'), "gb_to_big5 (inplace)");

big5_to_gb($_ = _('zhengqi.b5'));
is($_, _('zhengqi_b.gbk'), "big5_to_gb (inplace)");

$SIG{__DIE__} = \&cleanup;

cleanup();

sub cleanup { chdir($cwd) }
sub _ { local $/; open _, $_[0]; return <_> }
