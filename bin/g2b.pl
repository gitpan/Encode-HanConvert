#!/usr/local/bin/perl
# $File: //member/autrijus/Encode-HanConvert/bin/g2b.pl $ $Author: autrijus $
# $Revision: #8 $ $Change: 3946 $ $DateTime: 2003/01/27 23:50:51 $

$VERSION = '0.09';

=head1 NAME

g2b.pl - Simplified to Traditional Chinese converter

=head1 SYNOPSIS

B<g2b.pl> [ B<-p> ] [ B<-u> ] [ I<inputfile> ...] > I<outputfile>

=head1 USAGE

    % g2b.pl -p < gbk.txt > big5.txt
    % g2b.pl -pu < simp.txt > trad.txt

=head1 DESCRIPTION

The B<g2b.pl> utility reads files sequentially, converts them from
Simplified to Traditional Chinese, then writes them to the standard
output.  The I<inputfile> arguments are processed in command-line order.
If I<inputfile> is a single dash (C<->) or absent, this program reads
from the standard input.

The C<-p> switch enables rudimentary phrase-oriented substition via a
small built-in lexicon.

The C<-u> switch specifies that both the input and output streams should
be UTF-8 encoded.  If not specified, the input stream is assumed to be
in GBK, and the output will be encoded in Big5.

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
    if (UTF8) { Encode::HanConvert::simp_to_trad($_) }
	 else { Encode::HanConvert::gb_to_big5($_) }
    if (DICT) { s/($KEYS)/$MAP->{$1}/g }
    print;
}

