#!/bin/bash
script_version="v2025-08-22"
check_bash(){
current_bash_version=$(bash --version|head -n 1|awk '{for(i=1;i<=NF;i++) if ($i ~ /^[0-9]+\.[0-9]+(\.[0-9]+)?/) print $i}')
major_version=$(echo "$current_bash_version"|cut -d'.' -f1)
minor_version=$(echo "$current_bash_version"|cut -d'.' -f2)
if [ "$major_version" -lt 4 ]||{ [ "$major_version" -eq 4 ]&&[ "$minor_version" -lt 3 ];};then
echo "ERROR: Bash version is $current_bash_version lower than 4.3!"
echo "Tips: Run the following script to automatically upgrade Bash."
echo "bash <(curl -sL https://raw.githubusercontent.com/xykt/NetQuality/main/ref/upgrade_bash.sh)"
exit 0
fi
}
check_bash
Font_B="\033[1m"
Font_D="\033[2m"
Font_I="\033[3m"
Font_U="\033[4m"
Font_Black="\033[30m"
Font_Red="\033[31m"
Font_Green="\033[32m"
Font_Yellow="\033[33m"
Font_Blue="\033[34m"
Font_Purple="\033[35m"
Font_Cyan="\033[36m"
Font_White="\033[37m"
Back_Black="\033[40m"
Back_Red="\033[41m"
Back_Green="\033[42m"
Back_Yellow="\033[43m"
Back_Blue="\033[44m"
Back_Purple="\033[45m"
Back_Cyan="\033[46m"
Back_White="\033[47m"
Font_Suffix="\033[0m"
Font_LineClear="\033[2K"
Font_LineUp="\033[1A"
declare ADLines
declare -A aad
declare IP=""
declare IPhide
declare fullIP=0
declare YY="cn"
declare is_dep=1
declare is_nexttrace=1
declare is_speedtest=1
declare -A bgp
declare -A getbgp
declare -A getnat
declare -A gettcp
declare -A conn
declare -A casn
declare -A corg
declare -A ctarget
declare -A ctier1
declare -A cupstream
declare -A pcode
declare -A pshort
declare -A pname
declare -A pdm
declare -A presu
declare -A pavg
declare -A pout
declare -A iperfresu
declare -A icity
declare -A idm
declare -A iportl
declare -A iportu
declare -A iresu
declare -A isout
declare -A ipout
declare -A iavg
declare -A scity
declare -A spv
declare -A sid
declare -A sout
declare -A sresu
declare -A rww
declare -A rcn
declare -A routww
declare -A routcn
declare rgia=0
declare -A AS_MAPPING
declare -A rmcode
declare -A rmresu
declare rmtestnum
declare -A rmallasn
declare -A rmallgeo
declare -A rmmaxhop
declare -A rmcnhop
declare -A rmcn
declare -A rmww
declare rmgia=0
declare IPV4
declare IPV6
declare IPV4check=1
declare IPV6check=1
declare IPV4work=0
declare IPV6work=0
declare ERRORcode=0
declare shelp
declare -A swarn
declare -A sinfo
declare -A shead
declare -A sbgp
declare -A slocal
declare -A sconn
declare -A sdelay
declare -A sroute
declare -A siperf
declare -A sspeedtest
declare -A stail
declare ibar=0
declare bar_pid
declare ibar_step=0
declare main_pid=$$
declare PADDING=""
declare useNIC=""
declare usePROXY=""
declare CurlARG=""
declare UA_Browser
declare rawgithub
declare ISO3166
declare display_max_len=80
declare mode_ping=0
declare mode_route=0
declare mode_route_pv=""
declare mode_low=0
declare mode_json=0
declare mode_no=0
declare mode_yes=0
declare mode_skip=""
declare mode_menu=0
declare mode_output=0
declare mode_privacy=0
declare ping_test_count=10
declare pingww_test_count=12
declare usesudo="sudo"
declare netdata
shelp_lines=(
"NETWORK QUALITY CHECK SCRIPT 网络质量体检脚本"
"Interactive Interface:  bash <(curl -sL https://Net.Check.Place) -EM"
"交互界面：              bash <(curl -sL https://Net.Check.Place) -M"
"Parameters 参数运行: bash <(curl -sL https://Net.Check.Place) [-4] [-6] [-f] [-h] [-j] [-l language] [-n] [-y] [-E] [-L] [-M] [-P] [-R province] [-S chapters]"
"            -4                             Test IPv4                                  测试IPv4"
"            -6                             Test IPv6                                  测试IPv6"
"            -f                             Show full IP on reports                    报告展示完整IP地址"
"            -h                             Help information                           帮助信息"
"            -j                             JSON output                                JSON输出"
"            -l cn|en                       Specify script language                    指定报告语言"
"            -n                             No OS or dependencies check                跳过系统检测及依赖安装"
"            -o /path/to/file.ansi          Output ANSI report to file                 输出ANSI报告至文件"
"               /path/to/file.json          Output JSON result to file                 输出JSON结果至文件"
"               /path/to/file.anyother      Output plain text report to file           输出纯文本报告至文件"
"            -p                             Privacy mode - no generate report link     隐私模式：不生成报告链接"
"            -y                             Install dependencies without interupt      自动安装依赖"
"            -E                             Specify English Output                     指定英文输出"
"            -L                             Low data mode                              低数据模式（跳过测速环节）"
"            -M                             Run with Interactive Interface             交互界面方式运行"
"            -P                             Ping mode                                  三网延迟模式"
"            -R [Province]                  Route mode [Specify Province]              三网完整路由模式[可选指定省份]"
"            -S 1234567                     Skip sections by number                    跳过相应章节")
shelp=$(printf "%s\n" "${shelp_lines[@]}")
set_language(){
case "$YY" in
"en"|"jp"|"es"|"de"|"fr"|"ru"|"pt")swarn[1]="ERROR: Unsupported parameters!"
swarn[2]="ERROR: IP address format error!"
swarn[3]="ERROR: Dependent programs are missing. Please run as root or install sudo!"
swarn[4]="ERROR: Parameter -4 conflicts with -i or -6!"
swarn[6]="ERROR: Parameter -6 conflicts with -i or -4!"
swarn[9]="ERROR: It is not allowed to skip all funcions!"
swarn[10]="ERROR: Output file already exist!"
swarn[11]="ERROR: Output file is not writable!"
swarn[21]="ERROR: Wrong province code or name!"
swarn[40]="ERROR: IPv4 is not available!"
swarn[60]="ERROR: IPv6 is not available!"
sinfo[bgp]="Checking BGP database"
sinfo[lbgp]=21
sinfo[neighbor]="Checking Active Neighbors"
sinfo[lneighbor]=25
sinfo[nat]="Checking NAT Type"
sinfo[lnat]=17
sinfo[tcp]="Checking TCP Settings"
sinfo[ltcp]=21
sinfo[delay]="Checking China Mainland TCP Delay"
sinfo[ldelay]=33
sinfo[route]="Checking Route to China Mainland"
sinfo[lroute]=32
sinfo[moderoute]="Checking Route details to Specified Province"
sinfo[lmoderoute]=44
sinfo[speedtest]="Checking Speedtest of China "
sinfo[lspeedtest]=28
sinfo[iperf]="Checking Global Transfer of "
sinfo[liperf]=28
sinfo[delayww]="Checking Global TCP Delay"
sinfo[ldelayww]=25
shead[title]="NET QUALITY CHECK REPORT: "
shead[ver]="Version: $script_version"
shead[bash]="bash <(curl -sL https://Check.Place) -EN"
shead[git]="https://github.com/xykt/NetQuality"
shead[time]=$(date -u +"Report Time: %Y-%m-%d %H:%M:%S UTC")
shead[ltitle]=26
shead[ptime]=$(printf '%11s' '')
sbgp[title]="1. BGP Information (${Font_I}BGP.TOOLS & HE.NET$Font_Suffix)"
sbgp[ipinfo]="Reg Info:           "
sbgp[country]="Region:             "
sbgp[address]="Address:            "
sbgp[geofeed]="GeoFeed:            "
sbgp[date]="Reg/Mod Date:       "
sbgp[neighbor]="Active Neighbors:   "
slocal[title]="2. Local Status"
slocal[nat]="NAT Type:           "
slocal[tcpcc]="Congestion Control: "
slocal[qdisc]="Queue Discipline:   "
slocal[rmem]="TCP Receive Buffer: "
slocal[wmem]="TCP Send Buffer:    "
slocal[port]="Port: "
slocal[mapping]="Mapping: "
slocal[filter]="Filter: "
slocal[hairpin]="Hairpin: "
slocal[m0]="${Font_Green}Independent  $Font_Suffix"
slocal[m1]="${Font_Red}Dependent    $Font_Suffix"
slocal[f1]="${Font_Green}Independent      $Font_Suffix"
slocal[f2]="${Font_Yellow}AddressDependent $Font_Suffix"
slocal[f3]="${Font_Red}PortDependent    $Font_Suffix"
slocal[p0]="${Font_Yellow}Random    $Font_Suffix"
slocal[p1]="${Font_Green}Preserve  $Font_Suffix"
slocal[h0]="${Font_Green}Yes$Font_Suffix"
slocal[h1]="${Font_Yellow}No$Font_Suffix"
slocal[open]="$Back_Green$Font_White$Font_B Open Without NAT $Font_Suffix"
slocal[full]="$Back_Green$Font_White$Font_B Full Cone $Font_Suffix"
slocal[rest]="$Back_Yellow$Font_White$Font_B Restricted Cone $Font_Suffix"
slocal[portrest]="$Back_Yellow$Font_White$Font_B Port Restricted Cone $Font_Suffix"
slocal[symm]="$Back_Red$Font_White$Font_B Symmetric $Font_Suffix"
slocal[fail]="$Back_Red$Font_White$Font_B Checking Error $Font_Suffix"
slocal[firewall]="$Back_yellow$Font_White$Font_B Firewall $Font_Suffix"
slocal[block]="$Back_red$Font_White$Font_B Connection Failed $Font_Suffix"
slocal[unknown]="$Back_yellow$Font_White$Font_B Unknown NAT Type $Font_Suffix"
sconn[title]="3. Connectivity ($Back_Green$Font_White$Font_B*$Font_Suffix$Font_I=Tier1 $Font_Suffix$Back_Yellow$Font_White$Font_B*$Font_Suffix$Font_I=Non-Tier1 $Font_Suffix$Font_U*$Font_Suffix$Font_I=Upstream$Font_Suffix)"
sconn[ix]="IXPs Counts: "
sconn[upstreams]="Upstreams Counts: "
sconn[peers]="Peers Counts: "
sdelay[title]="4. China Mainland TCP Delay (${Font_I}CT|CU|CM Step=80ms$Font_Suffix)      "
sdelay[pingmode]="$(printf '%8s'|tr ' ' '*')China Telecom$(printf '%13s'|tr ' ' '*')China Unicom$(printf '%14s'|tr ' ' '*')China Mobile$(printf '%8s'|tr ' ' '*')"
sroute[title]="5. Route to China Mainland (May vary with network congestion)"
sroute[ct]="CTel"
sroute[cu]="CUni"
sroute[cm]="CMob"
sroute[bj]="BJ "
sroute[sh]="SH "
sroute[gz]="GZ "
sroute[tcp]="TCP:  "
sroute[udp]="UDP:  "
sspeedtest[title]="6. CN NetSpeed $Font_I${Font_U}Send$Font_Suffix ${Font_I}Delay ${Font_U}Receive$Font_Suffix ${Font_I}Delay$Font_Suffix||Unit: ${Font_U}Mbps$Font_Suffix$Font_I ms  ${Font_U}Send$Font_Suffix ${Font_I}Delay ${Font_U}Receive$Font_Suffix ${Font_I}Delay$Font_Suffix"
siperf[title]="7. Global Network   $Font_I${Font_U}Send$Font_Suffix ${Font_I}Retr ${Font_U}Recv$Font_Suffix ${Font_I}Retr$Font_Suffix||Unit: ms ${Font_U}Mbps$Font_Suffix$Font_I Delay ${Font_U}Send$Font_Suffix ${Font_I}Retr ${Font_U}Recv$Font_Suffix ${Font_I}Retr$Font_Suffix"
siperf[send]=" Send"
siperf[recv]=" Receive"
stail[stoday]="Network Checks Today: "
stail[stotal]="; Total: "
stail[thanks]=". Thanks for running xy scripts!"
stail[link]="${Font_I}Report Link: $Font_U"
;;
"cn")swarn[1]="错误：不支持的参数！"
swarn[2]="错误：IP地址格式错误！"
swarn[3]="错误：未安装依赖程序，请以root执行此脚本，或者安装sudo命令！"
swarn[4]="错误：参数-4与-i/-6冲突！"
swarn[6]="错误：参数-6与-i/-4冲突！"
swarn[9]="错误: 不允许跳过所有功能！"
swarn[10]="错误：输出文件已存在！"
swarn[11]="错误：输出文件不可写！"
swarn[21]="错误: 错误的省份名称或代码！"
swarn[40]="错误：IPV4不可用！"
swarn[60]="错误：IPV6不可用！"
sinfo[bgp]="正在检测BGP数据库 "
sinfo[lbgp]=18
sinfo[neighbor]="正在检测活跃邻居 "
sinfo[lneighbor]=17
sinfo[nat]="正在检测NAT类型 "
sinfo[lnat]=16
sinfo[tcp]="正在检测TCP设置 "
sinfo[ltcp]=16
sinfo[delay]="正在检测大陆三网TCP大包延迟"
sinfo[ldelay]=27
sinfo[route]="正在检测大陆三网回程线路"
sinfo[lroute]=24
sinfo[moderoute]="正在检测TCP回程详细路由"
sinfo[lmoderoute]=23
sinfo[speedtest]="正在检测三网Speedtest之"
sinfo[lspeedtest]=23
sinfo[iperf]="正在检测国际互连："
sinfo[liperf]=18
sinfo[delayww]="正在检测国际互连TCP大包延迟"
sinfo[ldelayww]=27
shead[title]="网络质量体检报告："
shead[ver]="脚本版本：$script_version"
shead[bash]="bash <(curl -sL https://Check.Place) -N"
shead[git]="https://github.com/xykt/NetQuality"
shead[time]=$(TZ="Asia/Shanghai" date +"报告时间：%Y-%m-%d %H:%M:%S CST")
shead[ltitle]=18
shead[ptime]=$(printf '%12s' '')
sbgp[title]="一、BGP信息（${Font_I}BGP.TOOLS & HE.NET$Font_Suffix）"
sbgp[ipinfo]="注册信息：          "
sbgp[country]="地区：              "
sbgp[address]="地址：              "
sbgp[geofeed]="地理数据供给：      "
sbgp[date]="注册/修改日期：     "
sbgp[neighbor]="活跃邻居：          "
slocal[title]="二、本地策略"
slocal[nat]="NAT类型：        "
slocal[tcpcc]="TCP拥塞控制算法："
slocal[qdisc]="队列调度算法：   "
slocal[rmem]="TCP接收缓冲区（rmem）："
slocal[wmem]="TCP发送缓冲区（wmem）："
slocal[port]="端口行为："
slocal[mapping]="映射行为："
slocal[filter]="过滤行为："
slocal[hairpin]="环回："
slocal[m0]="$Font_Green独立映射  $Font_Suffix"
slocal[m1]="$Font_Red依赖映射  $Font_Suffix"
slocal[f1]="$Font_Green端点独立过滤 $Font_Suffix"
slocal[f2]="$Font_Yellow地址依赖过滤 $Font_Suffix"
slocal[f3]="$Font_Red端口依赖过滤 $Font_Suffix"
slocal[p0]="$Font_Yellow端口随机  $Font_Suffix"
slocal[p1]="$Font_Green端口保留  $Font_Suffix"
slocal[h0]="$Font_Green支持$Font_Suffix"
slocal[h1]="$Font_Yellow不支持$Font_Suffix"
slocal[open]="$Back_Green$Font_White$Font_B 开放网络无NAT $Font_Suffix"
slocal[full]="$Back_Green$Font_White$Font_B 全锥形 $Font_Suffix"
slocal[rest]="$Back_Yellow$Font_White$Font_B 受限锥形 $Font_Suffix"
slocal[portrest]="$Back_Yellow$Font_White$Font_B 端口受限锥形 $Font_Suffix"
slocal[symm]="$Back_Red$Font_White$Font_B 对称型 $Font_Suffix"
slocal[fail]="$Back_Red$Font_White$Font_B 检测错误 $Font_Suffix"
slocal[firewall]="$Back_yellow$Font_White$Font_B 防火墙 $Font_Suffix"
slocal[block]="$Back_red$Font_White$Font_B 连接失败 $Font_Suffix"
slocal[unknown]="$Back_yellow$Font_White$Font_B 未知NAT类型 $Font_Suffix"
sconn[title]="三、接入信息（$Back_Green$Font_White$Font_B*$Font_Suffix$Font_I=Tier1 $Font_Suffix$Back_Yellow$Font_White$Font_B*$Font_Suffix$Font_I=非Tier1 $Font_Suffix$Font_U*$Font_Suffix$Font_I=上游$Font_Suffix）"
sconn[ix]="互联网交换点接入数："
sconn[upstreams]="上游数量："
sconn[peers]="对等互联数量："
sdelay[title]="四、三网TCP大包延迟（$Font_I依次为电信|联通|移动 Step=80ms$Font_Suffix） "
sdelay[pingmode]="$(printf '%12s'|tr ' ' '*')电 信$(printf '%21s'|tr ' ' '*')联 通$(printf '%21s'|tr ' ' '*')移 动$(printf '%11s'|tr ' ' '*')"
sroute[title]="五、三网回程路由（$Font_I线路可能随网络负载动态变化$Font_Suffix）"
sroute[ct]="电信"
sroute[cu]="联通"
sroute[cm]="移动"
sroute[bj]="北京"
sroute[sh]="上海"
sroute[gz]="广州"
sroute[tcp]="TCP："
sroute[udp]="UDP："
sspeedtest[title]="六、国内测速   $Font_I$Font_U发送$Font_Suffix  $Font_I延迟    $Font_U接收$Font_Suffix  $Font_I延迟$Font_Suffix||单位：${Font_U}Mbps$Font_Suffix$Font_I ms  $Font_U发送$Font_Suffix  $Font_I延迟    $Font_U接收$Font_Suffix  $Font_I延迟$Font_Suffix"
siperf[title]="七、国际互连   $Font_I延迟 $Font_U发送$Font_Suffix $Font_I重传 $Font_U接收$Font_Suffix $Font_I重传$Font_Suffix||单位：ms ${Font_U}Mbps$Font_Suffix$Font_I  延迟 $Font_U发送$Font_Suffix $Font_I重传 $Font_U接收$Font_Suffix $Font_I重传$Font_Suffix"
siperf[send]="之发送"
siperf[recv]="之接收"
stail[stoday]="今日网络检测量："
stail[stotal]="；总检测量："
stail[thanks]="。感谢使用xy系列脚本！"
stail[link]="$Font_I报告链接：$Font_U"
;;
*)echo -ne "ERROR: Language not supported!"
esac
}
countRunTimes(){
local RunTimes=$(curl $CurlARG -s --max-time 10 "https://hits.xykt.de/net?action=hit" 2>&1)
stail[today]=$(echo "$RunTimes"|jq '.daily')
stail[total]=$(echo "$RunTimes"|jq '.total')
}
show_progress_bar(){
show_progress_bar_ "$@" 1>&2
}
show_progress_bar_(){
local bar="\u280B\u2819\u2839\u2838\u283C\u2834\u2826\u2827\u2807\u280F"
local n=${#bar}
while sleep 0.1;do
if ! kill -0 $main_pid 2>/dev/null;then
echo -ne ""
exit
fi
echo -ne "\r$Font_Cyan$Font_B[$IP]# $1$Font_Cyan$Font_B$(printf '%*s' "$2" ''|tr ' ' '.') ${bar:ibar++*6%n:6} $(printf '%02d%%' $ibar_step) $Font_Suffix"
done
}
kill_progress_bar(){
kill "$bar_pid" 2>/dev/null&&echo -ne "\r"
}
install_dependencies(){
local is_dep=1
local is_nexttrace=1
local is_speedtest=1
local is_stun=1
if [ "$(uname)" == "Darwin" ]||[ $(id -u) -eq 0 ];then
usesudo=""
fi
if ! jq --version >/dev/null 2>&1||! curl --version >/dev/null 2>&1||! command -v convert >/dev/null 2>&1||! command -v mtr >/dev/null 2>&1||! command -v iperf3 >/dev/null 2>&1||! command -v stun >/dev/null 2>&1||(! command -v stun >/dev/null 2>&1&&! command -v pkg >/dev/null 2>&1&&[[ "$(uname)" != "Darwin" ]])||(! command -v free >/dev/null 2>&1&&[[ "$(uname)" != "Darwin" ]]);then
is_dep=0
fi
if ! command -v nexttrace >/dev/null 2>&1;then
is_nexttrace=0
fi
if ! command -v speedtest >/dev/null 2>&1;then
is_speedtest=0
fi
if ! command -v stun >/dev/null 2>&1&&(command -v apk >/dev/null 2>&1||command -v yum >/dev/null 2>&1||command -v zypper >/dev/null 2>&1||command -v xbps-install >/dev/null 2>&1||command -v pacman >/dev/null 2>&1);then
is_stun=0
fi
if [[ $is_dep -eq 0 || $is_nexttrace -eq 0 || $is_speedtest -eq 0 ]];then
echo -e "Lacking necessary dependencies."
[[ $is_dep -eq 0 ]]&&echo -e "Packages $Font_I${Font_Cyan}jq curl imagemagick mtr iperf3 stun bc$Font_Suffix will be installed using ${Font_Green}package manager$Font_Suffix."
[[ $is_nexttrace -eq 0 ]]&&echo -e "Application $Font_I${Font_Cyan}nexttrace$Font_Suffix will be installed via $Font_Green${Font_I}curl nxtrace.org/nt |bash$Font_Suffix by ${Font_U}https://www.nxtrace.org/$Font_Suffix official."
[[ $is_speedtest -eq 0 ]]&&echo -e "Application $Font_I${Font_Cyan}speedtest$Font_Suffix will be installed using ${Font_B}Speedtest.net$Font_Suffix official installation method ${Font_U}https://www.speedtest.net/apps/cli$Font_Suffix."
if [[ $mode_yes -eq 0 ]];then
prompt=$(printf "Continue? (${Font_Green}y$Font_Suffix/${Font_Red}n$Font_Suffix): ")
read -p "$prompt" choice
case "$choice" in
y|Y|yes|Yes|YES)echo "Continue to execute script..."
;;
n|N|no|No|NO)echo "Script exited."
exit 0
;;
*)echo "Invalid input, script exited."
exit 1
esac
else
echo -e "Detected parameter $Font_Green-y$Font_Suffix. Continue installation..."
fi
if [[ $is_dep -eq 0 ]];then
if [ "$(uname)" == "Darwin" ];then
install_packages "brew" "brew install"
elif [ -f /etc/os-release ];then
. /etc/os-release
if [ $(id -u) -ne 0 ]&&! command -v sudo >/dev/null 2>&1;then
ERRORcode=3
fi
case $ID in
debian)install_packages "apt" "apt-get install -y"
;;
ubuntu|linuxmint)install_packages "apt" "apt-get install -y"
;;
rhel|centos|almalinux|rocky|anolis)if
[ "$(echo $VERSION_ID|cut -d '.' -f1)" -ge 8 ]
then
install_packages "dnf" "dnf install -y"
else
install_packages "yum" "yum install -y"
fi
;;
arch|manjaro)install_packages "pacman" "pacman -S --noconfirm"
;;
alpine)install_packages "apk" "apk add"
;;
fedora)install_packages "dnf" "dnf install -y"
;;
alinux)install_packages "yum" "yum install -y"
;;
suse|opensuse*)install_packages "zypper" "zypper install -y"
;;
void)install_packages "xbps" "xbps-install -Sy"
;;
*)echo "Unsupported distribution: $ID"
exit 1
esac
elif [ -n "$PREFIX" ];then
install_packages "pkg" "pkg install"
else
echo "Cannot detect distribution because /etc/os-release is missing."
exit 1
fi
fi
if [[ $is_nexttrace -eq 0 ]];then
curl -s nxtrace.org/nt|bash
fi
if [[ $is_speedtest -eq 0 ]];then
install_speedtest
fi
if [[ $is_stun -eq 0 ]];then
install_stun
fi
fi
}
install_packages(){
local package_manager=$1
local install_command=$2
case $package_manager in
apt)$usesudo apt update
$usesudo $install_command jq curl imagemagick mtr-tiny iperf3 stun bc procps
;;
dnf)$usesudo $install_command epel-release
$usesudo $package_manager makecache
$usesudo $install_command jq curl ImageMagick mtr iperf3 stun bc procps-ng
;;
yum)$usesudo $install_command epel-release
$usesudo $package_manager makecache
$usesudo $install_command jq curl ImageMagick mtr iperf3 bc procps-ng libstdc++
;;
pacman)$usesudo pacman -Sy
$usesudo $install_command jq curl imagemagick mtr iperf3 bc procps-ng
if command -v paru >/dev/null 2>&1; then
    $usesudo paru -S --noconfirm gcompat
