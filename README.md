<p align="center">
<img src="https://hits.xykt.de/net.svg?action=view&count_bg=%2379C83D&title_bg=%23555555&title=Runs&edge_flat=false"/> 
<img src="https://hits.xykt.de/net_github.svg?action=hit&count_bg=%233DC8C0&title_bg=%23555555&title=Visits&edge_flat=false"/> 
<a href="/LICENSE"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="license" /></a>  
</p>

## 网络质量体检脚本  -  [Network Quality Check Script (EN)](https://github.com/xykt/NetQuality/blob/main/README_EN.md)

**支持OS/Platform：Ubuntu | Debian | Linux Mint | Fedora | Red Hat Enterprise Linux (RHEL) | CentOS | Arch Linux | Manjaro | Alpine Linux | AlmaLinux | Rocky Linux | macOS | Anolis OS | Alibaba Cloud Linux | SUSE Linux | openSUSE | Void Linux | Windows (via Docker)**

- 中英文双语言支持
- 支持IPv4/IPv6双栈查询
- 精美排版，直观显示，多终端单屏优化展示，便于截图分享
- BGP信息、本地策略、接入信息、三网TCP大包延迟、三网回程路由、国内测速、国际互连七大模块
- 基础数据源自*BGP.TOOLS*及*BGP.HE.NET*数据库
- 上游及接入信息直观展示
- 中国大陆地区31个省/市/自治区电信/联通/移动三网回程延迟
- 基于*SPEEDTEST.NET*的中国大陆（含大湾区）三网网速测试
- 基于*NextTrace*的三网回程完整路由展示
- 全球五大洲网速及延迟测试
- 延迟模式、低数据模式、跳过任意章节，多种测试方式弹性选择
- Json输出便于大数据分析