use constant MAP => DICT && {
    map { UTF8 ? Encode::decode(big5 => $_) : $_ } (
'乙太' => '以太',
'乙太網路' => '以太網絡',
'九九乘法表' => '九九表',
'八尺' => '八呎',
'丫杈' => '枒杈',
'中斷點' => '斷點',
'介胄' => '介冑',
'介面' => '接口',
'元件' => '組件',
'公事包' => '公文包',
'升等考試' => '升級考試',
'升冪' => '升序',
'厄困' => '阨困',
'太空人' => '航天員',
'太空衣' => '宇宙飛行服',
'太空梭' => '航天飛機',
'太空船' => '宇宙飛船',
'戈巴契夫' => '戈爾巴喬夫',
'戶口名簿' => '戶口簿',
'支援' => '支持',
'文件夾' => '活頁夾',
'日爾曼民族' => '日耳曼民族',
'比薩斜塔' => '比塞塔',
'火拼' => '火並',
'片語' => '詞組',
'功\能表' => '菜單',
'包谷' => '苞谷',
'史達林' => '斯大林',
'外太空' => '外層空間',
'它們' => '牠們',
'布希' => '布什',
'平行作業' => '並行操作',
'平行埠' => '並行端口',
'平行線' => '並行線',
'幼稚園' => '幼兒園',
'母音' => '元音',
'資料' => '數據',
'休士頓' => '休斯敦',
'仲介' => '中介',
'光碟機' => '光驅',
'全形' => '全角',
'共用' => '共享',
'冰棒' => '棒冰',
'列印' => '打印',
'印表機' => '打印機',
'向光性' => '向旋光性',
'因數' => '因子',
'迴圈' => '循環',
'回應' => '響應',
'多明尼加' => '多米尼加',
'字串' => '字符串',
'字首' => '前綴',
'存檔' => '存盤',
'收銀機' => '收款機',
'羽量級' => '輕量級',
'衣索比亞' => '埃塞俄比亞',
'西元' => '公元',
'位址' => '地址',
'佇列' => '隊列',
'佐証' => '左証',
'伺服器' => '服務器',
'作業系統' => '操作系統',
'伯明罕' => '伯明翰',
'低階語言' => '低級語言',
'即時' => '實時',
'吸光性' => '吸旋光性',
'宏都拉斯' => '洪都拉斯',
'序列埠' => '串行端口',
'弄堂' => '衖堂',
'沙拉油' => '色拉油',
'沙烏地阿拉伯' => '沙特阿拉伯',
'沈括' => '沉括',
'豆蔻' => '荳蔻',
'身歷聲' => '立體聲',
'防寫' => '寫保護',
'來福線' => '來複線',
'其他' => '其它',
'協定' => '協議',
'卷軸' => '滾動條',
'周邊' => '外圍',
'屈光性' => '屈旋光性',
'拓碑' => '搨碑',
'注腳' => '腳注',
'注解' => '批注',
'炕床' => '匟床',
'物件' => '對象',
'狎玩' => '狎翫',
'知識份子' => '知識分子',
'矽石' => '硅石',
'矽晶片' => '硅芯片',
'矽電晶體' => '硅晶體管',
'空白鍵' => '空格鍵',
'邱吉爾' => '丘吉爾',
'門逕' => '門徑',
'阿姆斯壯' => '阿姆斯特朗',
'阿斯匹靈' => '阿司匹林',
'剃刀' => '薙刀',
'南瓜' => '番瓜',
'屎蚵螓' => '屎蚵蜋',
'指標' => '指針',
'括弧' => '括號',
'斫輪老手' => '斲輪老手',
'映射' => '映像',
'畏光性' => '畏旋光性',
'相容' => '兼容',
'耶誕節' => '聖誕節',
'背光性' => '背旋光性',
'英寸' => '英吋',
'計時器' => '定時器',
'計程車' => '出租車',
'計算機' => '計算器',
'迪斯可' => '迪斯科',
'重播' => '回放',
'食具' => '餐\具',
'倒楣' => '倒霉',
'候機室' => '候機樓',
'套裝軟體' => '軟件包',
'座標' => '坐標',
'弱光性' => '弱旋光性',
'扇開' => '搧開',
'捂住' => '摀住',
'挪搓' => '挼搓',
'海里' => '海浬',
'浮水印' => '水印',
'烏丘' => '烏坵',
'烏沈沈' => '烏沉沉',
'破音字' => '多音字',
'秘笈' => '秘籍',
'索馬利亞' => '索馬里',
'脆髒' => '脺髒',
'胳膊' => '肐膊',
'胯骨' => '骻骨',
'航太總署' => '航天總署',
'草菴' => '草庵',
'記憶體' => '內存',
'酒齇鼻' => '酒皻鼻',
'陣列' => '數組',
'鬼蜮' => '鬼魊',
'副程式' => '子程序',
'副檔名' => '擴展名',
'啦啦隊' => '拉拉隊',
'唯讀' => '只讀',
'堆疊' => '堆棧',
'專案' => '項目',
'常式' => '例程',
'康乃狄格' => '康涅狄克',
'捷徑' => '快捷方式',
'掃描器' => '掃描儀',
'啟動' => '激活',
'畢氏定理' => '勾股定理',
'畢卡索' => '畢加索',
'粕酵' => '醱酵',
'莫札特' => '莫扎特',
'蛋民' => '蜑民',
'軟片' => '膠卷',
'通訊錄' => '通訊簿',
'通道' => '信道',
'連線' => '聯機',
'速食' => '快餐\',
'釵鈽' => '釵鐶',
'陰沈沈' => '陰沉沉',
'頂呱呱' => '頂刮刮',
'麻子' => '痲子',
'麻塞諸塞' => '馬薩諸塞',
'麻痺不暸' => '痲痺不了',
'喧嘩' => '諠嘩',
'捶胸' => '搥胸',
'敦敦' => '惇惇',
'敦睦' => '惇睦',
'晶片' => '芯片',
'智慧' => '智能',
'游標' => '光標',
'無妄之災' => '旡妄之災',
'番茄' => '西紅柿',
'登出' => '注銷',
'硬體' => '硬件',
'程式' => '程序',
'程序控制' => '過程控制',
'答錄機' => '錄音機',
'答覆' => '答複',
'筋斗' => '觔斗',
'結夥' => '結伙',
'腆臉' => '靦臉',
'菸毒' => '煙毒',
'視窗' => '窗口',
'超連結' => '超級鏈接',
'郵遞區號' => '郵政編碼',
'黑沈沈' => '黑沉沉',
'亂數' => '隨機數',
'匯流排' => '總線',
'塑膠' => '塑料',
'奧克拉荷馬州' => '俄克拉荷馬州',
'奧會' => '奧委會',
'感光性' => '感旋光性',
'新罕布夏' => '新罕布什爾',
'暗沈沈' => '暗沉沉',
'溯氣' => '沴氣',
'滑鼠' => '鼠標',
'義大利' => '意大利',
'聖地牙哥' => '聖地亞哥',
'解析度' => '分辨率',
'解碼' => '譯碼',
'試算表' => '電子表格',
'資訊' => '信息',
'載入' => '加載',
'運算元' => '操作數',
'運算式' => '表達式',
'逾年' => '踰年',
'遁世' => '遯世',
'鉅富' => '巨富',
'閘道' => '網關',
'雷射印表機' => '激光打印機',
'雷根' => '里根',
'電晶體' => '晶體管',
'電傳視訊' => '圖文電視',
'電腦' => '計算機',
'電腦程式' => '計算機程序',
'電鍋' => '電飯鍋',
'嘍羅' => '嘍囉',
'圖示' => '圖標',
'慘澹' => '慘淡',
'摺合' => '折合',
'槍口' => '鎗口',
'演算法' => '算法',
'漁瘟' => '漁塭',
'熔岩' => '鎔岩',
'磁片' => '磁盤',
'磁軌' => '磁道',
'磁區' => '扇區',
'磁碟' => '磁盤',
'磁碟機' => '磁盤驅動器',
'磁碟檔' => '磁盤文件',
'碳粉匣' => '墨粉盒',
'福馬林' => '福爾馬林',
'管龠' => '管鑰',
'網路' => '網絡',
'矇矇朧朧' => '蒙蒙矓矓',
'矇朧' => '蒙矓',
'蒐購' => '搜購',
'賓士' => '奔馳',
'赫魯雪夫' => '赫魯曉夫',
'遠端' => '遠程',
'鳳梨' => '菠蘿',
'麼妹' => '么\妹',
'麼麼唱唱' => '么\么\唱唱',
'徵收' => '征收',
'數據機' => '調制解調器',
'暫存器' => '緩存器',
'標簽' => '卷標',
'模組' => '模塊',
'模擬' => '仿真',
'模擬計算機' => '仿真計算器',
'磐石' => '盤石',
'範本' => '模板',
'糊里糊塗' => '胡里胡塗',
'糊塗' => '胡塗',
'線上作業' => '聯機操作',
'賜諡' => '賜謚',
'踢踏舞' => '踢躂舞',
'適才' => '適纔',
'遮罩' => '屏蔽',
'醉薰薰' => '醉熏熏',
'墨沈沈' => '墨沉沉',
'壁報' => '牆報',
'暸如' => '瞭如',
'積體電路' => '集成電路',
'螢幕' => '屏幕',
'諮詢' => '咨詢',
'諾曼地' => '諾曼底',
'諾曼第' => '諾曼底',
'錄影' => '錄像',
'雕悍' => '鵰悍',
'嚎啕' => '嚎咷',
'糟蹋' => '蹧蹋',
'趨光性' => '趨旋光性',
'鍊鋼' => '煉鋼',
'鍾縣' => '鐘縣',
'霜淇淋' => '冰淇淋',
'瀋陽' => '沈陽',
'簡報' => '演示文稿',
'藉機' => '借機',
'薰天' => '熏天',
'轉捩點' => '轉折點',
'雜訊' => '噪聲',
'鼕鼕' => '冬冬',
'羅布林卡' => '羅布爾卡',
'羅哩羅唆' => '囉哩囉唆',
'羅德島' => '羅得島',
'羅羅唆唆' => '囉囉唆唆',
'羅羅嗦嗦' => '囉囉嗦嗦',
'識別字' => '標識符',
'蹺課' => '逃課',
'辭匯' => '詞匯',
'關鍵字' => '關鍵詞',
'類比' => '模擬',
'麴菌' => '曲菌',
'攜帶型' => '便攜式',
'欄位' => '字段',
'鐮倉幕府' => '鎌倉幕府',
'鐳射' => '激光',
'權杖' => '令牌',
'讀卡機' => '卡片閱\讀機',
'贛江' => '灨江',
'佘太君' => '畬太君',
'觖舌' => '鴃舌',
'睾丸' => '睪丸',
'撣灰' => '撢灰',
'氂牛' => '犛牛',
'衚同' => '胡衕',
'擣衣' => '搗衣',
'嚙合' => '囓合',
) }
__END__

=head1 SEE ALSO

L<b2g.pl>, L<Encode::HanConvert>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, 2003 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
