#!/usr/local/bin/perl
# $File: //member/autrijus/Encode-HanConvert/bin/b2g.pl $ $Author: autrijus $
# $Revision: #9 $ $Change: 3948 $ $DateTime: 2003/01/27 23:57:50 $

$VERSION = '0.09';

=head1 NAME

b2g.pl - Traditional to Simplified Chinese converter

=head1 SYNOPSIS

B<b2g.pl> [ B<-p> ] [ B<-u> ] [ I<inputfile> ...] > I<outputfile>

=head1 USAGE

    % b2g.pl -p < big5.txt > gbk.txt
    % b2g.pl -pu < trad.txt > simp.txt

=head1 DESCRIPTION

The B<b2g.pl> utility reads files sequentially, converts them from
Traditional to Simplified Chinese, then writes them to the standard
output.  The I<inputfile> arguments are processed in command-line order.
If I<inputfile> is a single dash (C<->) or absent, this program reads
from the standard input.

The C<-p> switch enables rudimentary phrase-oriented substition via a
small built-in lexicon.

The C<-u> switch specifies that both the input and output streams should
be UTF-8 encoded.  If not specified, the input stream is assumed to be
in Big5, and the output will be encoded in GBK.

=head1 CAVEATS

In pure-perl implementations (pre-5.8 perl or without a C compiler),
C<-p> and C<-u> cannot be used together.

=cut

use strict;
use Getopt::Std;

sub MAP ();

my %opts;
BEGIN {
    getopts('hup', \%opts);
    if ($opts{h}) { system("perldoc", $0); exit }
    $SIG{__WARN__} = sub {};
}

use constant UTF8 => $opts{u};
use constant DICT => ($opts{p} and (!UTF8 or $] >= 5.008));

use Encode::HanConvert;

if (UTF8 and $] >= 5.008) { binmode(STDIN, ':utf8'); binmode(STDOUT, ':utf8') }

my $KEYS = join('|', sort { length($b) <=> length($a) } keys %{+MAP}) if DICT;
my $MAP  = +MAP if DICT;

while (<>) {
    if (UTF8) { Encode::HanConvert::trad_to_simp($_) }
	 else { Encode::HanConvert::big5_to_gb($_) }
    if (DICT) { s/($KEYS)/$MAP->{$1}/g }
    print;
}