#### 屏幕截图
|IPv4测试结果|IPv6测试结果|
| ---------------- | ---------------- |
|![IPv4](https://github.com/xykt/NetQuality/raw/main/res/v4_cn.png)|![IPv6](https://github.com/xykt/NetQuality/raw/main/res/v6_cn.png)|

|延迟模式测试结果|完整路由模式测试结果|
| ---------------- | ---------------- |
|![Ping](https://github.com/xykt/NetQuality/raw/main/res/ping_cn.png)|![Route](https://github.com/xykt/NetQuality/raw/main/res/route_v4.png)|


## 使用方法

### 便捷模式：交互界面

![Net](https://github.com/xykt/ScriptMenu/raw/main/res/Net_CN.png)

##### Bash：
````bash
bash <(curl -Ls https://Check.Place) -N
````

##### Docker：
- Linux
````bash
docker run --rm --net=host -it xykt/check -N && docker rmi xykt/check > /dev/null 2>&1
````

- Windows (CMD)
````bash
docker run --rm --net=host -it xykt/check -N & docker rmi xykt/check > NUL 2>&1
````

### 高级模式：参数运行

![Help](https://github.com/xykt/NetQuality/raw/main/res/help.png)

##### 默认双栈检测：
````bash
bash <(curl -Ls https://Net.Check.Place)
````

##### 只检测IPv4结果：
````bash
bash <(curl -Ls https://Net.Check.Place) -4
````

##### 只检测IPv6结果：
````bash
bash <(curl -Ls https://Net.Check.Place) -6
````

##### 延迟模式：
````bash
bash <(curl -Ls https://Net.Check.Place) -P
````

##### 完整路由模式（TCP大包）：
```bash
bash <(curl -Ls https://Net.Check.Place) -R [大陆地区省级行政区名称或中/英文简称]
```
缺省状态默认检测北京、上海、广东三地
```bash
bash <(curl -Ls https://Net.Check.Place) -R
```
指定参数可检测任意大陆省级行政区（以下任选其一）
```bash
bash <(curl -Ls https://Net.Check.Place) -R 桂
bash <(curl -Ls https://Net.Check.Place) -R 广西
bash <(curl -Ls https://Net.Check.Place) -R 广西壮族自治区
bash <(curl -Ls https://Net.Check.Place) -R GX
bash <(curl -Ls https://Net.Check.Place) -R gx
```

##### 低数据模式：
````bash
bash <(curl -Ls https://Net.Check.Place) -L
````

##### 跳过任意章节：
````bash
bash <(curl -Ls https://Net.Check.Place) -S 1234567
````

##### 中英文双语支持：
````bash
bash <(curl -Ls https://Net.Check.Place) -l cn|en
````

##### JSON输出（[输出示例](https://github.com/xykt/NetQuality/blob/main/res/output.json)）：
````bash
bash <(curl -Ls https://Net.Check.Place) -j
````

##### 输出报告ANSI/JSON/纯文本至文件：
````bash
bash <(curl -Ls https://Net.Check.Place) -o /path/to/file.ansi
bash <(curl -Ls https://Net.Check.Place) -o /path/to/file.json
bash <(curl -Ls https://Net.Check.Place) -o /path/to/file.txtoranyother
````

##### 跳过检测系统及安装依赖：
````bash
bash <(curl -Ls https://Net.Check.Place) -n
````

##### 自动安装依赖：
````bash
bash <(curl -Ls https://Net.Check.Place) -y
````

##### 报告展示完整IP地址：
````bash
bash <(curl -Ls https://Net.Check.Place) -f
````

##### 隐私模式——禁用在线报告生成功能：
````bash
bash <(curl -Ls https://Net.Check.Place) -p
````

##### Docker（支持运行参数，须在```&```前插入）：
- Linux
````bash
docker run --rm --net=host -it xykt/netquality && docker rmi xykt/netquality > /dev/null 2>&1
````

- Windows (CMD)
````cmd
docker run --rm --net=host -it xykt/netquality & docker rmi xykt/netquality > NUL 2>&1
````

## 脚本更新

2026/01/15 17:50 修复不规范JSON

2025/08/03 00:00 增加Docker运行方式

2025/08/01 15:15 增加-p隐私模式，禁用在线报告生成功能

2025/07/30 16:50 将所有HTTP请求替换为HTTPS以提升脚本安全性

2025/05/11 14:00 增加报告svg图片分享链接，修复一些排版问题

2025/04/23 18:00 增加-o输出报告ANSI/JSON/纯文本至文件，修复三网回程线路测试偶发卡死问题

2025/04/21 22:15 更新：完整路由模式，折叠重复的路由信息

2025/04/21 00:00 修复macOS兼容性问题，提升脚本鲁棒性

2025/04/20 21:00 修复大陆IP无法正常获取脚本资源的问题

2025/03/28 00:50 增加-R完整路由模式，增加低数据模式的国际互连延迟测试，修复bugs

2025/03/13 22:40 增加-n参数，跳过OS检测及安装依赖

2025/03/12 17:00 脚本发布

## 脚本贡献

**服务器赞助商（排名不分先后）**

| 赞助商 | 商标 | 网址 | 
| - | - | - |  
| V.PS | ![vps_logo](https://raw.githubusercontent.com/xykt/NetQuality/main/res/sponsor/logo_vps.png) | [https://v.ps](https://v.ps)| 
| BAGE | ![bage_logo](https://raw.githubusercontent.com/xykt/NetQuality/main/res/sponsor/logo_bage.png) | [https://bagevm.com](https://bagevm.com)|
| LisaHost</br>丽萨主机 | ![lisa_logo](https://raw.githubusercontent.com/xykt/NetQuality/main/res/sponsor/logo_lisa.png) | [https://lisahost.com](https://lisahost.com)|  
| RapidProxy</br>`原生IP` | ![rapidproxy_logo](https://raw.githubusercontent.com/xykt/NetQuality/main/res/sponsor/logo_rapidproxy.png) | [https://rapidproxy.io](https://www.rapidproxy.io/?ref=gitipquality)| 
| ColaProxy</br>`原生IP` | ![colaproxy_logo](https://raw.githubusercontent.com/xykt/NetQuality/main/res/sponsor/logo_colaproxy.png) | [https://colaproxy.com](https://colaproxy.com/?utm_source=IPQuality&utm_medium=IPQuality&ref=IPQuality)| 
| RFCHost | ![rfchost_logo](https://raw.githubusercontent.com/xykt/NetQuality/main/res/sponsor/logo_rfchost.png) | [https://rfchost.com](https://rfchost.com)| 
| KFCHost | ![kfchost_logo](https://raw.githubusercontent.com/xykt/NetQuality/main/res/sponsor/logo_kfchost.png) | [https://kfchost.com](https://kfchost.com)| 
| PO0 | ![po0_logo](https://raw.githubusercontent.com/xykt/NetQuality/main/res/sponsor/logo_po0.png) | [https://po0.io](https://po0.io)|  

##### *E-Mail: sponsor@check.place Telegram Bot: https://t.me/xythebot*
**仅接受长期稳定运营，信誉良好的商家*

**Acknowledgments:**

- 感谢NextTrace项目组（[官网](https://www.nxtrace.org/)，[GitHub](https://github.com/nxtrace/NTrace-core)）提供稳定可靠的三网回程路由测试工具，本项目第五部分所涉及IP地理位置及线路标注数据由NextTrace官方API提供。

- 感谢[SPEETNET.net](https://www.speedtest.net/)，[Speedtest® CLI](https://www.speedtest.net/apps/cli)是目前大陆地区唯一可用的命令行三网测速工具

- 感谢[GlobalSign@Nodeseek](https://www.nodeseek.com/space/5813#/general)提供稳定可靠的三网测试地址，你的付出为脚本最重要的功能之一奠定了坚实基础

- 感谢[福尔摩斯@Nodeseek](https://www.nodeseek.com/space/13352#/general)，你在功能及美工方面为脚本提供了诸多宝贵建议

- 感谢[酒神@Nodeseek](https://www.nodeseek.com/space/9#/general)，你为脚本提供了技术支持及宝贵建议

- 感谢Si，你为脚本的功能及排版提供了重要建议参考

- 感谢Kakan，你为脚本提供了宝贵的参考意见


**Stars History:**

![Stargazers over time](https://star.xykt.de/xykt/NetQuality.svg?width=1024&height=400&maxRequestPages=20&xTicks=9&yTicks=6&showTitle=false&samplePointRadius=4&lineColor=steelblue&samplePointColor=steelblue&fillColor=steelblue)

**Daily Runs History:**

![daily_runs_history](https://hits.xykt.de/history/net.svg?days=46&chartType=bar&title=%E7%BD%91%E7%BB%9C%E8%B4%A8%E9%87%8F%E4%BD%93%E6%A3%80%E8%84%9A%E6%9C%AC%E6%AF%8F%E6%97%A5%E8%BF%90%E8%A1%8C%E9%87%8F%E7%BB%9F%E8%AE%A1&width=1024&height=400&color=steelblue)