elif command -v yay >/dev/null 2>&1; then
    $usesudo yay -S --noconfirm gcompat
else
    echo "Neither paru nor yay found. Please install one of them for AUR support."
fi
;;
apk)$usesudo apk update
$usesudo $install_command jq curl imagemagick mtr iperf3 bc procps gcompat libstdc++
;;
pkg)$usesudo $package_manager update
$usesudo $package_manager $install_command jq curl imagemagick mtr iperf3 bc procps libstdcxx
;;
brew)eval "$(/opt/homebrew/bin/brew shellenv)"
$install_command jq curl imagemagick mtr iperf3 bc
;;
zypper)$usesudo zypper refresh
$usesudo $install_command jq curl imagemagick mtr iperf3 bc procps libstdc++6
;;
xbps)$usesudo xbps-install -Sy
$usesudo $install_command jq curl imagemagick mtr iperf3 bc procps-ng gcompat libstdc++
esac
}
install_speedtest(){
if [ "$(uname)" == "Darwin" ];then
brew tap teamookla/speedtest
brew update
brew install speedtest --force
elif [ "$(uname)" == "FreeBSD" ];then
$usesudo pkg update&&sudo pkg install -g libidn2 ca_root_nss
freebsd_version=$(freebsd-version|cut -d '-' -f 1)
case $freebsd_version in
12.*)$usesudo pkg add "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-freebsd12-x86_64.pkg"
;;
13.*)$usesudo pkg add "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-freebsd13-x86_64.pkg"
;;
*)return 1
esac
else
local sys_type=""
local sysarch="$(uname -m)"
case "$sysarch" in
"x86_64"|"x86"|"amd64"|"x64")sys_type="x86_64";;
"i386"|"i686")sys_type="i386";;
"aarch64"|"armv7l"|"armv8"|"armv8l")sys_type="aarch64";;
*)return 1
esac
$usesudo curl -sL -o /usr/bin/speedtest "${rawgithub}main/ref/speedtest/speedtest-$sys_type"
$usesudo chmod +x /usr/bin/speedtest
fi
}
install_stun(){
local arch
local sys_type
arch=$(uname -m)
case "$arch" in
x86_64)if
[[ "$(getconf LONG_BIT)" == "32" ]]
then
sys_type="i386"
else
sys_type="amd64"
fi
;;
aarch64|arm64)sys_type="arm64"
;;
i386|i486|i586|i686)sys_type="i386"
;;
mips64|mips64el)echo "mips64el"
;;
riscv64)echo "riscv64"
;;
*)return 1
esac
$usesudo curl -sL -o /usr/bin/stun "${rawgithub}main/ref/stun/stun_$sys_type"
$usesudo chmod +x /usr/bin/stun
}
declare -A browsers=(
[Chrome]="139.0.7258.128 139.0.7258.67 138.0.7204.185 138.0.7204.170 138.0.7204.159 138.0.7204.102 138.0.7204.100 138.0.7204.51 138.0.7204.49 137.0.7151.122 138.0.7204.35 137.0.7151.121 137.0.7151.105 137.0.7151.104 137.0.7151.57 137.0.7151.55 136.0.7103.116 137.0.7151.40 136.0.7103.113 136.0.7103.92 135.0.7049.117 136.0.7103.48 135.0.7049.114 135.0.7049.86 135.0.7049.42 135.0.7049.41 134.0.6998.167 134.0.6998.119 134.0.6998.117 134.0.6998.37 134.0.6998.35 133.0.6943.128 133.0.6943.100 133.0.6943.59 133.0.6943.53 132.0.6834.162 133.0.6943.35 132.0.6834.160 132.0.6834.112 132.0.6834.110 131.0.6778.267 132.0.6834.83 131.0.6778.264 131.0.6778.204 131.0.6778.139 131.0.6778.109 131.0.6778.71 131.0.6778.69 130.0.6723.119 131.0.6778.33 130.0.6723.116 130.0.6723.71 130.0.6723.60 130.0.6723.58 129.0.6668.103 130.0.6723.44 129.0.6668.100 129.0.6668.72 129.0.6668.60 129.0.6668.42 128.0.6613.122 128.0.6613.121 128.0.6613.115 128.0.6613.113 127.0.6533.122 128.0.6613.36 127.0.6533.119 127.0.6533.100 127.0.6533.74 127.0.6533.72 126.0.6478.185 127.0.6533.57 126.0.6478.183 126.0.6478.128 126.0.6478.116 126.0.6478.114 126.0.6478.61 125.0.6422.176 126.0.6478.56 125.0.6422.144 126.0.6478.36 125.0.6422.142 125.0.6422.114 125.0.6422.77 125.0.6422.76 124.0.6367.210 125.0.6422.60 124.0.6367.208 124.0.6367.201 124.0.6367.156 125.0.6422.41 124.0.6367.155 124.0.6367.119 124.0.6367.92 124.0.6367.63 124.0.6367.61 123.0.6312.124 124.0.6367.60 123.0.6312.122 123.0.6312.106 123.0.6312.105 123.0.6312.60 123.0.6312.58 122.0.6261.131 123.0.6312.46 122.0.6261.129 122.0.6261.128 122.0.6261.112 122.0.6261.111 122.0.6261.71 122.0.6261.69 121.0.6167.189 122.0.6261.57 121.0.6167.187 121.0.6167.186 121.0.6167.162 121.0.6167.160 121.0.6167.140 121.0.6167.86 121.0.6167.85 120.0.6099.227 120.0.6099.225 121.0.6167.75 120.0.6099.224 120.0.6099.218 120.0.6099.216 120.0.6099.200 120.0.6099.199 120.0.6099.129 120.0.6099.110 120.0.6099.109 120.0.6099.62 120.0.6099.56"
[Firefox]="132.0 131.0 130.0 129.0 128.0 127.0 126.0 125.0 124.0 123.0 122.0 121.0 120.0")
generate_random_user_agent(){
local browsers_keys=(${!browsers[@]})
local random_browser_index=$((RANDOM%${#browsers_keys[@]}))
local browser=${browsers_keys[random_browser_index]}
case $browser in
Chrome)local versions=(${browsers[Chrome]})
local version=${versions[RANDOM%${#versions[@]}]}
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$version Safari/537.36"
;;
Firefox)local versions=(${browsers[Firefox]})
local version=${versions[RANDOM%${#versions[@]}]}
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:$version) Gecko/20100101 Firefox/$version"
esac
}
check_connectivity(){
local url="https://www.google.com/generate_204"
local timeout=2
local http_code
http_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout "$timeout" "$url" 2>/dev/null)
if [[ $http_code == "204" ]];then
rawgithub="https://github.com/xykt/NetQuality/raw/"
return 0
else
rawgithub="https://testingcf.jsdelivr.net/gh/xykt/NetQuality@"
return 1
fi
}
is_valid_ipv4(){
local ip=$1
if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]];then
IFS='.' read -r -a octets <<<"$ip"
for octet in "${octets[@]}";do
if ((octet<0||octet>255));then
IPV4work=0
return 1
fi
done
IPV4work=1
return 0
else
IPV4work=0
return 1
fi
}
is_private_ipv4(){
local ip_address=$1
if [[ -z $ip_address ]];then
return 0
fi
if [[ $ip_address =~ ^10\. ]]||[[ $ip_address =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]||[[ $ip_address =~ ^192\.168\. ]]||[[ $ip_address =~ ^127\. ]]||[[ $ip_address =~ ^0\. ]]||[[ $ip_address =~ ^22[4-9]\. ]]||[[ $ip_address =~ ^23[0-9]\. ]];then
return 0
fi
return 1
}
get_ipv4(){
local response
local API_NET=("ip.sb" "ping0.cc" "icanhazip.com" "api64.ipify.org" "ifconfig.co" "ident.me")
for p in "${API_NET[@]}";do
response=$(curl $CurlARG -s4 --max-time 8 "$p")
if [[ $? -eq 0 && ! $response =~ error ]];then
IPV4="$response"
break
fi
done
}
hide_ipv4(){
if [[ -n $1 ]];then
IFS='.' read -r -a ip_parts <<<"$1"
IPhide="${ip_parts[0]}.${ip_parts[1]}.*.*"
else
IPhide=""
fi
}
is_valid_ipv6(){
local ip=$1
if [[ $ip =~ ^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,7}:$ || $ip =~ ^:([0-9a-fA-F]{1,4}:){1,7}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}$ || $ip =~ ^[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})$ || $ip =~ ^:((:[0-9a-fA-F]{1,4}){1,7}|:)$ || $ip =~ ^fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}$ || $ip =~ ^::(ffff(:0{1,4}){0,1}:){0,1}(([0-9]{1,3}\.){3}[0-9]{1,3})$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,4}:(([0-9]{1,3}\.){3}[0-9]{1,3})$ ]];then
IPV6work=1
return 0
else
IPV6work=0
return 1
fi
}
is_private_ipv6(){
local address=$1
if [[ -z $address ]];then
return 0
fi
if [[ $address =~ ^fe80: ]]||[[ $address =~ ^fc00: ]]||[[ $address =~ ^fd00: ]]||[[ $address =~ ^2001:db8: ]]||[[ $address == ::1 ]]||[[ $address =~ ^::ffff: ]]||[[ $address =~ ^2002: ]]||[[ $address =~ ^2001: ]];then
return 0
fi
return 1
}
get_ipv6(){
local response
local API_NET=("ip.sb" "ping0.cc" "icanhazip.com" "api64.ipify.org" "ifconfig.co" "ident.me")
for p in "${API_NET[@]}";do
response=$(curl $CurlARG -s6k --max-time 8 "$p")
if [[ $? -eq 0 && ! $response =~ error ]];then
IPV6="$response"
break
fi
done
}
hide_ipv6(){
if [[ -n $1 ]];then
local expanded_ip=$(echo "$1"|sed 's/::/:0000:0000:0000:0000:0000:0000:0000:0000:/g'|cut -d ':' -f1-8)
IFS=':' read -r -a ip_parts <<<"$expanded_ip"
while [ ${#ip_parts[@]} -lt 8 ];do
ip_parts+=(0000)
done
IPhide="${ip_parts[0]:-0}:${ip_parts[1]:-0}:${ip_parts[2]:-0}:*:*:*:*:*"
IPhide=$(echo "$IPhide"|sed 's/:0\{1,\}/:/g'|sed 's/::\+/:/g')
else
IPhide=""
fi
}
calculate_display_width(){
local string="$1"
local length=0
local char
for ((i=0; i<${#string}; i++));do
char=$(echo "$string"|od -An -N1 -tx1 -j $((i))|tr -d ' ')
if [ "$(printf '%d\n' 0x$char)" -gt 127 ];then
length=$((length+2))
i=$((i+1))
else
length=$((length+1))
fi
done
echo "$length"
}
calc_padding(){
local input_text="$1"
local total_width=$2
local title_length=$(calculate_display_width "$input_text")
local left_padding=$(((total_width-title_length)/2))
if [[ $left_padding -gt 0 ]];then
PADDING=$(printf '%*s' $left_padding)
else
PADDING=""
fi
}
parse_date(){
local input="$1"
local parsed_date=""
[[ -z $input ]]&&echo ""&&return
if [[ $input =~ ^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$ ]];then
parsed_date="$(echo "$input"|awk -F'-' '{printf "%04d-%02d-%02d", $1, $2, $3}')"
elif [[ $input =~ ^[0-9]{8}$ ]];then
parsed_date="$(echo "$input"|sed -E 's/(.{4})(.{2})(.{2})/\1-\2-\3/')"
elif [[ $input =~ ^[0-9]{4}/[0-9]{1,2}/[0-9]{1,2}$ ]];then
parsed_date="$(echo "$input"|awk -F'/' '{printf "%04d-%02d-%02d", $1, $2, $3}')"
elif [[ $input =~ ^[0-9]{1,2}\ [A-Za-z]{3}\ [0-9]{4} ]];then
parsed_date="$(date -d "$input" +"%Y-%m-%d" 2>/dev/null)"
elif [[ $input =~ ^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]];then
parsed_date="$(echo "$input"|awk -F'[T-]' '{printf "%04d-%02d-%02d", $1, $2, $3}')"
fi
echo "${parsed_date:-}"
}
wrap_text(){
local indent=$1
local text=$2
local max_len=$((80-indent))
local indent_spaces=$(printf '%*s' $indent)
local result=""
while [[ ${#text} -gt $max_len ]];do
local cut_pos=$(echo "${text:0:max_len}"|awk '{print length($0)-length($NF)}')
result+="${text:0:cut_pos}\n\r$indent_spaces"
text="${text:$((cut_pos))}"
done
result+="$text"
echo -e "$result"
}
generate_uuidv4(){
local uuid=""
local chars="0123456789abcdef"
for i in {1..36};do
if [[ $i == 9 || $i == 14 || $i == 19 || $i == 24 ]];then
uuid+="-"
elif [[ $i == 15 ]];then
uuid+="4"
elif [[ $i == 20 ]];then
r=$((RANDOM%16))
y=$((r&0x3|0x8))
uuid+=${chars:y:1}
else
r=$((RANDOM%16))
uuid+=${chars:r:1}
fi
done
echo "$uuid"
}
replace_html_entities(){
echo "$1"|sed -E \
-e 's/&#45;/-/g' \
-e 's/&#38;/\&/g' \
-e 's/&#39;/'\''/g' \
-e 's/&#34;/"/g' \
-e 's/&#60;/</g' \
-e 's/&#62;/>/g' \
-e 's/&#160;/ /g' \
-e 's/&amp;/\&/g'
}
calc_upstream(){
local RESPONSE=$2
local src_path=$(echo "$RESPONSE"|sed -n 's|.*src="\(/pathimg/[^"]*\)".*|\1|p')
local uuid=$(generate_uuidv4)
local extra_string="&loggedin"
local svg_content=$(curl $CurlARG -$1 --user-agent "$UA_Browser" --max-time 10 -Ls "https://bgp.tools$src_path?$uuid$extra_string")
local as_cards=()
local arrows=()
local inside_as_card=0
local inside_arrow=0
local current_block=""
while IFS= read -r line;do
if [[ $line =~ \<g\ id=\"[^\"]*\"\ class=\"node\" ]];then
inside_as_card=1
current_block="$line"
continue
fi
if [[ $line =~ \<g\ id=\"[^\"]*\"\ class=\"edge\" ]];then
inside_arrow=1
current_block="$line"
continue
fi
if [[ $inside_as_card -eq 1 ]];then
current_block+=$'\n'"$line"
if [[ $line == *"</g>"* ]];then
as_cards+=("$current_block")
inside_as_card=0
current_block=""
fi
fi
if [[ $inside_arrow -eq 1 ]];then
current_block+=$'\n'"$line"
if [[ $line == *"</g>"* ]];then
arrows+=("$current_block")
inside_arrow=0
current_block=""
fi
fi
done <<<"$svg_content"
local as_card
local target_as_number=""
for as_card in "${as_cards[@]}";do
local id=$(echo "$as_card"|awk -F 'id="node|"' '/<g id="node/{print $2}')
id=${id:-0}
casn[$id]=$(echo "$as_card"|awk -F '[<>]' '/<text.*font-weight="bold".*>/{print $3}'|sed 's/AS//')
casn[$id]="${casn[$id]:-0}"
if [[ ${casn[$id]} -eq 0 ]];then
corg[$id]="IX Route"
continue
else
corg[$id]=$(echo "$as_card"|awk -F '[<>]' '/<text.*font-size="10.00".*>/{print $3}')
corg[$id]=$(replace_html_entities "${corg[$id]}")
corg[$id]="${corg[$id]:-"unknown"}"
fi
if echo "$as_card"|grep -q 'stroke="limegreen"';then
target_as_number="${casn[$id]}"
ctarget[$id]=true
ctier1[$id]=false
elif echo "$as_card"|grep -q 'fill="none"';then
ctarget[$id]=false
ctier1[$id]=false
elif echo "$as_card"|grep -q 'fill="white"';then
ctarget[$id]=false
ctier1[$id]=true
fi
cupstream[$id]=false
for arrow in "${arrows[@]}";do
local arrow_title=$(echo "$arrow"|awk -F '[<>]' '/<title>/{print $3}')
arrow_title=$(replace_html_entities "$arrow_title")
if [[ $arrow_title =~ AS$target_as_number.*AS${casn[$id]} ]];then
for sub_arrow in "${arrows[@]}";do
local sub_arrow_title=$(echo "$sub_arrow"|awk -F '[<>]' '/<title>/{print $3}')
sub_arrow_title=$(replace_html_entities "$sub_arrow_title")
if [[ $sub_arrow_title =~ AS${casn[$id]}.*AS[0-9]+ ]];then
cupstream[$id]=true
break 2
fi
done
fi
done
done
}
calc_ix(){
local RESULT=$(curl $CurlARG -$1 --user-agent "$UA_Browser" --max-time 10 -Ls "https://bgp.tools/ixp-rs-route/${bgp[prefix]}")
local ROWS=$(echo "$RESULT"|sed -n '/<table id="upstreamTable"/,/<\/table>/p'|grep "<tr>"|wc -l)
conn[ix]=$((ROWS-1))
}
calc_peers(){
local RESULT="$1"
if [[ $RESULT == *"This network is transit-free."* ]];then
conn[upstreams]=-2
else
local ROWS=$(echo "$RESULT"|sed -n '/<table id="upstreamTable"/,/<\/table>/p'|grep "<tr>"|wc -l)
conn[upstreams]=$((ROWS-1))
fi
ROWS=$(echo "$RESULT"|sed -n '/<table id="peersTable"/,/<\/table>/p'|grep "<tr>"|wc -l)
conn[peers]=$((ROWS-1))
}
get_bgp(){
bgp[org]="${bgp[org]:-${getbgp[org-name]:-${getbgp[organization]:-${getbgp[orgname]:-${getbgp[owner]:-${getbgp[dscr]%%,*:-${getbgp[netname]:-${getbgp[ownerid]:-${getbgp[mnt-by]}}}}}}}}}"
[[ ${getbgp[source]} =~ ^(RIPE|APNIC|ARIN|LACNIC|AFRINIC)$ ]]&&bgp[rir]="${getbgp[source]}"
[[ -z ${bgp[rir]} && ${getbgp[mnt-by]} =~ ^(RIPE|APNIC|ARIN|LACNIC|AFRINIC)- ]]&&bgp[rir]="${BASH_REMATCH[1]}"
[[ -z ${bgp[rir]} && -n ${getbgp[ownerid]} ]]&&bgp[rir]="LACNIC"
[[ -z ${bgp[rir]} && -n ${getbgp[orgtechhandle]} ]]&&bgp[rir]="ARIN"
if [[ -n ${getbgp[country]} ]];then
[[ -z ${bgp[countrycode]} ]]&&bgp[countrycode]="${getbgp[country]}"
[[ -z ${bgp[country]} ]]&&bgp[country]=$(echo "$ISO3166"|jq --arg code "${bgp[countrycode]}" -r '.[] | select(.["alpha-2"] == $code) | .name // ""')
[[ -z ${bgp[region]} ]]&&bgp[region]=$(echo "$ISO3166"|jq --arg code "${bgp[countrycode]}" -r '.[] | select(.["alpha-2"] == $code) | .region // ""')
[[ -z ${bgp[subregion]} ]]&&bgp[subregion]=$(echo "$ISO3166"|jq --arg code "${bgp[countrycode]}" -r '.[] | select(.["alpha-2"] == $code) | ."sub-region" // ""')
[[ -z ${bgp[intermediateregion]} ]]&&bgp[intermediateregion]=$(echo "$ISO3166"|jq --arg code "${bgp[countrycode]}" -r '.[] | select(.["alpha-2"] == $code) | ."intermediate-region" // ""')
[[ ${bgp[region]} == "null" ]]&&bgp[region]=""
[[ ${bgp[subregion]} == "null" ]]&&bgp[subregion]=""
[[ ${bgp[intermediateregion]} == "null" ]]&&bgp[intermediateregion]=""
fi
[[ -z ${bgp[address]} && -n ${getbgp[address]} ]]&&bgp[address]="$(echo "${getbgp[address]}"|sed 's/,\+/,/g')"
[[ -z ${bgp[geofeed]} && -n ${getbgp[geofeed]} ]]&&bgp[geofeed]="${getbgp[geofeed]}"
[[ -z ${bgp[regdate]} ]]&&bgp[regdate]="$(parse_date "${getbgp[created]:-${getbgp[regdate]}}")"
[[ -z ${bgp[moddate]} ]]&&bgp[moddate]="$(parse_date "${getbgp[last-modified]:-${getbgp[updated]:-${getbgp[changed]}}}")"
}
db_bgptools(){
local temp_info="$Font_Cyan$Font_B${sinfo[bgp]}${Font_I}BGP.TOOLS $Font_Suffix"
((ibar_step+=1))
show_progress_bar "$temp_info" $((50-10-${sinfo[lbgp]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
bgp=()
getbgp=()
conn=()
casn=()
corg=()
ctarget=()
ctier1=()
cupstream=()
local RESPONSE=$(curl $CurlARG -$1 --user-agent "$UA_Browser" --max-time 10 -Ls "https://bgp.tools/prefix/$IP")
if [[ $RESPONSE == *"Overlapping Prefixes Detected"* ]];then
bgp[prefix]=$(echo "$RESPONSE"|grep -o 'href="/prefix/[^"]*'|head -1|cut -d'/' -f3-)
RESPONSE=$(curl $CurlARG -$1 --user-agent "$UA_Browser" --max-time 10 -Ls "https://bgp.tools/prefix/${bgp[prefix]}")
fi
bgp[prefix]=$(echo "$RESPONSE"|sed -n 's/.*<p id="network-name" class="heading-xlarge">\([^<]*\)<\/p>.*/\1/p')
if [[ ${bgp[prefix]} == */* ]];then
bgp[ip0]="${bgp[prefix]%%/*}"
bgp[prefixnum]="${bgp[prefix]##*/}"
fi
bgp[asn]=$(echo "$RESPONSE"|awk -v RS='<strong>' '/Originated by/ {getline; print $0}'|sed 's/<[^>]*>//g'|head -n 1)
bgp[asn]="${bgp[asn]%%,*}"
bgp[org]=$(echo "$RESPONSE"|sed -n 's/.*AS Name: <strong>\([^<]*\)<\/strong>.*/\1/p')
local last_field_name=""
local CONTENT=$(echo "$RESPONSE"|sed -n '/<div style="display: none" id="whois-page">/,/<\/div>/p'|sed -n '/<pre style="white-space: pre-wrap;">/,/<\/pre>/p'|sed 's/<pre style="white-space: pre-wrap;">//'|sed 's/<[^>]*>//g')
while IFS= read -r line;do
[[ -z $line ]]&&continue
if [[ $line == *:* ]];then
if [[ $line =~ ^([^:]+):(.*)$ ]];then
field_name="${BASH_REMATCH[1],,}"
field_value=$(echo "${BASH_REMATCH[2]}"|sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
fi
[[ -z $field_value ]]&&continue
if [[ $field_name == "$last_field_name" ]];then
getbgp["$field_name"]+=", $field_value"
elif [[ -z ${getbgp[$field_name]} ]];then
getbgp["$field_name"]="$field_value"
last_field_name="$field_name"
else
last_field_name=""
fi
fi
done <<<"$CONTENT"
get_bgp
calc_upstream $1 "$RESPONSE"
calc_ix $1
calc_peers "$RESPONSE"
}
db_henet(){
local temp_info="$Font_Cyan$Font_B${sinfo[bgp]}${Font_I}HE.NET $Font_Suffix"
((ibar_step+=4))
show_progress_bar "$temp_info" $((50-7-${sinfo[lbgp]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
getbgp=()
local last_field_name=""
local attempts=0
local max_attempts=5
local RESPONSE=""
local CONTENT=""
while [[ $attempts -lt $max_attempts ]];do
RESPONSE=$(curl $CurlARG -$1 --user-agent "$UA_Browser" --max-time 10 -Ls "https://bgp.he.net/whois/ip/$IP")
if echo "$RESPONSE"|jq empty 2>/dev/null;then
CONTENT=$(echo "$RESPONSE"|jq -r '.data' 2>/dev/null)
if [[ -n $CONTENT ]];then
break
fi
fi
((attempts++))
sleep 3
done
CONTENT=$(echo "$CONTENT"|sed 's/\\n/\n/g'|sed 's/\\t/\t/g')
while IFS= read -r line;do
[[ -z $line ]]&&continue
if [[ $line == *:* ]];then
if [[ $line =~ ^([^:]+):(.*)$ ]];then
field_name="${BASH_REMATCH[1],,}"
field_value=$(echo "${BASH_REMATCH[2]}"|sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
fi
[[ -z $field_value ]]&&continue
if [[ $field_name == "$last_field_name" ]];then
getbgp["$field_name"]+=", $field_value"
elif [[ -z ${getbgp[$field_name]} ]];then
getbgp["$field_name"]="$field_value"
last_field_name="$field_name"
else
last_field_name=""
fi
fi
done <<<"$CONTENT"
bgp[asn]="${bgp[asn]:-${getbgp[origin]:-${getbgp[originas]:-${getbgp[aut-num]}}}}"
[[ ${bgp[asn]} == "N/A" ]]&&bgp[asn]=""
bgp[prefix]="${bgp[prefix]:-${getbgp[route]:-${getbgp[route6]:-${getbgp[cidr]:-${getbgp[inetrev]}}}}}"
if [[ ${bgp[prefix]} == */* ]];then
bgp[ip0]="${bgp[prefix]%%/*}"
bgp[prefixnum]="${bgp[prefix]##*/}"
fi
get_bgp
}
get_neighbor(){
local temp_info="$Font_Cyan$Font_B${sinfo[neighbor]}$Font_Suffix"
((ibar_step+=1))
show_progress_bar "$temp_info" $((50-${sinfo[lneighbor]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
local convert_output
local cidr="${IP%.*}.0/24"
if [[ ${bgp[prefixnum]} != "24" ]];then
bgp[neighbortotal]="256"
convert_output=$(curl -s -m 10 --user-agent "$UA_Browser" "https://bgp.tools/pfximg/$cidr"|convert png:- txt:- 2>/dev/null)
[[ -n $convert_output ]]&&bgp[neighboractive]=$(grep -E -c "#0003FF|#4041BE" <<<"$convert_output")
fi
bgp[iptotal]="$((2**(32-${bgp[prefixnum]})))"
convert_output=$(curl -s -m 10 --user-agent "$UA_Browser" "https://bgp.tools/pfximg/${bgp[prefix]}"|convert png:- txt:- 2>/dev/null)
[[ -n $convert_output ]]&&bgp[ipactive]=$(grep -E -c "#0003FF|#4041BE" <<<"$convert_output")
}
generate_uuidv4(){
local uuid=""
local chars="0123456789abcdef"
for i in {1..36};do
if [[ $i == 9 || $i == 14 || $i == 19 || $i == 24 ]];then
uuid+="-"
elif [[ $i == 15 ]];then
uuid+="4"
elif [[ $i == 20 ]];then
r=$((RANDOM%16))
y=$((r&0x3|0x8))
uuid+=${chars:y:1}
else
r=$((RANDOM%16))
uuid+=${chars:r:1}
fi
done
echo "$uuid"
}
get_nat(){
local temp_info="$Font_Cyan$Font_B${sinfo[nat]}$Font_Suffix"
((ibar_step+=1))
show_progress_bar "$temp_info" $((50-${sinfo[lnat]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
getnat=()
if [[ $rawgithub == *"github.com"* ]];then
local result=$(stun "stun.l.google.com" 2>/dev/null)
else
local result=$(stun "stun.miwifi.com" 2>/dev/null)
fi
getnat[nat]=$(echo "$result"|grep -oE "0x[0-9A-Fa-f]+")
[[ -z ${getnat[nat]} ]]&&return 1
local val=$((${getnat[nat]}))
local portpres=$((val&0x01))
local filtering=$(((val&0x06)>>1))
local mapping=$(((val&0x08)>>3))
local hairpin=$(((val&0x10)>>4))
getnat[m]=$mapping
getnat[f]=$filtering
getnat[p]=$portpres
getnat[h]=$hairpin
local ntype="fail"
getnat[char]=0
if [[ ${getnat[nat]} == "0xFFFFFFFF" || ${getnat[nat]} == "0x0000EE" ]];then
ntype="fail"
elif [[ $mapping -eq 1 && $filtering -eq 1 ]];then
ntype="firewall"
elif [[ $mapping -eq 1 && $filtering -eq 2 ]];then
ntype="block"
elif [[ $mapping -eq 1 && $filtering -eq 3 ]];then
ntype="unknown"
elif [[ $mapping -eq 0 && $filtering -eq 0 ]];then
ntype="open"
elif [[ $mapping -eq 0 && $filtering -eq 1 ]];then
ntype="full"
getnat[char]=1
elif [[ $mapping -eq 0 && $filtering -eq 2 ]];then
ntype="rest"
getnat[char]=1
elif [[ $mapping -eq 0 && $filtering -eq 3 ]];then
ntype="portrest"
getnat[char]=1
elif [[ $mapping -eq 1 ]];then
ntype="symm"
getnat[char]=1
fi
getnat[type]=$ntype
}
get_tcp(){
local temp_info="$Font_Cyan$Font_B${sinfo[tcp]}$Font_Suffix"
((ibar_step+=1))
show_progress_bar "$temp_info" $((50-${sinfo[ltcp]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
gettcp=()
gettcp[tcpcc]=$(sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null|awk '{$1=$1};1'||echo "N/A")
gettcp[qdisc]=$(sysctl -n net.core.default_qdisc 2>/dev/null|awk '{$1=$1};1'||echo "N/A")
gettcp[rmem]=$(sysctl -n net.ipv4.tcp_rmem 2>/dev/null|awk '{$1=$1};1'||echo "N/A")
gettcp[wmem]=$(sysctl -n net.ipv4.tcp_wmem 2>/dev/null|awk '{$1=$1};1'||echo "N/A")
}
calculate_delay(){
local delay=0x2800
local num1=$1
local num2=$2
if [[ $(echo "$num1 > 0 && $num1 <= 80"|bc) -eq 1 ]];then
delay=$((delay+0x40))
elif [[ $(echo "$num1 > 80 && $num1 <= 160"|bc) -eq 1 ]];then
delay=$((delay+0x44))
elif [[ $(echo "$num1 > 160 && $num1 <= 240"|bc) -eq 1 ]];then
delay=$((delay+0x46))
elif [[ $(echo "$num1 > 200"|bc) -eq 1 ]];then
delay=$((delay+0x47))
fi
if [[ $(echo "$num2 > 0 && $num2 <= 80"|bc) -eq 1 ]];then
delay=$((delay+0x80))
elif [[ $(echo "$num2 > 80 && $num2 <= 160"|bc) -eq 1 ]];then
delay=$((delay+0xA0))
elif [[ $(echo "$num2 > 160 && $num2 <= 240"|bc) -eq 1 ]];then
delay=$((delay+0xB0))
elif [[ $(echo "$num2 > 240"|bc) -eq 1 ]];then
delay=$((delay+0xB8))
fi
local delay_hex=$(printf "%X" "$delay")
local unicode_char=$(echo -e "\u${delay_hex: -4}")
if [[ $(echo "$num1 > 240"|bc) -eq 1 || $(echo "$num2 > 240"|bc) -eq 1 || $(echo "$num1 == 0"|bc) -eq 1 || $(echo "$num2 == 0"|bc) -eq 1 ]];then
echo "$Font_Red$unicode_char"
elif [[ $(echo "$num1 > 150"|bc) -eq 1 || $(echo "$num2 > 150"|bc) -eq 1 ]];then
echo "$Font_Yellow$unicode_char"
elif [[ $(echo "$num1 <= 150"|bc) -eq 1 && $(echo "$num2 <= 150"|bc) -eq 1 ]];then
echo "$Font_Green$unicode_char"
else
echo "$Font_Red$unicode_char"
fi
}
ping_test(){
local domain=$1
local protocol=$2
local psize=$3
local count=$4
local pv=$5
local provider=$6
local ipv=$7
local port=$8
[[ -z $domain || -z $ipv || -z $protocol || -z $psize || -z $count || -z $pv || -z $provider ]]&&return 1
[[ $ipv != "4" && $ipv != "6" ]]&&return 1
[[ $protocol != "ICMP" && $protocol != "TCP" && $protocol != "UDP" ]]&&return 1
[[ -z $port ]]&&port=80
local response
local tmpresu=""
local pingcom=""
if [[ $protocol == "ICMP" ]];then
pingcom="mtr -$ipv -c 1 -f 100 -C -G 1 -s $psize $domain"
elif [[ $protocol == "TCP" ]];then
pingcom="mtr -$ipv --tcp -P $port -c 1 -f 100 -C -G 1 -s $psize $domain"
elif [[ $protocol == "UDP" ]];then
pingcom="mtr -$ipv --udp -P $port -c 1 -f 100 -C -G 1 -s $psize $domain"
fi
response=$($pingcom 2>&1)
tmpresu=$(echo "$response"|tr -d '\n'|awk -F',' '{print $24}')
[[ -z $tmpresu || ! $tmpresu =~ ^[0-9]+(\.[0-9]+)?$ || ${#tmpresu} -gt 6 ]]&&tmpresu=0.00
echo "$pv $provider $ipv $count $tmpresu"
}
process_pingtestresult(){
local testresult=$1
local -A midresu
local tmp_space=""
local ipv
local index
local numbers
local total
local count
local lost
local result
[[ $mode_ping -eq 1 ]]&&tmp_space=" "
IFS=$'\n' read -r -d '' -a lines <<<"$testresult"
for line in "${lines[@]}";do
line=$(echo "$line"|xargs)
[[ -z $line ]]&&continue
IFS=' ' read -ra parts <<<"$line"
index="${parts[0]}${parts[1]}${parts[2]}${parts[3]}"
ipv="${parts[2]}"
pout[$index]="${parts[4]}"
done
for province in $(echo "${!pcode[@]}"|sort -n);do
for j in 1 2 3;do
total=0
count=0
lost=""
for i in $(seq 1 $ping_test_count);do
numbers=${pout[$province$j$ipv$i]}
if [[ $numbers =~ ^0\.0*$ ]];then
lost="$Font_Red"
else
total=$(echo "$total + $numbers"|bc)
((count++))
fi
done
if ((count>0));then
local avg=$(echo "scale=0; $total / $count"|bc)
else
local avg=0
fi
result=""
for ((i=1; i<ping_test_count; i+=2));do
local A="${pout[$province$j$ipv$i]}"
local B="${pout[$province$j$ipv$((i+1))]}"
local char=$(calculate_delay "$A" "$B")
result+="$char"
done
if [[ $avg -gt 240 || $lost == "$Font_Red" ]];then
lost="$Font_Red"
elif [[ $avg -gt 150 ]];then
lost="$Font_Yellow"
elif [[ $avg -le 150 ]];then
lost="$Font_Green"
else
lost="$Font_Red"
fi
pavg[$province$j$ipv]="$avg"
midresu[$province$j$ipv]="$Font_Green$result$lost$Font_B$(printf '%-3s' "$avg")$Font_Suffix"
done
local prov_space=""
[[ $mode_ping -eq 1 ]]&&prov_space=" "
if [[ $YY == "cn" ]];then
presu[$province]="$Font_Cyan${pshort[$province]}$prov_space${midresu[${province}1$ipv]}$tmp_space${midresu[${province}2$ipv]}$tmp_space${midresu[${province}3$ipv]}"
else
presu[$province]="$Font_Cyan${pcode[$province]}$prov_space${midresu[${province}1$ipv]}$tmp_space${midresu[${province}2$ipv]}$tmp_space${midresu[${province}3$ipv]}"
fi
done
}
get_delay(){
local temp_info="$Font_Cyan$Font_B${sinfo[delay]}$Font_Suffix"
((ibar_step+=1))
show_progress_bar "$temp_info" $((50-${sinfo[ldelay]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
[[ $mode_ping -eq 1 ]]&&ping_test_count=44
local max_threads=93
local available_memory=1024
[[ "$(uname)" != "Darwin" ]]&&available_memory=$(free -m|awk '/Mem:/ {print $7}')
local max_threads_by_memory=$(echo "$available_memory / 8"|bc)
((max_threads_by_memory<max_threads))&&max_threads=$max_threads_by_memory
local current_threads=0
local tmpresult=$(for i in $(seq 1 $ping_test_count)
do
for province in $(echo "${!pcode[@]}"|sort -n);do
for j in 1 2 3;do
ping_test "${pdm[$province$j$1]}" "TCP" 1400 "$i" "$province" "$j" "$1"&
((current_threads++))
if ((current_threads>=max_threads));then
wait -n
((current_threads--))
fi
done
done
done
wait)
process_pingtestresult "$tmpresult"
}
show_delay(){
local count=0
local resu_per_line=$(((display_max_len+1)/(ping_test_count*3/2+12)))
if [[ $mode_ping -eq 1 ]];then
resu_per_line=1
echo -ne "\r${sdelay[pingmode]}\n"
else
count=2
echo -ne "\r${sdelay[title]}"
fi
for key in $(echo "${!pcode[@]}"|tr ' ' '\n'|sort -n);do
((count++))
if ((resu_per_line==1));then
echo -ne "\r${presu[$key]}\n"
elif ((count%resu_per_line==0));then
echo -ne "${presu[$key]}\n"
elif ((count%resu_per_line==1));then
echo -ne "\r${presu[$key]} "
else
echo -ne "${presu[$key]} "
fi
done
((count%resu_per_line!=0))&&echo
}
nexttrace_test(){
local domain="$1"
local rmode="$2"
local rnum="$3"
local ipv="$4"
local response
local max_retries=10
local retry_delay=5
local retry_count=0
while [[ $retry_count -lt $max_retries ]];do
response=$(timeout -s SIGKILL 50 nexttrace -p 80 -q 8 -"$ipv" --"$rmode" --raw --psize 1400 "$domain" 2>/dev/null)
[[ $response != *"*please try again later*"* && $response == *"traceroute to"* ]]&&break
retry_count=$((retry_count+1))
[[ $retry_count -lt $max_retries ]]&&sleep "$retry_delay"
done
declare -A ips asns regions orgs
local max_hop=0
local cn_hop=0
local all_asn=""
local tresucn=""
local tresuww="NoData"
while IFS= read -r line;do
if [[ $line != *"|"* ]];then
continue
fi
IFS='|' read -r -a elements <<<"$line"
local hop="${elements[0]}"
local ip="${elements[1]}"
local asn="${elements[4]}"
local region="${elements[5]}"
[[ ${elements[6]} == "香港" || ${elements[6]} == "澳门" || ${elements[6]} == "台湾" ]]&&region="${elements[6]}"
local org="${elements[9]}"
[[ -n ${ips[$hop]} ]]&&continue
[[ $ip == 59.43.* ]]&&asn="4809"
[[ $org == *CTGNet* ]]&&asn="23764"
[[ $cn_hop == 0 && $region == *中国* ]]&&cn_hop=$hop
[[ -n $asn ]]&&all_asn="${all_asn}AS$asn "
ips["$hop"]="$ip"
asns["$hop"]="$asn"
regions["$hop"]="$region"
orgs["$hop"]="$org"
if ((hop>max_hop));then
max_hop="$hop"
fi
done <<<"$response"
[[ $cn_hop == 0 || $cn_hop == $max_hop ]]&&tresucn="Hidden"
[[ ${asns[$cn_hop]} == "17676" ]]&&cn_hop=$((cn_hop+1))
case "${asns[$cn_hop]}" in
"4134")tresucn="163"
;;
"4837")tresucn="4837"
if ((cn_hop>1));then
[[ ${asns[$((cn_hop-1))]} == "10099" ]]&&tresucn="10099"
fi
;;
"58453")tresucn="CMI"
;;
"58807")tresucn="CMIN2"
;;
"9808")tresucn="CMI"
[[ $all_asn == *AS58807* ]]&&tresucn="CMIN2"
;;
"9929")tresucn="9929"
;;
"10099")tresucn="10099"
[[ $all_asn == *AS9929* ]]&&tresucn="9929"
;;
"4809")tresucn="CN2GIA"
if ((cn_hop>1));then
[[ $all_asn == *AS23764* ]]&&tresucn="CTGGIA"
else
for ((hop=cn_hop; hop<=max_hop; hop++));do
[[ ${asns[$hop]} == "4809" || ${asns[$hop]} == "23764" ]]&&continue
if [[ ${ips[$hop]} == 202.97* ]];then
tresucn="CN2GT"
fi
break
done
fi
;;
"23764")tresucn="CTGGIA"
;;
"4538")tresucn="CERNET"
;;
"7497")tresucn="CSTNET"
;;
*)tresucn="NoData"
if [[ $all_asn == *AS58807* ]];then
tresucn="CMIN2"
elif [[ $all_asn == *AS9929* ]];then
tresucn="9929"
elif [[ $all_asn == *AS10099* ]];then
tresucn="10099"
elif [[ $all_asn == *AS4809* ]];then
tresucn="CN2"
elif [[ $all_asn == *AS9808* ]];then
tresucn="CMI"
elif [[ $all_asn == *AS4134* ]];then
tresucn="163"
elif [[ $all_asn == *AS4837* ]];then
tresucn="4837"
fi
esac
for ((hop=cn_hop-1; hop>0; hop--));do
if [[ -n ${asns[$hop]} && ${asns[$hop]} != "58453" && ${asns[$hop]} != "58807" && ${asns[$hop]} != "4837" && ${asns[$hop]} != "10099" && ${asns[$hop]} != "9929" && ${asns[$hop]} != "4134" && ${asns[$hop]} != "4809" && ${asns[$hop]} != "4808" && ${asns[$hop]} != "23764" && ${asns[$hop]} != "4538" && ${asns[$hop]} != "7497" ]];then
tresuww="AS${asns[$hop]}"
break
fi
done
if [[ -n $tresuww ]];then
[[ -n ${AS_MAPPING[$tresuww]} ]]&&tresuww="${AS_MAPPING[$tresuww]}"
fi
echo "$rnum $tresuww $tresucn"
}
mtr_test(){
local domain="$1"
local rmode="$2"
local rnum="$3"
local ipv="$4"
declare -A ips
declare -A asns
local max_hop=0
local cn_hop=0
local all_asn=""
local tresucn="NoData"
local tresuww="NoData"
local max_retries=10
local retry_delay=5
local retry_count=0
while [[ $retry_count -lt $max_retries ]];do
response=$(timeout 60 mtr -"$ipv" --"$rmode" --no-dns -y 0 -P 80 -c 8 -C -Z 1 -G 1 -s 1400 "$domain" 2>/dev/null)
[[ $response != *"*mtr:*"* && $response == *"OK,"* ]]&&break
retry_count=$((retry_count+1))
[[ $retry_count -lt $max_retries ]]&&sleep "$retry_delay"
done
while IFS= read -r line;do
[[ $line != *"OK,"* ]]&&continue
IFS=',' read -r -a elements <<<"$line"
local hop="${elements[4]}"
local ip="${elements[5]}"
[[ ${elements[6]} != *"?"* ]]&&local asn="${elements[6]#AS}"
ips["$hop"]="$ip"
asns["$hop"]="$asn"
[[ -n $asn && $asn != *"?"* ]]&&all_asn="$all_asn$asn "
((hop>max_hop))&&max_hop="$hop"
[[ $cn_hop -eq 0 ]]&&[[ $asn =~ ^("58453"|"58807"|"4837"|"10099"|"9929"|"4134"|"4809"|"23764"|"4538"|"7497")$ ]]&&cn_hop="$hop"
done <<<"$response"
[[ $cn_hop == 0 || $cn_hop == $max_hop ]]&&tresucn="Hidden"
[[ ${asns[$cn_hop]} == "17676" ]]&&cn_hop=$((cn_hop+1))
case "${asns[$cn_hop]}" in
"4134")tresucn="163"
if [[ $all_asn == *AS9929* ]];then
tresucn="9929"
elif [[ $all_asn == *AS10099* ]];then
tresucn="10099"
elif [[ $all_asn == *AS23764* && $all_asn == *AS4134* ]];then
tresucn="CN2GT"
elif [[ $all_asn == *AS4809* && $all_asn == *AS4134* ]];then
tresucn="CN2GT"
elif [[ $all_asn == *AS23764* ]];then
tresucn="CTGGIA"
elif [[ $all_asn == *AS4809* ]];then
tresucn="CN2GIA"
elif [[ $all_asn == *AS58807* ]];then
tresucn="CMIN2"
fi
;;
"4837")tresucn="4837"
if [[ $all_asn == *AS9929* ]];then
tresucn="9929"
elif [[ $all_asn == *AS10099* ]];then
tresucn="10099"
elif [[ $all_asn == *AS23764* && $all_asn == *AS4134* ]];then
tresucn="CN2GT"
elif [[ $all_asn == *AS4809* && $all_asn == *AS4134* ]];then
tresucn="CN2GT"
elif [[ $all_asn == *AS23764* ]];then
tresucn="CTGGIA"
elif [[ $all_asn == *AS4809* ]];then
tresucn="CN2GIA"
elif [[ $all_asn == *AS58807* ]];then
tresucn="CMIN2"
fi
;;
"58453")tresucn="CMI"
if [[ $all_asn == *AS9929* ]];then
tresucn="9929"
elif [[ $all_asn == *AS10099* ]];then
tresucn="10099"
elif [[ $all_asn == *AS23764* && $all_asn == *AS4134* ]];then
tresucn="CN2GT"
elif [[ $all_asn == *AS4809* && $all_asn == *AS4134* ]];then
tresucn="CN2GT"
elif [[ $all_asn == *AS23764* ]];then
tresucn="CTGGIA"
elif [[ $all_asn == *AS4809* ]];then
tresucn="CN2GIA"
elif [[ $all_asn == *AS58807* ]];then
tresucn="CMIN2"
fi
;;
"58807")tresucn="CMIN2"
;;
"9808")tresucn="CMI"
if [[ $all_asn == *AS9929* ]];then
tresucn="9929"
elif [[ $all_asn == *AS10099* ]];then
tresucn="10099"
elif [[ $all_asn == *AS23764* && $all_asn == *AS4134* ]];then
tresucn="CN2GT"
elif [[ $all_asn == *AS4809* && $all_asn == *AS4134* ]];then
tresucn="CN2GT"
elif [[ $all_asn == *AS23764* ]];then
tresucn="CTGGIA"
elif [[ $all_asn == *AS4809* ]];then
tresucn="CN2GIA"
elif [[ $all_asn == *AS58807* ]];then
tresucn="CMIN2"
fi
;;
"9929")tresucn="9929"
;;
"10099")tresucn="10099"
[[ $all_asn == *AS9929* ]]&&tresucn="9929"
;;
"4809")tresucn="CN2GIA"
if ((cn_hop>1));then
[[ $all_asn == *AS23764* ]]&&tresucn="CTGGIA"
else
for ((hop=cn_hop; hop<=max_hop; hop++));do
[[ ${asns[$hop]} == "4809" || ${asns[$hop]} == "23764" ]]&&continue
if [[ ${ips[$hop]} == 202.97* ]];then
tresucn="CN2GT"
fi
break
done
fi
;;
"23764")tresucn="CTGGIA"
;;
"4538")tresucn="CERNET"
;;
"7497")tresucn="CSTNET"
;;
*)tresucn="NoData"
if [[ $all_asn == *AS58807* ]];then
tresucn="CMIN2"
elif [[ $all_asn == *AS9929* ]];then
tresucn="9929"
elif [[ $all_asn == *AS10099* ]];then
tresucn="10099"
elif [[ $all_asn == *AS4809* ]];then
tresucn="CN2"
elif [[ $all_asn == *AS9808* ]];then
tresucn="CMI"
elif [[ $all_asn == *AS4134* ]];then
tresucn="163"
elif [[ $all_asn == *AS4837* ]];then
tresucn="4837"
fi
esac
for ((hop=cn_hop-1; hop>0; hop--));do
if [[ -n ${asns[$hop]} && ${asns[$hop]} != "58453" && ${asns[$hop]} != "58807" && ${asns[$hop]} != "4837" && ${asns[$hop]} != "10099" && ${asns[$hop]} != "9929" && ${asns[$hop]} != "4134" && ${asns[$hop]} != "4809" && ${asns[$hop]} != "23764" && ${asns[$hop]} != "4538" && ${asns[$hop]} != "7497" ]];then
tresuww="AS${asns[$hop]}"
break
fi
done
if [[ -n $tresuww ]];then
[[ -n ${AS_MAPPING[$tresuww]} ]]&&tresuww="${AS_MAPPING[$tresuww]}"
fi
echo "$rnum $tresuww $tresucn"
}
get_route(){
ibar_step=19
local temp_info="$Font_Cyan$Font_B${sinfo[route]}$Font_Suffix"
((ibar_step+=1))
show_progress_bar "$temp_info" $((50-${sinfo[lroute]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
local ipv=$1
local rdomain
rdomain[1]="bj-ct-v$ipv.ip.zstaticcdn.com"
rdomain[2]="bj-cu-v$ipv.ip.zstaticcdn.com"
rdomain[3]="bj-cm-v$ipv.ip.zstaticcdn.com"
rdomain[4]="sh-ct-v$ipv.ip.zstaticcdn.com"
rdomain[5]="sh-cu-v$ipv.ip.zstaticcdn.com"
rdomain[6]="sh-cm-v$ipv.ip.zstaticcdn.com"
rdomain[7]="gd-ct-v$ipv.ip.zstaticcdn.com"
rdomain[8]="gd-cu-v$ipv.ip.zstaticcdn.com"
rdomain[9]="gd-cm-v$ipv.ip.zstaticcdn.com"
local max_threads=18
local available_memory=1024
[[ "$(uname)" != "Darwin" ]]&&available_memory=$(free -m|awk '/Mem:/ {print $7}')
local max_threads_by_memory=$(echo "$available_memory / 28"|bc)
((max_threads_by_memory<max_threads))&&max_threads=$max_threads_by_memory
local current_threads=0
local tmpresult=$(for i in $(seq 1 18)
do
local protocol="tcp"
((i%2==0))&&protocol="udp"
if [[ $protocol == "udp" && $ipv == "6" ]];then
mtr_test "${rdomain[$(((i+1)/2))]}" "$protocol" "$i" "$ipv"&
else
nexttrace_test "${rdomain[$(((i+1)/2))]}" "$protocol" "$i" "$ipv"&
fi
((current_threads++))
if ((current_threads>=max_threads));then
wait -n
((current_threads--))
else
sleep 2
fi
done
wait)
while IFS= read -r line;do
[[ -z $line ]]&&continue
read -r index rww_value rcn_value <<<"$line"
[[ $rcn_value == *GIA ]]&&rgia=1
done <<<"$tmpresult"
while IFS= read -r line;do
[[ -z $line ]]&&continue
read -r index rww_value rcn_value <<<"$line"
rww["$index"]="$rww_value"
rcn["$index"]="$rcn_value"
[[ ${rcn["$index"]} == "CN2GT" && $rgia -eq 1 ]]&&rcn["$index"]="CN2GIA"
printf -v spaceww "%$((8-${#rww_value}))s" ""
printf -v spacecn "%$((6-${#rcn_value}))s" ""
case "$rww_value" in
"Hidden")colorww="$Back_Red$Font_White$Font_U$Font_B";;
"NoData")colorww="$Back_Yellow$Font_White$Font_U$Font_B";;
*)colorww="$Back_Blue$Font_White$Font_U$Font_B"
esac
case "$rcn_value" in
"Hidden")colorcn="$Back_Red$Font_White$Font_U$Font_B";;
"NoData")colorcn="$Back_Yellow$Font_White$Font_U$Font_B";;
*)colorcn="$Back_Green$Font_White$Font_U$Font_B"
esac
routww["$index"]="$spaceww$colorww$rww_value$Font_Suffix"
routcn["$index"]="$colorcn$rcn_value$Font_Suffix$spacecn"
done <<<"$tmpresult"
}
function colorize_latency(){
local latency_ms=$1
local total_length=${2:-2}
local value
local pure_text
local padding
local colored_result
if [[ ! $latency_ms =~ ^[0-9]+(\.[0-9]+)?ms$ ]];then
echo ""
return 1
fi
value=$(echo "$latency_ms"|sed 's/ms//')
if (($(echo "$value <= 150"|bc -l)));then
colored_result="$Font_Green$latency_ms"
elif (($(echo "$value <= 240"|bc -l)));then
colored_result="$Font_Yellow$latency_ms"
else
colored_result="$Font_Red$latency_ms"
fi
pure_text="$latency_ms"
pure_length=${#pure_text}
if ((pure_length<total_length));then
padding=$((total_length-pure_length))
colored_result="$(printf "%${padding}s" "")$colored_result"
fi
colored_result="$colored_result$Font_Suffix"
echo -n "$colored_result"
return 0
}
show_route(){
echo -ne "\r${sroute[title]}\n"
if [[ $mode_route -eq 0 ]];then
echo -ne "\r$Font_Cyan北京TCP：$Font_Green电信 $Font_Suffix${routww[1]}$Font_Green->$Font_Suffix${routcn[1]} || $Font_Green联通$Font_Suffix $Font_Suffix${routww[3]}$Font_Green->$Font_Suffix${routcn[3]} || $Font_Green移动$Font_Suffix $Font_Suffix${routww[5]}$Font_Green->$Font_Suffix${routcn[5]}\n"
echo -ne "\r$Font_Cyan北京UDP：$Font_Green电信 $Font_Suffix${routww[2]}$Font_Green->$Font_Suffix${routcn[2]} || $Font_Green联通$Font_Suffix $Font_Suffix${routww[4]}$Font_Green->$Font_Suffix${routcn[4]} || $Font_Green移动$Font_Suffix $Font_Suffix${routww[6]}$Font_Green->$Font_Suffix${routcn[6]}\n"
echo -ne "\r$Font_Cyan上海TCP：$Font_Green电信 $Font_Suffix${routww[7]}$Font_Green->$Font_Suffix${routcn[7]} || $Font_Green联通$Font_Suffix $Font_Suffix${routww[9]}$Font_Green->$Font_Suffix${routcn[9]} || $Font_Green移动$Font_Suffix $Font_Suffix${routww[11]}$Font_Green->$Font_Suffix${routcn[11]}\n"
echo -ne "\r$Font_Cyan上海UDP：$Font_Green电信 $Font_Suffix${routww[8]}$Font_Green->$Font_Suffix${routcn[8]} || $Font_Green联通$Font_Suffix $Font_Suffix${routww[10]}$Font_Green->$Font_Suffix${routcn[10]} || $Font_Green移动$Font_Suffix $Font_Suffix${routww[12]}$Font_Green->$Font_Suffix${routcn[12]}\n"
echo -ne "\r$Font_Cyan广州TCP：$Font_Green电信 $Font_Suffix${routww[13]}$Font_Green->$Font_Suffix${routcn[13]} || $Font_Green联通$Font_Suffix $Font_Suffix${routww[15]}$Font_Green->$Font_Suffix${routcn[15]} || $Font_Green移动$Font_Suffix $Font_Suffix${routww[17]}$Font_Green->$Font_Suffix${routcn[17]}\n"
echo -ne "\r$Font_Cyan广州UDP：$Font_Green电信 $Font_Suffix${routww[14]}$Font_Green->$Font_Suffix${routcn[14]} || $Font_Green联通$Font_Suffix $Font_Suffix${routww[16]}$Font_Green->$Font_Suffix${routcn[16]} || $Font_Green移动$Font_Suffix $Font_Suffix${routww[18]}$Font_Green->$Font_Suffix${routcn[18]}\n"
else
local tmppv=""
local tmpfont=""
local tmpback=""
local tmpdelay=""
for ((i=1; i<=rmtestnum; i++));do
ii=$(printf "%02d" "$i")
case $((i%3)) in
1)tmppv="电信"
tmpfont="$Font_Cyan"
tmpback="$Back_Cyan"
;;
2)tmppv="联通"
tmpfont="$Font_Green"
tmpback="$Back_Green"
;;
0)tmppv="移动"
tmpfont="$Font_Purple"
tmpback="$Back_Purple"
esac
echo -ne "\r$tmpback$Font_White$Font_B  ${pname[${rmcode[$i]}]} $tmppv  $Font_Suffix$Back_White$tmpfont$Font_B  ${rmww[$ii]} -> ${rmcn[$ii]}  $Font_Suffix\n"
echo -ne "\r$Back_Blue$Font_White地理路径：${rmallgeo[$ii]}    自治系统路径：${rmallasn[$ii]} $Font_Suffix\n"
local varb="${rmmaxhop[$ii]:-0}"
varb=${varb#0}
local mergejump="   "
for ((j=1; j<=varb; j++));do
jj=$(printf "%02d" "$j")
mergeroute=0
mergejump="   "
if [[ -n ${rmresu[$ii${jj}2]} ]];then
local compA="${rmresu[$ii${jj}5]#"${rmresu[$ii${jj}5]%%[![:space:]\*]*}"}"
compA=$(awk '{print $1 " " $2}' <<<"$compA")
for ((k=j+1; k<varb; k++));do
kk=$(printf "%02d" "$k")
local compB="${rmresu[$ii${kk}5]#"${rmresu[$ii${kk}5]%%[![:space:]\*]*}"}"
compB=$(awk '{print $1 " " $2}' <<<"$compB")
if [[ -n ${rmresu[$ii${kk}2]} &&
${rmresu[$ii${jj}3]} == "${rmresu[$ii${kk}3]}" &&
${rmresu[$ii${jj}4]} == "${rmresu[$ii${kk}4]}" ]]&&[[ $compA == *"$compB"* ||
$compB == *"$compA"* ]];then
mergejump="-$(printf '%-2s' "$k")"
continue
fi
[[ -n ${rmresu[$ii${kk}2]} ]]&&break
done
if ((j!=varb));then
for ((k=j-1; k>0; k--));do
kk=$(printf "%02d" "$k")
local compB="${rmresu[$ii${kk}5]#"${rmresu[$ii${kk}5]%%[![:space:]\*]*}"}"
compB=$(awk '{print $1 " " $2}' <<<"$compB")
if [[ -n ${rmresu[$ii${kk}2]} &&
${rmresu[$ii${jj}3]} == "${rmresu[$ii${kk}3]}" &&
${rmresu[$ii${jj}4]} == "${rmresu[$ii${kk}4]}" ]]&&[[ $compA == *"$compB"* ||
$compB == *"$compA"* ]];then
continue 2
fi
done
fi
tmpdelay=$(colorize_latency "${rmresu[$ii${jj}1]}" 9)
if [[ $1 -eq 4 ]];then
echo -ne "\r$Font_B$(printf '%2s' "$j")$mergejump$Font_Suffix $tmpdelay  $(printf '%-13s' "${rmresu[$ii${jj}2]}")$Font_B$(printf '%-10s' "${rmresu[$ii${jj}3]}")$(printf '%-18s' "${rmresu[$ii${jj}4]}")$Font_Suffix${rmresu[$ii${jj}5]}\n"
else
echo -ne "\r$Font_B$(printf '%2s' "$j")$mergejump$Font_Suffix $tmpdelay  $(printf '%-27s' "${rmresu[$ii${jj}2]}")$Font_B$(printf '%-10s' "${rmresu[$ii${jj}3]}")$Font_Suffix${rmresu[$ii${jj}5]}\n"
fi
fi
done
done
fi
}
function mask_ip(){
local ip=$1
if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then
echo "$ip"|awk -F. '{print $1"."$2".*.*"}'
elif [[ $ip =~ ^([0-9a-fA-F]{0,4}:){2,7}[0-9a-fA-F]{0,4}$ ]];then
echo "$ip"|awk -F: '{
            # 计算需要保留的段数(总段数8减去要掩码的5段)
            keep = 8 - 5;
            for(i=1; i<=NF; i++) {
                if(i <= keep) {
                    printf "%s", $i;
                } else {
                    printf "*";
                }
                if(i < 8) printf ":";
            }
            # 处理压缩形式的IPv6(::)
            if(NF < 8) {
                for(i=NF+1; i<=8; i++) {
                    if(i <= keep) {
                        printf "0";
                    } else {
                        printf "*";
                    }
                    if(i < 8) printf ":";
                }
            }
        }'
else
return 1
fi
}
function extract_region(){
local input=$1
IFS=' ' read -ra parts <<<"$input"
local discard_patterns=("*" "中国" "电信" "联通" "移动")
local suffixes=("省" "市" "县" "维吾尔自治区" "回族自治区" "壮族自治区" "自治区" "特别行政区")
for part in "${parts[@]}";do
if [[ -z $part || $part =~ ^[[:punct:]]+$ || $part == *"."* || $part == *"RFC"* || $part == *"rfc"* || $part == *"Private"* || $part == *"Local"* || $part == *"DOD"* || $part == *"Anycast"* || $part == *"ASAPI"* || $part == *"网络故障"* ]];then
continue
fi
for pattern in "${discard_patterns[@]}";do
[[ $part == "$pattern" ]]&&continue 2
done
for suffix in "${suffixes[@]}";do
if [[ $part == *"$suffix" ]];then
part="${part%"$suffix"}"
break
fi
done
echo "$part"
return
done
echo ""
}
nexttrace_route(){
local domain="$1"
local rmode="$2"
local rnum="$3"
local ipv="$4"
local tmode
case "$rmode" in
1)tmode="--tcp";;
2)tmode="--udp"
esac
local output
local max_retries=10
local retry_delay=5
local retry_count=0
while [[ $retry_count -lt $max_retries ]];do
output=$(timeout -s SIGKILL 50 nexttrace -p 80 -q 8 -"$ipv" "$tmode" --psize 1400 "$domain" 2>/dev/null)
[[ $output != *"*please try again later*"* && $output == *"traceroute to"* ]]&&break
retry_count=$((retry_count+1))
[[ $retry_count -lt $max_retries ]]&&sleep "$retry_delay"
done
output=$(echo "$output"|sed 's/\x1b\[[0-9;]*m//g')
echo "$output"|awk -v rnum="$rnum" '
    {
        if ($1 ~ /^[0-9]+$/) {
            hop = $1
            ip = $2
            if (ip != "*") {
                as = ""
                bracket = ""
                desc = ""
                ms = ""
                # Extract AS information
                for (i = 3; i <= NF; i++) {
                    if ($i ~ /^AS[0-9]+/) {
                        as = $i
                    } else if ($i ~ /^\[.*\]$/) {
                        bracket = $i
                    } else {
                        desc = desc " " $i
                    }
                }
                # 去除 desc 开头的空格
                sub(/^ /, "", desc)
                # Get the first millisecond value from the next line
                getline next_line
                if (next_line ~ /[0-9]+\.[0-9]+ ms/) {
                    match(next_line, /[0-9]+\.[0-9]+ ms/)
                    ms = substr(next_line, RSTART, RLENGTH)
                    gsub(/ /, "", ms)
                }
                # Print the formatted result
                printf "|%s|%s|%s|%s|%s|%s|%s|\n", rnum, hop, ms, ip, as, bracket, desc
            }
        }
    }'
}
get_route_mode(){
ibar_step=19
local temp_info="$Font_Cyan$Font_B${sinfo[moderoute]}$Font_Suffix"
((ibar_step+=1))
show_progress_bar "$temp_info" $((50-${sinfo[lmoderoute]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
local ipv=$1
local rdomain
rmresu=()
rmcode[0]=31
if [[ -z $mode_route_pv ]];then
rmtestnum=9
rmcode[1]=11
rmcode[2]=11
rmcode[3]=11
rmcode[4]=31
rmcode[5]=31
rmcode[6]=31
rmcode[7]=44
rmcode[8]=44
rmcode[9]=44
rdomain[0]="sh-ct-v$ipv.ip.zstaticcdn.com"
rdomain[1]="bj-ct-v$ipv.ip.zstaticcdn.com"
rdomain[2]="bj-cu-v$ipv.ip.zstaticcdn.com"
rdomain[3]="bj-cm-v$ipv.ip.zstaticcdn.com"
rdomain[4]="sh-ct-v$ipv.ip.zstaticcdn.com"
rdomain[5]="sh-cu-v$ipv.ip.zstaticcdn.com"
rdomain[6]="sh-cm-v$ipv.ip.zstaticcdn.com"
rdomain[7]="gd-ct-v$ipv.ip.zstaticcdn.com"
rdomain[8]="gd-cu-v$ipv.ip.zstaticcdn.com"
rdomain[9]="gd-cm-v$ipv.ip.zstaticcdn.com"
else
rmtestnum=3
rmcode[1]="$mode_route_pv"
rmcode[2]="$mode_route_pv"
rmcode[3]="$mode_route_pv"
rdomain[0]="sh-ct-v$ipv.ip.zstaticcdn.com"
rdomain[1]="${pcode[$mode_route_pv]}-ct-v$ipv.ip.zstaticcdn.com"
rdomain[2]="${pcode[$mode_route_pv]}-cu-v$ipv.ip.zstaticcdn.com"
rdomain[3]="${pcode[$mode_route_pv]}-cm-v$ipv.ip.zstaticcdn.com"
fi
local max_threads=18
local available_memory=1024
[[ "$(uname)" != "Darwin" ]]&&available_memory=$(free -m|awk '/Mem:/ {print $7}')
local max_threads_by_memory=$(echo "$available_memory / 28"|bc)
((max_threads_by_memory<max_threads))&&max_threads=$max_threads_by_memory
local current_threads=0
local tmpresult=$(for i in $(seq 0 $rmtestnum)
do
local protocol=1
nexttrace_route "${rdomain[$i]}" "$protocol" "$i" "$ipv"&
((current_threads++))
if ((current_threads>=max_threads));then
wait -n
((current_threads--))
else
sleep 2
fi
done
wait)
rmmaxhop=()
rmcnhop=()
rmallasn=()
rmallgeo=()
while IFS= read -r line;do
[[ -z $line ]]&&continue
IFS='|' read -ra fields <<<"$line"
i1=$(printf "%02d" "${fields[1]}")
i2=$(printf "%02d" "${fields[2]}")
rmresu["$i1${i2}1"]="${fields[3]}"
rmresu["$i1${i2}2"]=$(mask_ip "${fields[4]}")
rmresu["$i1${i2}3"]="${fields[5]}"
rmresu["$i1${i2}4"]="${fields[6]}"
rmresu["$i1${i2}5"]="${fields[7]}"
rmresu["$i1${i2}6"]=$(extract_region "${rmresu[$i1${i2}5]}")
[[ ${rmresu["$i1${i2}2"]} == 59.43.* ]]&&rmresu["$i1${i2}3"]="AS4809"
[[ ${rmresu["$i1${i2}5"]} == *CTGNet* ]]&&rmresu["$i1${i2}3"]="AS23764"
if [[ -z ${rmcnhop["$i1"]} ]]&&[[ ${rmresu["$i1${i2}5"]} == *中国* ]]&&[[ ${rmresu["$i1${i2}5"]} != *香港* ]]&&[[ ${rmresu["$i1${i2}5"]} != *澳门* ]]&&[[ ${rmresu["$i1${i2}5"]} != *台湾* ]];then
rmcnhop["$i1"]="$i2"
fi
if [[ -n ${rmresu[$i1${i2}6]} ]];then
if [[ ${rmallgeo[$i1]} == *"${rmresu[$i1${i2}6]}"* ]];then
rmallgeo[$i1]="${rmallgeo[$i1]%${rmresu[$i1${i2}6]}*}${rmresu[$i1${i2}6]}"
else
[[ -n ${rmallgeo[$i1]} ]]&&rmallgeo[$i1]="${rmallgeo[$i1]} -> "
rmallgeo[$i1]="${rmallgeo[$i1]}${rmresu[$i1${i2}6]}"
fi
fi
if [[ ${rmallgeo[$i1]} != *"${rmresu[$i1${i2}6]}" ]];then
[[ -n ${rmallgeo[$i1]} ]]&&rmallgeo[$i1]="${rmallgeo[$i1]} -> "
rmallgeo[$i1]="${rmallgeo[$i1]}${rmresu[$i1${i2}6]}"
fi
if [[ -n ${rmresu["$i1${i2}3"]} && ${rmallasn[$i1]} != *"${rmresu[$i1${i2}3]}" ]];then
[[ -n ${rmallasn["$i1"]} ]]&&rmallasn["$i1"]="${rmallasn["$i1"]} -> "
rmallasn["$i1"]="${rmallasn["$i1"]}${rmresu[$i1${i2}3]}"
fi
local vara=${i2#0}
local varb="${rmmaxhop["$i1"]:-0}"
varb=${varb#0}
if ((vara>varb));then
rmmaxhop["$i1"]="$i2"
fi
done <<<"$tmpresult"
rmcn=()
rmww=()
for i in $(seq 0 $rmtestnum);do
ii=$(printf "%02d" "$i")
rmcn[$ii]="Unknown"
rmww[$ii]="Unknown"
[[ ${rmcnhop[$ii]} == 0 || ${rmcnhop[$ii]} == ${rmmaxhop[$ii]} ]]&&rmcn[$ii]="Hidden"
local vara="${rmcnhop[$ii]:-0}"
vara=${vara#0}
[[ ${rmresu[$ii${rmcnhop[$ii]}3]} == "AS17676" ]]&&rmcnhop[$ii]=$(printf "%02d" "$((vara+1))")
case "${rmresu[$ii${rmcnhop[$ii]}3]}" in
"AS4134")rmcn[$ii]="163"
;;
"AS4837")rmcn[$ii]="4837"
local vara="${rmcnhop[$ii]:-0}"
vara=${vara#0}
if ((vara>1));then
varb=$(printf "%02d" "$((vara-1))")
[[ ${rmresu[$ii${varb}3]} == "AS10099" ]]&&rmcn[$ii]="10099"
fi
;;
"AS58453")rmcn[$ii]="CMI"
;;
"AS58807")rmcn[$ii]="CMIN2"
;;
"AS9808")rmcn[$ii]="CMI"
[[ ${rmallasn[$ii]} == *AS58807* ]]&&rmcn[$ii]="CMIN2"
;;
"AS9929")rmcn[$ii]="9929"
;;
"AS10099")rmcn[$ii]="10099"
[[ ${rmallasn[$ii]} == *AS9929* ]]&&rmcn[$ii]="9929"
;;
"AS4809")rmcn[$ii]="CN2GIA"
local vara="${rmcnhop[$ii]:-0}"
local varb="${rmmaxhop[$ii]:-0}"
vara=${vara#0}
varb=${varb#0}
if ((vara>1));then
[[ ${rmallasn[$ii]} == *AS23764* ]]&&rmcn[$ii]="CTGGIA"
fi
if [[ $rmgia -ne 1 ]];then
for ((thop=vara; thop<=varb; thop++));do
hop=$(printf "%02d" "$thop")
[[ ${rmresu[$ii${hop}3]} == "AS4809" || ${rmresu[$ii${hop}3]} == "AS23764" ]]&&continue
if [[ ${rmresu[$ii${hop}2]} == 202.97* ]];then
rmcn[$ii]="CN2GT"
fi
break
done
fi
;;
"AS23764")rmcn[$ii]="CTGGIA"
if [[ $rmgia -ne 1 ]];then
local vara="${rmcnhop[$ii]:-0}"
local varb="${rmmaxhop[$ii]:-0}"
vara=${vara#0}
varb=${varb#0}
for ((thop=vara; thop<=varb; thop++));do
hop=$(printf "%02d" "$thop")
[[ ${rmresu[$ii${hop}3]} == "AS4809" || ${rmresu[$ii${hop}3]} == "AS23764" ]]&&continue
if [[ ${rmresu[$ii${hop}2]} == 202.97* ]];then
rmcn[$ii]="CN2GT"
fi
break
done
fi
;;
"AS4538")rmcn[$ii]="CERNET"
;;
"AS7497")rmcn[$ii]="CSTNET"
;;
*)rmcn[$ii]="NoData"
if [[ ${rmallasn[$ii]} == *AS58807* ]];then
rmcn[$ii]="CMIN2"
elif [[ ${rmallasn[$ii]} == *AS9929* ]];then
rmcn[$ii]="9929"
elif [[ ${rmallasn[$ii]} == *AS10099* ]];then
rmcn[$ii]="10099"
elif [[ ${rmallasn[$ii]} == *AS4809* ]];then
rmcn[$ii]="CN2"
elif [[ ${rmallasn[$ii]} == *AS9808* ]];then
rmcn[$ii]="CMI"
elif [[ ${rmallasn[$ii]} == *AS4134* ]];then
rmcn[$ii]="163"
elif [[ ${rmallasn[$ii]} == *AS4837* ]];then
rmcn[$ii]="4837"
fi
esac
[[ ${rmcn[$ii]} == *GIA ]]&&rmgia=1
local vara="${rmcnhop[$ii]:-0}"
vara=${vara#0}
for ((thop=vara-1; thop>0; thop--));do
hop=$(printf "%02d" "$thop")
if [[ -n ${rmresu[$ii${hop}3]} && ${rmresu[$ii${hop}3]} != "AS58453" && ${rmresu[$ii${hop}3]} != "AS58807" && ${rmresu[$ii${hop}3]} != "AS4837" && ${rmresu[$ii${hop}3]} != "AS10099" && ${rmresu[$ii${hop}3]} != "AS9929" && ${rmresu[$ii${hop}3]} != "AS4134" && ${rmresu[$ii${hop}3]} != "AS4809" && ${rmresu[$ii${hop}3]} != "AS4808" && ${rmresu[$ii${hop}3]} != "AS23764" && ${rmresu[$ii${hop}3]} != "AS4538" && ${rmresu[$ii${hop}3]} != "AS7497" ]];then
rmww[$ii]="${rmresu[$ii${hop}3]}"
break
fi
done
if [[ -n ${rmww[$ii]} ]];then
[[ -n ${AS_MAPPING[${rmww[$ii]}]} ]]&&rmww[$ii]="${AS_MAPPING[${rmww[$ii]}]}"
fi
done
}
parse_iperf3_result(){
local server=$1
local portl=$2
local portu=$3
local ipv="-4"
[[ $4 -eq 6 ]]&&ipv="-6"
local sendrecv=""
[[ $5 -eq 1 ]]&&sendrecv=" -R"
local maxtry=5
local port=0
iperfresu[s]=-1
iperfresu[r]=-1
local infolen
if [[ $YY == "cn" ]];then
infolen=$((${#6}*2))
else
infolen=${#6}
fi
local temp_info="$Font_Cyan$Font_B${sinfo[iperf]}$6$Font_Suffix"
((ibar_step+=2))
show_progress_bar "$temp_info" $((50-${sinfo[liperf]}-infolen))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
for ((i=1; i<=maxtry; i++));do
port=$((RANDOM%(portu-portl+1)+portl))
local response=$(timeout 20 iperf3 $ipv$sendrecv -J -t 6 -c "$server" -p "$port" 2>&1)
if [[ -n $response && $response != *"iperf3: error"* && $response != *"\"error\":"* ]];then
local bits_per_second=$(echo "$response"|jq -r '.end.sum_received.bits_per_second')
local retransmits=$(echo "$response"|jq -r '.end.sum_sent.retransmits')
if [[ -n $bits_per_second && $bits_per_second != "null" && -n $retransmits && $retransmits != "null" ]];then
iperfresu[s]=$bits_per_second
iperfresu[r]=$retransmits
return 0
fi
fi
done
return 1
}
convert_b2m(){
local bps=$1
local mbps
local color
if (($(echo "$bps < 0"|bc -l)));then
echo -e "$Font_Red     E$Font_Suffix"
return
else
mbps=$(echo "$bps / 1000000"|bc)
fi
if [ "$mbps" -gt 99999 ];then
echo -e "$Font_Green ${Font_U}100G+$Font_Suffix"
return
fi
if [ "$mbps" -lt 50 ];then
color=$Font_Red
elif [ "$mbps" -ge 50 ]&&[ "$mbps" -lt 200 ];then
color=$Font_Yellow
elif [ "$mbps" -ge 200 ];then
color=$Font_Green
else
color=$Font_Red
fi
local tmp_space=$((6-${#mbps}))
echo "$color$(printf "%${tmp_space}s\n")$Font_U$mbps$Font_Suffix"
}
convert_retr(){
local num=$1
local color
local result
if [ "$num" -lt 0 ];then
echo -e "${Font_Red}RROR$Font_Suffix"
return
fi
if [[ $num -eq 0 ]];then
color=$Font_Green
elif [[ $num -ge 1 && $num -le 99 ]];then
color=$Font_Yellow
elif [[ $num -gt 99 ]];then
color=$Font_Red
else
color=$Font_Red
fi
if [[ $num -lt 1000 ]];then
result=$num
elif [[ $num -ge 1000 && $num -lt 10000 ]];then
result="${num:0:1}k"
elif [[ $num -ge 10000 && $num -lt 100000 ]];then
result="${num:0:2}k"
elif [[ $num -ge 100000 && $num -lt 1000000 ]];then
result=".${num:0:1}m"
else
result="1m+"
fi
echo "$color$(printf '%4s' "$result")$Font_Suffix"
}
process_wwpingtestresult(){
local testresult=$1
local -A midresu
local -A midresu2
local tmp_space
local ipv
local index
local numbers
local total
local count
local lost
local result
IFS=$'\n' read -r -d '' -a lines <<<"$testresult"
for line in "${lines[@]}";do
line=$(echo "$line"|xargs)
[[ -z $line ]]&&continue
IFS=' ' read -ra parts <<<"$line"
index="${parts[1]}${parts[2]}${parts[3]}"
ipv="${parts[2]}"
ipout[$index]="${parts[4]}"
done
local keys=($(echo "${!icity[@]}"|tr ' ' '\n'|sort -n))
for key in "${keys[@]}";do
total=0
count=0
lost=""
for i in $(seq 1 $pingww_test_count);do
numbers=${ipout[$key$ipv$i]}
if [[ $numbers =~ ^0\.0*$ ]];then
lost="$Font_Red"
else
total=$(echo "$total + $numbers"|bc)
((count++))
fi
done
if ((count>0));then
local avg=$(echo "scale=0; $total / $count"|bc)
else
local avg=0
fi
result=""
for ((i=1; i<pingww_test_count; i+=2));do
local A="${ipout[$key$ipv$i]}"
local B="${ipout[$key$ipv$((i+1))]}"
local char=$(calculate_delay "$A" "$B")
result+="$char"
done
if [[ $avg -gt 240 || $lost == "$Font_Red" ]];then
lost="$Font_Red"
elif [[ $avg -gt 150 ]];then
lost="$Font_Yellow"
elif [[ $avg -le 150 ]];then
lost="$Font_Green"
else
lost="$Font_Red"
fi
iavg[$key]="$avg"
midresu[$key$ipv]="$Font_Green$result$lost$Font_B$(printf '%3s' "$avg")$Font_Suffix"
if [[ $YY == "cn" ]];then
tmp_space=$((10-${#icity[$key]}*2))
else
tmp_space=$((10-${#icity[$key]}))
fi
if [[ $mode_low -eq 1 ]];then
iresu[$key]="$Font_Cyan${icity[$key]}$(printf "%${tmp_space}s\n")${midresu[$key$ipv]}        ${Font_Green}SKIP$Font_Suffix        "
else
iresu[$key]="$Font_Cyan${icity[$key]}$(printf "%${tmp_space}s\n")${midresu[$key$ipv]}$(convert_b2m ${isout[$key${ipv}1]})$(convert_retr ${isout[$key${ipv}2]})$(convert_b2m ${isout[$key${ipv}3]})$(convert_retr ${isout[$key${ipv}4]})"
fi
done
}
iperf_test(){
ibar_step=48
local ipv=$1
local port=0
local json_data=$(curl -sL "${rawgithub}main/ref/iperf.json")
while IFS=" " read -r code server portl portu city cityzh;do
if [[ $YY == "cn" ]];then
icity["$code"]="$cityzh"
else
icity["$code"]="$city"
fi
idm["$code"]="$server"
iportl["$code"]="$portl"
iportu["$code"]="$portu"
done < <(echo "$json_data"|jq -r '.[] | "\(.code) \(.server) \(.portl) \(.portu) \(.city) \(.cityzh)"')
local keys=($(echo "${!icity[@]}"|tr ' ' '\n'|sort -n))
if [[ $mode_low -eq 0 ]];then
for key in "${keys[@]}";do
parse_iperf3_result "${idm[$key]}" ${iportl[$key]} ${iportu[$key]} $ipv 0 "${icity[$key]}${siperf[send]}"
isout["$key${ipv}1"]=${iperfresu[s]}
isout["$key${ipv}2"]=${iperfresu[r]}
parse_iperf3_result "${idm[$key]}" ${iportl[$key]} ${iportu[$key]} $ipv 1 "${icity[$key]}${siperf[recv]}"
isout["$key${ipv}3"]=${iperfresu[s]}
isout["$key${ipv}4"]=${iperfresu[r]}
done
fi
local temp_info="$Font_Cyan$Font_B${sinfo[delayww]}$Font_Suffix"
((ibar_step+=2))
show_progress_bar "$temp_info" $((50-${sinfo[ldelayww]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
local max_threads=10
local available_memory=1024
[[ "$(uname)" != "Darwin" ]]&&available_memory=$(free -m|awk '/Mem:/ {print $7}')
local max_threads_by_memory=$(echo "$available_memory / 8"|bc)
((max_threads_by_memory<max_threads))&&max_threads=$max_threads_by_memory
local current_threads=0
local tmpresult=$(for i in $(seq 1 $pingww_test_count)
do
for key in "${keys[@]}";do
if [[ $key -eq 41 ]];then
ping_test "speedtest.fra1.de.leaseweb.net" "TCP" 1400 "$i" "${icity[$key]}" "$key" "$ipv"&
elif [[ $key -eq 43 ]];then
ping_test "speedtest.ams1.nl.leaseweb.net" "TCP" 1400 "$i" "${icity[$key]}" "$key" "$ipv"&
else
ping_test "${idm[$key]}" "TCP" 1400 "$i" "${icity[$key]}" "$key" "$ipv"&
fi
((current_threads++))
if ((current_threads>=max_threads));then
wait -n
((current_threads--))
fi
done
done
wait)
process_wwpingtestresult "$tmpresult"
}
show_iperf(){
echo -ne "\r${siperf[title]}\n"
local count=0
local keys=($(echo "${!icity[@]}"|tr ' ' '\n'|sort -n))
for key in "${keys[@]}";do
((count++))
if ((count%2==0));then
echo -ne "${iresu[$key]}\n"
else
echo -ne "\r${iresu[$key]}||"
fi
done
((count%2!=0))&&echo
}
parse_speedtest_result(){
local tid="$1"
local tcode="$2"
local infolen
if [[ $YY == "cn" ]];then
infolen=$((${#scity[$tcode]}*2+${#spv[$tcode]}*2))
infotxt="${scity[$tcode]}${spv[$tcode]}"
else
infolen=$((${#scity[$tcode]}+${#spv[$tcode]}+1))
infotxt="${scity[$tcode]} ${spv[$tcode]}"
fi
local temp_info="$Font_Cyan$Font_B${sinfo[speedtest]}$infotxt$Font_Suffix"
((ibar_step+=2))
show_progress_bar "$temp_info" $((50-${sinfo[lspeedtest]}-infolen))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
local maxtry=1
sout["${tcode}1"]=-1
sout["${tcode}2"]=-1
sout["${tcode}3"]=-1
sout["${tcode}4"]=-1
local i
for ((i=1; i<=maxtry; i++));do
local response=$(speedtest --accept-gdpr --accept-license -f json -s "$tid" 2>&1)
response=$(echo "$response"|sed -n '/^{/,/^}/p')
if [[ -n $response && $response != *"[error]"* && $response != *"\"error\""* ]];then
local download_bandwidth=$(echo "$response"|jq '.download.bandwidth')
sout["${tcode}3"]=$((download_bandwidth*8))
local upload_bandwidth=$(echo "$response"|jq '.upload.bandwidth')
sout["${tcode}1"]=$((upload_bandwidth*8))
local download_latency_iqm=$(echo "$response"|jq '.download.latency.iqm')
sout["${tcode}4"]=${download_latency_iqm%.*}
local upload_latency_iqm=$(echo "$response"|jq '.upload.latency.iqm')
sout["${tcode}2"]=${upload_latency_iqm%.*}
return 0
fi
done
return 1
}
convert_delay(){
local num=$1
local color
local result
if [[ ! $num =~ ^-?[0-9]+$ ]];then
echo -e "$Font_Red     -$Font_Suffix"
return
fi
if [ "$num" -lt 0 ];then
echo -e "${Font_Red}RROR  $Font_Suffix"
return
fi
if [[ $num -eq 0 ]];then
color=$Font_Red
elif [[ $num -ge 1 && $num -le 150 ]];then
color=$Font_Green
elif [[ $num -ge 151 && $num -le 240 ]];then
color=$Font_Yellow
else
color=$Font_Red
fi
if [[ $num -lt 1000 ]];then
result=$num
elif [[ $num -ge 1000 && $num -lt 10000 ]];then
result="${num:0:1}k"
elif [[ $num -ge 10000 && $num -lt 100000 ]];then
result="${num:0:2}k"
elif [[ $num -ge 100000 && $num -lt 1000000 ]];then
result=".${num:0:1}m"
else
result="1m+"
fi
echo "$color$(printf '%6s' "$result")$Font_Suffix"
}
speedtest_test(){
ibar_step=36
local json_data=$(curl -sL "${rawgithub}main/ref/speedtest_cn.json")
declare -A codemax
codemax[1]=0
codemax[2]=0
codemax[3]=0
codemax[4]=0
while IFS=" " read -r code id city cityzh provider providerzh;do
if [[ $YY == "cn" ]];then
scity["$code"]="$cityzh"
spv["$code"]="$providerzh"
else
scity["$code"]="$city"
spv["$code"]="$provider"
fi
sid["$code"]="$id"
ten_digit="${code:0:1}"
one_digit="${code:1}"
if [[ $one_digit -gt ${codemax[$ten_digit]} ]];then
codemax["$ten_digit"]="$one_digit"
fi
done < <(echo "$json_data"|jq -r '.[] | "\(.code) \(.id) \(.city) \(.cityzh) \(.provider) \(.providerzh)"')
local skip
local key
local pvi
local pvj
for ((pvi=1; pvi<=3; pvi++));do
skip=0
for ((pvj=1; pvj<=2; pvj++));do
for ((try=1; codemax[$pvi]-3+pvj-skip>0; try++));do
key=$((pvj+skip))
parse_speedtest_result "${sid[$pvi$key]}" "$pvi$key"
if [[ sout[$pvi${key}1] -eq -1 && sout[$pvi${key}2] -eq -1 && sout[$pvi${key}3] -eq -1 && sout[$pvi${key}4] -eq -1 ]];then
((skip++))
((ibar_step-=2))
else
break
fi
done
if [[ $YY == "cn" ]];then
tmp_space=$((13-${#scity[$pvi$key]}*2-${#spv[$pvi$key]}*2))
sresu[$pvi$pvj]="$Font_Cyan${scity[$pvi$key]}${spv[$pvi$key]}$(printf "%${tmp_space}s\n")"
else
tmp_space=$((10-${#scity[$pvi$key]}))
sresu[$pvi$pvj]="$Font_Cyan${scity[$pvi$key]}$(printf "%${tmp_space}s\n")${spv[$pvi$key]} $Font_Suffix"
fi
sresu[$pvi$pvj]+="$(convert_b2m ${sout[$pvi${key}1]})$(convert_delay ${sout[$pvi${key}2]})  $(convert_b2m ${sout[$pvi${key}3]})$(convert_delay ${sout[$pvi${key}4]})"
done
done
}
show_speedtest(){
echo -ne "\r${sspeedtest[title]}\n"
local count=0
local keys=($(echo "${!sresu[@]}"|tr ' ' '\n'|sort -n))
for key in "${keys[@]}";do
((count++))
if ((count%2==0));then
echo -ne "${sresu[$key]}\n"
else
echo -ne "\r${sresu[$key]}||"
fi
done
((count%2!=0))&&echo
}
show_head(){
echo -ne "\r$(printf '%80s'|tr ' ' '*')\n"
if [ $fullIP -eq 1 ];then
calc_padding "$(printf '%*s' "${shead[ltitle]}" '')$IP" 80
echo -ne "\r$PADDING$Font_B${shead[title]}$Font_Cyan$IP$Font_Suffix\n"
else
calc_padding "$(printf '%*s' "${shead[ltitle]}" '')$IPhide" 80
echo -ne "\r$PADDING$Font_B${shead[title]}$Font_Cyan$IPhide$Font_Suffix\n"
fi
calc_padding "${shead[git]}" 80
echo -ne "\r$PADDING$Font_U${shead[git]}$Font_Suffix\n"
calc_padding "${shead[bash]}" 80
echo -ne "\r$PADDING${shead[bash]}\n"
echo -ne "\r${shead[ptime]}${shead[time]}  ${shead[ver]}\n"
echo -ne "\r$(printf '%80s'|tr ' ' '*')\n"
}
show_bgp(){
echo -ne "\r${sbgp[title]}\n"
if [[ -n ${bgp[asn]} && ${bgp[asn]} != "null" || -n ${bgp[org]} && ${bgp[org]} != "null" || -n ${bgp[prefixnum]} && ${bgp[prefixnum]} != "null" || -n ${bgp[rir]} && ${bgp[rir]} != "null" ]];then
local tmpstr=""
local tmpinfo=""
[[ -n ${bgp[rir]} && ${bgp[rir]} != "null" ]]&&tmpinfo="${bgp[rir]}"&&tmpstr=", "
[[ -n ${bgp[asn]} && ${bgp[asn]} != "null" ]]&&tmpinfo="$tmpinfo$tmpstr${bgp[asn]}"&&tmpstr=" "
[[ -n ${bgp[org]} && ${bgp[org]} != "null" ]]&&tmpinfo="$tmpinfo$tmpstr${bgp[org]}"&&tmpstr=", "
[[ $tmpstr == " " ]]&&tmpstr=", "
[[ -n ${bgp[prefixnum]} && ${bgp[prefixnum]} != "null" ]]&&tmpinfo="$tmpinfo${tmpstr}Prefix/${bgp[prefixnum]}"
echo -ne "\r$Font_Cyan${sbgp[ipinfo]}$Font_Green$(wrap_text 20 "$tmpinfo")$Font_Suffix\n"
fi
if [[ -n ${bgp[regdate]} && -n ${bgp[moddate]} ]];then
echo -ne "\r$Font_Cyan${sbgp[date]}$Font_Green${bgp[regdate]} / ${bgp[moddate]}$Font_Suffix\n"
elif [[ -n ${bgp[regdate]} && -z ${bgp[moddate]} ]];then
echo -ne "\r$Font_Cyan${sbgp[date]}$Font_Green${bgp[regdate]} / NoRecord$Font_Suffix\n"
elif [[ -z ${bgp[regdate]} && -n ${bgp[moddate]} ]];then
echo -ne "\r$Font_Cyan${sbgp[date]}${Font_Green}NoRecord / ${bgp[moddate]}$Font_Suffix\n"
fi
if [[ -n ${bgp[countrycode]} && ${bgp[countrycode]} != "null" ]];then
local fullcountry="[${bgp[countrycode]}]"
[[ -n ${bgp[country]} ]]&&fullcountry="$fullcountry${bgp[country]}"
if [[ -n ${bgp[intermediateregion]} ]];then
fullcountry="$fullcountry, ${bgp[intermediateregion]}"
elif [[ -n ${bgp[subregion]} ]];then
fullcountry="$fullcountry, ${bgp[subregion]}"
fi
[[ -n ${bgp[region]} ]]&&fullcountry="$fullcountry, ${bgp[region]}"
fi
[[ -n $fullcountry && $fullcountry != "null" ]]&&echo -ne "\r$Font_Cyan${sbgp[country]}$Font_Green$(wrap_text 20 "$fullcountry")$Font_Suffix\n"
[[ -n ${bgp[address]} && ${bgp[address]} != "null" ]]&&echo -ne "\r$Font_Cyan${sbgp[address]}$Font_Green$(wrap_text 20 "${bgp[address]}")$Font_Suffix\n"
[[ -n ${bgp[geofeed]} && ${bgp[geofeed]} != "null" ]]&&echo -ne "\r$Font_Cyan${sbgp[geofeed]}$Font_Green${bgp[geofeed]}$Font_Suffix\n"
local neighborresu=""
if [[ ${bgp[neighbortotal]} -gt 0 && -n ${bgp[neighboractive]} ]];then
neighbor_ratio=$(echo "scale=2; ${bgp[neighboractive]}/${bgp[neighbortotal]}"|bc)
if (($(echo "$neighbor_ratio < 0.5"|bc -l)));then
neighbor_bg=$Back_Green
elif (($(echo "$neighbor_ratio >= 0.5"|bc -l)))&&(($(echo "$neighbor_ratio < 0.8"|bc -l)));then
neighbor_bg=$Back_Yellow
elif (($(echo "$neighbor_ratio >= 0.8"|bc -l)));then
neighbor_bg=$Back_Red
else
neighbor_bg=$Back_Green
fi
neighborresu="${Font_Green}Subnet/24 $neighbor_bg$Font_B$Font_White ${bgp[neighboractive]} / ${bgp[neighbortotal]} $Font_Suffix    "
fi
if [[ ${bgp[iptotal]} -gt 0 && -n ${bgp[ipactive]} ]];then
ip_ratio=$(echo "scale=2; ${bgp[ipactive]}/${bgp[iptotal]}"|bc)
if (($(echo "$ip_ratio < 0.5"|bc -l)));then
ip_bg=$Back_Green
elif (($(echo "$ip_ratio >= 0.5"|bc -l)))&&(($(echo "$ip_ratio < 0.8"|bc -l)));then
ip_bg=$Back_Yellow
elif (($(echo "$ip_ratio >= 0.8"|bc -l)));then
ip_bg=$Back_Red
else
ip_bg=$Back_Green
fi
neighborresu+="${Font_Green}Prefix/${bgp[prefixnum]} $ip_bg$Font_B$Font_White ${bgp[ipactive]} / ${bgp[iptotal]} $Font_Suffix"
fi
[[ -n $neighborresu ]]&&echo -ne "\r$Font_Cyan${sbgp[neighbor]}$neighborresu$Font_Suffix\n"
}
show_local(){
echo -ne "\r${slocal[title]}\n"
[[ -n ${getnat[type]} ]]&&echo -ne "\r$Font_Cyan${slocal[nat]}${slocal[${getnat[type]}]}$Font_Suffix\n"
if [[ ${getnat[char]} -eq 1 ]];then
echo -ne "\r$Font_Cyan${slocal[mapping]}${slocal[m${getnat[m]}]}$Font_Suffix$Font_Cyan${slocal[filter]}${slocal[f${getnat[f]}]}$Font_Suffix$Font_Cyan${slocal[port]}${slocal[p${getnat[p]}]}$Font_Suffix$Font_Cyan${slocal[hairpin]}${slocal[h${getnat[h]}]}$Font_Suffix\n"
fi
echo -ne "\r$Font_Cyan${slocal[tcpcc]}$Font_Green$(printf '%-13s' "${gettcp[tcpcc]}")$Font_Cyan${slocal[rmem]}$Font_Green${gettcp[rmem]}$Font_Suffix\n"
echo -ne "\r$Font_Cyan${slocal[qdisc]}$Font_Green$(printf '%-13s' "${gettcp[qdisc]}")$Font_Cyan${slocal[wmem]}$Font_Green${gettcp[wmem]}$Font_Suffix\n"
}
show_conn(){
echo -ne "\r${sconn[title]}\n"
if [[ ${conn[ix]} -eq 99 ]];then
echo -ne "\r$Font_Cyan${sconn[ix]}$Font_Green$(printf '%-10s' "${conn[ix]}+")"
elif [[ ${conn[ix]} -eq -1 ]];then
echo -ne "\r$Font_Cyan${sconn[ix]}$Font_Green$(printf '%-10s' "-")"
else
echo -ne "\r$Font_Cyan${sconn[ix]}$Font_Green$(printf '%-10s' "${conn[ix]}")"
fi
if [[ ${conn[upstreams]} -eq -2 ]];then
echo -ne "$Font_Cyan${sconn[upstreams]}${Font_Green}Transit-Free  \n"
elif [[ ${conn[upstreams]} -eq -1 ]];then
echo -ne "$Font_Cyan${sconn[upstreams]}$Font_Green$(printf '%-10s' "-")"
else
echo -ne "$Font_Cyan${sconn[upstreams]}$Font_Green$(printf '%-10s' "${conn[upstreams]}")"
fi
if [[ ${conn[peers]} -eq -1 ]];then
echo -ne "$Font_Cyan${sconn[peers]}$Font_Green-$Font_Suffix\n"
else
echo -ne "$Font_Cyan${sconn[peers]}$Font_Green${conn[peers]}$Font_Suffix\n"
fi
local clenth=0
conn[asn]=""
conn[org]=""
for id in $(echo "${!casn[@]}"|tr ' ' '\n'|sort -n);do
local raw_as_number="AS${casn[$id]}"
local raw_as_name="${corg[$id]}"
if [[ ${casn[$id]} -eq 0 || ${ctarget[$id]} == "true" ]];then
continue
fi
local len_as_number=${#raw_as_number}
local len_as_name=${#raw_as_name}
local max_len=$((len_as_number>len_as_name?len_as_number:len_as_name))
if ((len_as_number<max_len));then
local spaces_to_add=$((max_len-len_as_number))
local left_spaces=$((spaces_to_add/2))
local right_spaces=$((spaces_to_add-left_spaces))
raw_as_number="$(printf "%*s%s%*s" "$left_spaces" "" "$raw_as_number" "$right_spaces" "")"
fi
if ((len_as_name<max_len));then
local spaces_to_add=$((max_len-len_as_name))
local right_spaces=$((spaces_to_add/2))
local left_spaces=$((spaces_to_add-right_spaces))
raw_as_name="$(printf "%*s%s%*s" "$left_spaces" "" "$raw_as_name" "$right_spaces" "")"
fi
local as_number_style=""
local as_name_style=""
local reset_style="$Font_Suffix"
[[ ${cupstream[$id]} == "true" ]]&&as_name_style+="$Font_U"
as_number_style+="$Font_B"
as_name_style+="$Font_B"
as_number_style+="$Font_White$Back_Blue"
[[ ${ctier1[$id]} == "true" ]]&&as_name_style+="$Font_White$Back_Green"
[[ ${ctier1[$id]} == "false" ]]&&as_name_style+="$Font_White$Back_Yellow"
local as_number="$as_number_style$raw_as_number$reset_style"
local as_name="$as_name_style$raw_as_name$reset_style"
clenth=$((clenth+max_len+1))
if ((clenth>81));then
clenth=$((max_len+1))
echo -ne "\r${conn[asn]}\n\r${conn[org]}\n"
conn[asn]="$as_number "
conn[org]="$as_name "
else
conn[asn]="${conn[asn]}$as_number "
conn[org]="${conn[org]}$as_name "
fi
done
[[ -n ${conn[asn]} ]]&&echo -ne "\r${conn[asn]}\n"
[[ -n ${conn[org]} ]]&&echo -ne "\r${conn[org]}\n"
}
show_tail(){
echo -ne "\r$(printf '%80s'|tr ' ' '=')\n"
echo -ne "\r$Font_I${stail[stoday]}${stail[today]}${stail[stotal]}${stail[total]}${stail[thanks]} $Font_Suffix\n"
echo -e ""
}
get_opts(){
local args=()
while [[ $# -gt 0 ]];do
case "$1" in
-[loSR])args+=("$1")
if [[ $# -gt 1 && $2 != -* ]];then
args+=("$2")
shift
fi
shift
;;
-[loSR]*)ERRORcode=1
shift
;;
-[46fhjnpyELMP]*)local opt="$1"
shift
for ((i=1; i<${#opt}; i++));do
args+=("-${opt:i:1}")
done
;;
--*|-*[!-]*)args+=("$1")
shift
;;
-*)ERRORcode=1
shift
;;
*)shift
esac
done
set -- "${args[@]}"
while [[ $# -gt 0 ]];do
case "$1" in
-4)if
[[ IPV4check -ne 0 ]]
then
IPV6check=0
else
ERRORcode=4
fi
shift
;;
-6)if
[[ IPV6check -ne 0 ]]
then
IPV4check=0
else
ERRORcode=6
fi
shift
;;
-f)fullIP=1
shift
;;
-h)show_help
shift
;;
-j)mode_json=1
shift
;;
-l)shift
[[ $1 == -* ]]&&ERRORcode=1&&break
YY=$(echo "$1"|tr '[:upper:]' '[:lower:]')
shift
;;
-n)mode_no=1
shift
;;
-o)shift
[[ $1 == -* ]]&&{
ERRORcode=1
break
}
mode_output=1
outputfile="$1"
[[ -z $outputfile ]]&&{
ERRORcode=1
break
}
[[ -e $outputfile ]]&&{
ERRORcode=10
break
}
touch "$outputfile" 2>/dev/null||{
ERRORcode=11
break
}
shift
;;
-p)mode_privacy=1
shift
;;
-y)mode_yes=1
shift
;;
-E)YY="en"
shift
;;
-L)mode_low=1
shift
;;
-M)mode_menu=1
shift
;;
-P)mode_ping=1
shift
;;
-R)mode_route=1
shift
if [[ $# -gt 0 && $1 != -* ]];then
mode_route_pv=$(echo "$1"|tr '[:upper:]' '[:lower:]'|sed 's/省//g; s/市//g; s/县//g; s/维吾尔//g; s/回族//g; s/壮族//g; s/自治区//g; s/特别行政区//g')
shift
fi
;;
-S)shift
if [[ $# -gt 0 ]];then
mode_skip="$1"
shift
else
ERRORcode=1
fi
;;
-*)ERRORcode=1
shift
;;
*)shift
esac
done
if [[ $mode_menu -eq 1 ]];then
if [[ $YY == "cn" ]];then
eval "bash <(curl -sL https://Check.Place) -N"
else
eval "bash <(curl -sL https://Check.Place) -EN"
fi
exit 0
fi
[[ $mode_ping -eq 1 ]]&&mode_skip+="567"
[[ $mode_low -eq 1 ]]&&mode_skip+="6"
[[ $mode_route -eq 1 ]]&&mode_skip+="467"
[[ $mode_ping -eq 1 && $mode_skip == *"4"* ]]&&ERRORcode=9
[[ $mode_route -eq 1 && $mode_skip == *"5"* ]]&&ERRORcode=9
[[ $mode_skip == *"1"* && $mode_skip == *"2"* && $mode_skip == *"3"* && $mode_skip == *"4"* && $mode_skip == *"5"* && $mode_skip == *"6"* && $mode_skip == *"7"* ]]&&ERRORcode=9
[[ $IPV4check -eq 1 && $IPV6check -eq 0 && $IPV4work -eq 0 ]]&&ERRORcode=40
[[ $IPV4check -eq 0 && $IPV6check -eq 1 && $IPV6work -eq 0 ]]&&ERRORcode=60
CurlARG="$useNIC$usePROXY"
}
show_help(){
echo -ne "\r$shelp\n"
exit 0
}
show_ad(){
local RANDOM=$(date +%s)
local indices=(1 2 3)
for ((i=${#indices[@]}-1; i>0; i--));do
j=$((RANDOM%(i+1)))
temp=${indices[i]}
indices[i]=${indices[j]}
indices[j]=$temp
done
aad[0]=$(curl -sL --max-time 5 "${rawgithub}main/ref/sponsor.ans")
aad[${indices[0]}]=$(curl -sL --max-time 5 "${rawgithub}main/ref/ad1.ans")
aad[${indices[1]}]=$(curl -sL --max-time 5 "${rawgithub}main/ref/ad2.ans")
aad[${indices[2]}]=$(curl -sL --max-time 5 "${rawgithub}main/ref/ad3.ans")
local rows
local cols
read rows cols < <(stty size)
if [[ $cols -ge 150 ]];then
mapfile -t aad0 <<<"${aad[0]}"
mapfile -t aad1 <<<"${aad[1]}"
mapfile -t aad2 <<<"${aad[2]}"
mapfile -t aad3 <<<"${aad[3]}"
for ((i=0; i<12; i++));do
printf "%-72s$Font_Suffix     %-72s\n" "${aad0[$i]}" "${aad1[$i]}" 1>&2
done
for ((i=0; i<12; i++));do
printf "%-72s$Font_Suffix     %-72s\n" "${aad2[$i]}" "${aad3[$i]}" 1>&2
done
ADLines=24
else
echo "${aad[0]}" 1>&2
echo "${aad[1]}" 1>&2
echo "${aad[2]}" 1>&2
echo "${aad[3]}" 1>&2
ADLines=48
fi
}
read_ref(){
ISO3166=$(curl -sL -m 10 "${rawgithub}main/ref/iso3166.json")
RESPONSE=$(curl -sL -m 10 "${rawgithub}main/ref/province.json")
while IFS=" " read -r province code short name;do
pcode[$province]=$code
pshort[$province]=$short
pname[$province]=$(echo "$name"|sed -E 's/(省|市|自治区|维吾尔|壮族|回族)//g')
pcode_lower=$(echo "$code"|tr '[:upper:]' '[:lower:]')
pdm[${province}14]="$pcode_lower-ct-v4.ip.zstaticcdn.com"
pdm[${province}24]="$pcode_lower-cu-v4.ip.zstaticcdn.com"
pdm[${province}34]="$pcode_lower-cm-v4.ip.zstaticcdn.com"
pdm[${province}16]="$pcode_lower-ct-v6.ip.zstaticcdn.com"
pdm[${province}26]="$pcode_lower-cu-v6.ip.zstaticcdn.com"
pdm[${province}36]="$pcode_lower-cm-v6.ip.zstaticcdn.com"
done < <(echo "$RESPONSE"|jq -r '.[] | select(.province < 70) | "\(.province) \(.code) \(.short) \(.name)"')
if [[ -n $mode_route_pv ]];then
lower_optarg="$mode_route_pv"
mode_route_pv=""
for province in "${!pcode[@]}";do
lower_pcode=$(echo "${pcode[$province]}"|tr '[:upper:]' '[:lower:]')
if [[ $lower_optarg == "$lower_pcode" || $lower_optarg == "${pshort[$province]}" || $lower_optarg == "${pname[$province]}" ]];then
mode_route_pv="$province"
break
fi
done
[[ -z $mode_route_pv ]]&&ERRORcode=21
fi
while read -r as name;do
AS_MAPPING["$as"]="$name"
done < <(curl -sL "${rawgithub}main/ref/AS_Mapping.txt")
}
save_json(){
local head_updates=""
local bgp_updates=""
local local_updates=""
local connectivity_updates=""
if [ $fullIP -eq 1 ];then
head_updates+=".Head |= map(. + { IP: \"${IP:-null}\" }) | "
else
head_updates+=".Head |= map(. + { IP: \"${IPhide:-null}\" }) | "
fi
head_updates+=".Head |= map(. + { Command: \"${shead[bash]:-null}\" }) | "
head_updates+=".Head |= map(. + { GitHub: \"${shead[git]:-null}\" }) | "
head_updates+=".Head |= map(. + { Time: \"${shead[time]:-null}\" }) | "
head_updates+=".Head |= map(. + { Version: \"${shead[ver]:-null}\" }) | "
local first_asn=$(echo "${bgp[asn]}"|awk -F',' '{print $1}'|sed 's/^AS//')
first_asn=${first_asn:-null}
bgp_updates+=".BGP |= map(. + { ASN: \"$first_asn\" }) | "
bgp_updates+=".BGP |= map(. + { Organization: \"${bgp[org]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { Prefix: ${bgp[prefixnum]:-null} }) | "
bgp_updates+=".BGP |= map(. + { RIR: \"${bgp[rir]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { RegDate: \"${bgp[regdate]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { ModDate: \"${bgp[moddate]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { Country: \"${bgp[country]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { IntermediateRegion: \"${bgp[intermediateregion]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { SubRegion: \"${bgp[subregion]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { Region: \"${bgp[region]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { Address: \"${bgp[address]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { GeoFeed: \"${bgp[geofeed]:-null}\" }) | "
if [[ -n ${bgp[iptotal]} && -n ${bgp[ipactive]} ]];then
bgp_updates+=".BGP |= map(. + { IPinTotal: ${bgp[iptotal]:-null} }) | "
bgp_updates+=".BGP |= map(. + { IPActive: ${bgp[ipactive]:-null} }) | "
bgp_updates+=".BGP |= map(. + { NeighborinTotal: ${bgp[neighbortotal]:-null} }) | "
bgp_updates+=".BGP |= map(. + { NeighborActive: ${bgp[neighboractive]:-null} }) | "
elif [[ -n ${bgp[neighbortotal]} && -n ${bgp[neighboractive]} ]];then
bgp_updates+=".BGP |= map(. + { IPinTotal: ${bgp[neighbortotal]:-null} }) | "
bgp_updates+=".BGP |= map(. + { IPActive: ${bgp[neighboractive]:-null} }) | "
bgp_updates+=".BGP |= map(. + { NeighborinTotal: ${bgp[neighbortotal]:-null} }) | "
bgp_updates+=".BGP |= map(. + { NeighborActive: ${bgp[neighboractive]:-null} }) | "
else
bgp_updates+=".BGP |= map(. + { IPinTotal: null }) | "
bgp_updates+=".BGP |= map(. + { IPActive: null }) | "
bgp_updates+=".BGP |= map(. + { NeighborinTotal: null }) | "
bgp_updates+=".BGP |= map(. + { NeighborActive: null }) | "
fi
local_updates+=".Local |= map(. + { NAT: \"${getnat[nat]:-null}\" }) | "
local_updates+=".Local |= map(. + { NATDescribe: \"$(echo -e "${slocal[${getnat[type]}]:-null}"|sed -E 's/\x1B\[[0-9;]*[a-zA-Z]//g'|xargs)\" }) | "
local_updates+=".Local |= map(. + { Mapping: \"$(echo -e "${slocal[m${getnat[m]}]:-null}"|sed -E 's/\x1B\[[0-9;]*[a-zA-Z]//g'|xargs)\" }) | "
local_updates+=".Local |= map(. + { Filter: \"$(echo -e "${slocal[f${getnat[f]}]:-null}"|sed -E 's/\x1B\[[0-9;]*[a-zA-Z]//g'|xargs)\" }) | "
local_updates+=".Local |= map(. + { Port: \"$(echo -e "${slocal[p${getnat[p]}]:-null}"|sed -E 's/\x1B\[[0-9;]*[a-zA-Z]//g'|xargs)\" }) | "
local_updates+=".Local |= map(. + { Hairpin: \"$(echo -e "${slocal[h${getnat[h]}]:-null}"|sed -E 's/\x1B\[[0-9;]*[a-zA-Z]//g'|xargs)\" }) | "
local_updates+=".Local |= map(. + { TCPCongestionControl: \"${gettcp[tcpcc]:-null}\" }) | "
local_updates+=".Local |= map(. + { QueueDiscipline: \"${gettcp[qdisc]:-null}\" }) | "
local_updates+=".Local |= map(. + { TCPReceiveBuffer: \"${gettcp[rmem]:-null}\" }) | "
local_updates+=".Local |= map(. + { TCPSendBuffer: \"${gettcp[wmem]:-null}\" }) | "
bgp_updates+=".BGP |= map(. + { IXCount: ${conn[ix]:-null} }) | "
bgp_updates+=".BGP |= map(. + { UpstreamsCount: ${conn[upstreams]:-null} }) | "
bgp_updates+=".BGP |= map(. + { PeersCount: ${conn[peers]:-null} }) | "
for id in $(echo "${!casn[@]}"|tr ' ' '\n'|sort -n);do
if [[ -z ${casn[$id]} ]];then
continue
fi
connectivity_updates+=".Connectivity += [{\"ID\": $id, \"ASN\": ${casn[$id]:-null}, \"Org\": \"${corg[$id]:-null}\", \"IsTarget\": $([[ ${ctarget[$id]} == "true" ]]&&echo true||echo false), \"IsTier1\": $([[ ${ctier1[$id]} == "true" ]]&&echo true||echo false), \"IsUpstream\": $([[ ${cupstream[$id]} == "true" ]]&&echo true||echo false)}] | "
done
netdata=$(echo "$netdata"|jq "$head_updates$bgp_updates$local_updates$connectivity_updates.")
local delay_objects=()
local keys=($(echo "${!pcode[@]}"|tr ' ' '\n'|sort -n))
for key in "${keys[@]}";do
delay_object="{
            \"Code\": \"${pcode[$key]:-null}\",
            \"Name\": \"${pshort[$key]:-null}\",
            \"CT\": {
                \"Average\": \"${pavg[${key}1$1]:-null}\""
for ((resu=1; resu<=ping_test_count; resu++));do
delay_object+=", \"$resu\": \"${pout[${key}1$1$resu]:-null}\""
done
delay_object+="},
            \"CU\": {
                \"Average\": \"${pavg[${key}2$1]:-null}\""
for ((resu=1; resu<=ping_test_count; resu++));do
delay_object+=", \"$resu\": \"${pout[${key}2$1$resu]:-null}\""
done
delay_object+="},
            \"CM\": {
                \"Average\": \"${pavg[${key}3$1]:-null}\""
for ((resu=1; resu<=ping_test_count; resu++));do
delay_object+=", \"$resu\": \"${pout[${key}3$1$resu]:-null}\""
done
delay_object+="}}"
delay_objects+=("$delay_object")
done
delay_array=$(printf '%s\n' "${delay_objects[@]}"|jq -s .)
netdata=$(echo "$netdata"|jq --argjson delay_array "$delay_array" '.Delay = $delay_array')
local transfer_object=()
local keys=($(echo "${!icity[@]}"|tr ' ' '\n'|sort -n))
for key in "${keys[@]}";do
transfer_object="{
            \"City\": \"${icity[$key]:-null}\",
            \"SendSpeed\": \"${isout[$key$11]:-null}\",
            \"SendRetransmits\": \"${isout[$key$12]:-null}\",
            \"ReceiveSpeed\": \"${isout[$key$13]:-null}\",
            \"ReceiveRetransmits\": \"${isout[$key$14]:-null}\",
            \"Delay\": {
                \"Average\": \"${iavg[$key]:-null}\""
for ((resu=1; resu<=10; resu++));do
transfer_object+=", \"$resu\": \"${ipout[$key$1$resu]:-null}\""
done
transfer_object+="}}"
netdata=$(echo "$netdata"|jq --argjson transfer_object "$transfer_object" '.Transfer += [$transfer_object]')
done
local speedtest_object=()
local keys=($(echo "${!scity[@]}"|tr ' ' '\n'|sort -n))
for key in "${keys[@]}";do
if [[ ${sout[${key}1]} -gt 0 || ${sout[${key}2]} -gt 0 || ${sout[${key}3]} -gt 0 || ${sout[${key}4]} -gt 0 ]];then
speedtest_object="{
                \"City\": \"${scity[$key]:-null}\",
                \"Provider\": \"${spv[$key]:-null}\",
                \"ID\": \"${sid[$key]:-null}\",
                \"SendSpeed\": \"${sout[${key}1]:-null}\",
                \"SendDelay\": \"${sout[${key}2]:-null}\",
                \"ReceiveSpeed\": \"${sout[${key}3]:-null}\",
                \"ReceiveDelay\": \"${sout[${key}4]:-null}\"
            }"
netdata=$(echo "$netdata"|jq --argjson speedtest_object "$speedtest_object" '.Speedtest += [$speedtest_object]')
fi
done
}
check_Net(){
IP=$1
ibar_step=0
netdata='{
      "Head": [{}],
      "BGP": [{}],
      "Local": [{}],
      "Connectivity": [],
      "Delay": [],
      "Speedtest": [],
      "Transfer": []
    }'
[[ $2 -eq 4 ]]&&hide_ipv4 $IP
[[ $2 -eq 6 ]]&&hide_ipv6 $IP
countRunTimes
[[ $mode_skip != *"1"* || $mode_skip != *"3"* ]]&&db_bgptools $2
[[ $mode_skip != *"1"* ]]&&db_henet $2
[[ $mode_skip != *"1"* && $2 -eq 4 && -n ${bgp[prefixnum]} ]]&&get_neighbor
getnat=()
[[ $mode_skip != *"2"* && $2 -eq 4 ]]&&get_nat
[[ $mode_skip != *"2"* ]]&&get_tcp
[[ $mode_skip != *"4"* ]]&&get_delay $2
[[ $mode_skip != *"5"* && $mode_route -eq 0 ]]&&get_route $2
[[ $mode_skip != *"5"* && $mode_route -eq 1 ]]&&get_route_mode $2
[[ $mode_skip != *"6"* && $2 -eq 4 ]]&&speedtest_test
[[ $mode_skip != *"7"* ]]&&iperf_test $2
echo -ne "$Font_LineClear" 1>&2
if [ $2 -eq 4 ]||[[ $IPV4work -eq 0 || $IPV4check -eq 0 ]];then
for ((i=0; i<ADLines; i++));do
echo -ne "$Font_LineUp" 1>&2
echo -ne "$Font_LineClear" 1>&2
done
fi
local net_report=$(show_head
[[ $mode_skip != *"1"* ]]&&show_bgp
[[ $mode_skip != *"2"* ]]&&show_local
[[ $mode_skip != *"3"* ]]&&show_conn
[[ $mode_skip != *"4"* ]]&&show_delay
[[ $mode_skip != *"5"* ]]&&show_route $2
[[ $mode_skip != *"6"* && $2 -eq 4 ]]&&show_speedtest
[[ $mode_skip != *"7"* ]]&&show_iperf
show_tail)
[[ mode_json -eq 1 || mode_output -eq 1 || mode_privacy -eq 0 ]]&&save_json $2
[[ mode_privacy -eq 0 ]]&&report_link=$(curl -$2 -s -X POST https://upload.check.place -d "type=net" --data-urlencode "json=$netdata" --data-urlencode "content=$net_report")
[[ mode_json -eq 0 ]]&&echo -ne "\r$net_report\n"
[[ mode_json -eq 0 && mode_privacy -eq 0 && $report_link == *"https://Report.Check.Place/"* ]]&&echo -ne "\r${stail[link]}$report_link$Font_Suffix\n"
[[ mode_json -eq 1 ]]&&echo -ne "\r$netdata\n"
echo -ne "\r\n"
if [[ mode_output -eq 1 ]];then
case "$outputfile" in
*.[aA][nN][sS][iI])echo "$net_report" >>"$outputfile" 2>/dev/null
;;
*.[jJ][sS][oO][nN])echo "$netdata" >>"$outputfile" 2>/dev/null
;;
*)echo -e "$net_report"|sed 's/\x1b\[[0-9;]*[mGKHF]//g' >>"$outputfile" 2>/dev/null
esac
fi
}
generate_random_user_agent
export LC_CTYPE=en_US.UTF-8 2>/dev/null
check_connectivity
get_ipv4
get_ipv6
is_valid_ipv4 $IPV4
is_valid_ipv6 $IPV6
get_opts "$@"
[[ mode_no -eq 0 ]]&&install_dependencies
set_language
read_ref
if [[ $ERRORcode -ne 0 ]];then
echo -ne "\r$Font_B$Font_Red${swarn[$ERRORcode]}$Font_Suffix\n"
exit $ERRORcode
fi
clear
show_ad
[[ $IPV4work -ne 0 && $IPV4check -ne 0 ]]&&check_Net "$IPV4" 4
[[ $IPV6work -ne 0 && $IPV6check -ne 0 ]]&&check_Net "$IPV6" 6