use constant MAP => DICT && {
    map { UTF8 ? Encode::decode(gbk => $_) : $_ } (
'乙太' => '以太',
'乙太网路' => '以太网络',
'九九乘法表' => '九九表',
'中断点' => '断点',
'介面' => '接口',
'元件' => '组件',
'公事包' => '公文包',
'升等考试' => '升级考试',
'升幂' => '升序',
'太空人' => '航天员',
'太空衣' => '宇宙飞行服',
'太空梭' => '航天飞机',
'太空船' => '宇宙飞船',
'戈巴契夫' => '戈尔巴乔夫',
'户口名簿' => '户口簿',
'支援' => '支持',
'文件夹' => '活页夹',
'日尔曼民族' => '日耳曼民族',
'比萨斜塔' => '比塞塔',
'火拼' => '火并',
'片语' => '词组',
'功能表' => '菜单',
'包谷' => '苞谷',
'史达林' => '斯大林',
'外太空' => '外层空间',
'布希' => '布什',
'平行作业' => '并行操作',
'平行埠' => '并行端口',
'平行线' => '并行线',
'幼稚园' => '幼儿园',
'母音' => '元音',
'资料' => '数据',
'休士顿' => '休斯敦',
'仲介' => '中介',
'光碟机' => '光驱',
'全形' => '全角',
'共用' => '共享',
'冰棒' => '棒冰',
'列印' => '打印',
'印表机' => '打印机',
'向光性' => '向旋光性',
'因数' => '因子',
'回圈' => '循环',
'回应' => '响应',
'多明尼加' => '多米尼加',
'字串' => '字符串',
'字首' => '前缀',
'存档' => '存盘',
'安甯' => '安宁',
'收银机' => '收款机',
'羽量级' => '轻量级',
'衣索比亚' => '埃塞俄比亚',
'西元' => '公元',
'位址' => '地址',
'伫列' => '队列',
'佐证' => '左证',
'伺服器' => '服务器',
'作业系统' => '操作系统',
'伯明罕' => '伯明翰',
'低阶语言' => '低级语言',
'即时' => '实时',
'吸光性' => '吸旋光性',
'困在' => '捆在',
'困来困去' => '捆来捆去',
'困暸' => '捆了',
'宏都拉斯' => '洪都拉斯',
'序列埠' => '串行端口',
'沙拉油' => '色拉油',
'沙乌地阿拉伯' => '沙特阿拉伯',
'沈括' => '沉括',
'身历声' => '立体声',
'防写' => '写保护',
'来福线' => '来复线',
'其他' => '其它',
'协定' => '协议',
'卷轴' => '滚动条',
'周边' => '外围',
'屈光性' => '屈旋光性',
'注脚' => '脚注',
'注解' => '批注',
'物件' => '对象',
'知识份子' => '知识分子',
'矽石' => '硅石',
'矽晶片' => '硅芯片',
'矽电晶体' => '硅晶体管',
'空白键' => '空格键',
'邱吉尔' => '丘吉尔',
'门迳' => '门径',
'阿姆斯壮' => '阿姆斯特朗',
'阿斯匹灵' => '阿司匹林',
'南瓜' => '番瓜',
'指标' => '指针',
'括弧' => '括号',
'映射' => '映像',
'畏光性' => '畏旋光性',
'相容' => '兼容',
'耶诞节' => '圣诞节',
'背光性' => '背旋光性',
'计时器' => '定时器',
'计程车' => '出租车',
'计算机' => '计算器',
'迪斯可' => '迪斯科',
'重播' => '回放',
'食具' => '餐具',
'倒楣' => '倒霉',
'倡狂' => '猖狂',
'候机室' => '候机楼',
'套装软体' => '软件包',
'座标' => '坐标',
'弱光性' => '弱旋光性',
'浮水印' => '水印',
'乌沈沈' => '乌沉沉',
'破音字' => '多音字',
'秘笈' => '秘籍',
'索马利亚' => '索马里',
'航太总署' => '航天总署',
'草菴' => '草庵',
'记忆体' => '内存',
'酒齇鼻' => '酒齄鼻',
'阵列' => '数组',
'偺们' => '咱们',
'副程式' => '子程序',
'副档名' => '扩展名',
'啦啦队' => '拉拉队',
'唯读' => '只读',
'堆叠' => '堆栈',
'专案' => '项目',
'常式' => '例程',
'康乃狄格' => '康涅狄克',
'捷径' => '快捷方式',
'扫描器' => '扫描仪',
'启动' => '激活',
'毫安培' => '毫安',
'毕氏定理' => '勾股定理',
'毕卡索' => '毕加索',
'莫札特' => '莫扎特',
'软片' => '胶卷',
'通讯录' => '通讯簿',
'通道' => '信道',
'连线' => '联机',
'速食' => '快餐',
'钗钸' => '钗钚',
'阴沈沈' => '阴沉沉',
'顶呱呱' => '顶刮刮',
'麻塞诸塞' => '马萨诸塞',
'麻痹不暸' => '麻痹不了',
'晶片' => '芯片',
'智慧' => '智能',
'游标' => '光标',
'番茄' => '西红柿',
'登出' => '注销',
'硬体' => '硬件',
'程式' => '程序',
'程序控制' => '过程控制',
'答录机' => '录音机',
'答覆' => '答复',
'结夥' => '结伙',
'菸毒' => '烟毒',
'视窗' => '窗口',
'象模象样' => '像模象样',
'超连结' => '超级链接',
'邮递区号' => '邮政编码',
'黑沈沈' => '黑沉沉',
'乱数' => '随机数',
'汇流排' => '总线',
'塑胶' => '塑料',
'奥克拉荷马州' => '俄克拉荷马州',
'奥会' => '奥委会',
'感光性' => '感旋光性',
'新罕布夏' => '新罕布什尔',
'暗沈沈' => '暗沉沉',
'滑鼠' => '鼠标',
'义大利' => '意大利',
'圣地牙哥' => '圣地亚哥',
'解析度' => '分辨率',
'解码' => '译码',
'试算表' => '电子表格',
'资讯' => '信息',
'载入' => '加载',
'运算元' => '操作数',
'运算式' => '表达式',
'钜富' => '巨富',
'闸道' => '网关',
'雷射印表机' => '激光打印机',
'雷根' => '里根',
'电晶体' => '晶体管',
'电传视讯' => '图文电视',
'电脑' => '计算机',
'电脑程式' => '计算机程序',
'电锅' => '电饭锅',
'图示' => '图标',
'惨澹' => '惨淡',
'摺合' => '折合',
'演算法' => '算法',
'磁片' => '磁盘',
'磁轨' => '磁道',
'磁区' => '扇区',
'磁碟' => '磁盘',
'磁碟机' => '磁盘驱动器',
'磁碟档' => '磁盘文件',
'碳粉匣' => '墨粉盒',
'福马林' => '福尔马林',
'管龠' => '管钥',
'网路' => '网络',
'蒐购' => '搜购',
'宾士' => '奔驰',
'赫鲁雪夫' => '赫鲁晓夫',
'远端' => '远程',
'凤梨' => '菠萝',
'徵收' => '征收',
'数据机' => '调制解调器',
'暂存器' => '缓存器',
'标签' => '卷标',
'模组' => '模块',
'模拟' => '仿真',
'模拟计算机' => '仿真计算器',
'磐石' => '盘石',
'范本' => '模板',
'糊里糊涂' => '胡里胡涂',
'糊涂' => '胡涂',
'线上作业' => '联机操作',
'赐諡' => '赐谥',
'遮罩' => '屏蔽',
'醉薰薰' => '醉熏熏',
'墨沈沈' => '墨沉沉',
'壁报' => '墙报',
'暸如' => '了如',
'积体电路' => '集成电路',
'萤幕' => '屏幕',
'谘询' => '咨询',
'诺曼地' => '诺曼底',
'诺曼第' => '诺曼底',
'录影' => '录像',
'趋光性' => '趋旋光性',
'鍊钢' => '炼钢',
'锺县' => '钟县',
'霜淇淋' => '冰淇淋',
'渖阳' => '沈阳',
'简报' => '演示文稿',
'藉机' => '借机',
'薰天' => '熏天',
'转捩点' => '转折点',
'杂讯' => '噪声',
'鼕鼕' => '冬冬',
'罗布林卡' => '罗布尔卡',
'罗德岛' => '罗得岛',
'识别字' => '标识符',
'跷课' => '逃课',
'辞汇' => '词汇',
'关键字' => '关键词',
'类比' => '模拟',
'麴菌' => '曲菌',
'携带型' => '便携式',
'栏位' => '字段',
'镭射' => '激光',
'权杖' => '令牌',
'读卡机' => '卡片阅读机',
'佘太君' => '畲太君',
'氂牛' => '牦牛',
'衚同' => '胡同',
'擣衣' => '捣衣',
) };

__END__

=head1 SEE ALSO

L<g2b.pl>, L<Encode::HanConvert>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, 2003 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
