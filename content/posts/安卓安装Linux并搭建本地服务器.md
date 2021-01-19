---
title: 安卓安装Linux并搭建本地服务器
date: 2021-01-18T21:31:01+08:00
lastmod: 2021-01-18T21:31:01+08:00
author: codechf
authorlink: https://github.com/code-chf
cover: https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/mG3T6E-8c3484fa98662e82e3aa187b16c0be61.jpeg
categories:
  - Linux学习
tags:
  - 技术帖
draft: false
---

闲置的小米5手机变废为宝，通过Linux Deploy为它安装了Linux本地服务器，并实现了各种开发环境的搭建，这篇博客主要记录安装过程和遇到的一些问题。

<!--more-->
# 准备工作
1. root后的安卓手机
2. Linux Deploy安装包:point_down:[点击下载][Linux Deploy]
3. BusyBox安装包:point_down:[点击下载][busybox]
4. Syslock安装包（用于解锁System分区）:point_down:[点击下载][Syslock]

   [Linux Deploy]: https://github.com/meefik/linuxdeploy/releases
   [busybox]: https://github.com/meefik/busybox/releases
   [Syslock]: http://package.7to.cn/uploads/at/202001/1715131142.apk

# 小米手机root过程
小米手机系统可以开启root功能，但是要求系统是**开发版**且必须先**解锁**，解锁教程请移步:point_right:[小米手机解BootLoader锁教程][1]

小米手机线刷程开发版教程：
1. 小米手机官方开发版ROM下载请前往[官网][2]，如果没有找到刷机包文件，可以去镜像网站下载，里面有很多版本的小米官方ROM:point_right:[Xiaomi MIUI][3]，可以选择线刷和卡刷两种方式，卡刷简单但是刷机不彻底，这里选择线刷。

2. 下载小米手机刷机工具，手机进入开发者模式打开USB调试，手机关机，长按音量下键+电源键进入恢复模式，接入数据线等待系统连接，识别成功后选择下载好的系统镜像，最后刷入即可，详细教程可移步:point_right:[小米手机刷机教程][4]

3. 手机刷机完成后第一次开机会比较慢，耐心等待。开机后打开安全中心，选择应用管理，选择权限，选择ROOT权限管理，打开即可。

4. 解锁System分区，实现完全root，请移步:point_right:[系统System分区解锁方法][5]

到此已经root完的小米手机准备完毕。

[1]: https://www.xiaomi.cn/post/3892846
[2]: http://www.miui.com/download.html
[3]: https://mirom.ezbox.idv.tw/en/phone/
[4]: http://www.miui.com/shuaji-393.html
[5]: http://m.rom.7to.cn/jiaochengdetail/17233

# 通过Linux Deploy安装Linux服务器

## 1. Linux Deploy介绍
Linux Deploy 是一个在 Androit 上运行的 chroot 容器。使用 Linux Deploy，通过简单的操作，可实现运行 Debian/Ubuntu 等多个流行的 Linux 发行版本。
### Linux Deploy支持的功能

|  功能    | 项目 |
| :--: | :--: |
| 发行版本 | Debian、Ubuntu、Kali Linux、Arch Linux、Fedora、CentOS、Gentoo、Slackware、RootFS (tgz, tbz2, txz) |
| 安装类型 | 镜像文件、目录、分区、RAM |
| 文件系统 | ext2、ext3、ext4 |
| 架构 | ARM、ARM64、x86、x86_64（虚拟：ARM ~ x86） |
| 控制接口 | CLI、SSH、VNC、X11、Framebuffer |
| 桌面环境 | XTerm, LXDE, Xfce, MATE, other (manual configuration) |
| 语言 | 多语言界面 |

## 2. 安装busybox软件

   1. 将下载好的busybox安装在手机中
   2. 打开busybox，点击右上角三条横杠，选择设置，注意安装路径要设置为`/system/xbin`，其他设置如下：

<img src="https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/vTHLMV-Fj7IAD.jpg" alt="img" style="zoom: 45%;" />

   3. 设置完成后，返回主页可以看到本机的基本信息，包括CPU结构等，可以看到，我的手机CPU架构是arrch64，也就是arm64，所以我后面安装的Linux系统也要对应着。

<img src="https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/WbpGy9-30uALu.jpg" alt="img" style="zoom: 45%;" />

## 3. 安装Linux Deploy

### 1. 软件设置
在安装服务器前，我们要先对Linux Deploy这个软件进行一些基本的设置，需要注意的是环境中的PATH变量须填写busybox上的安装路径`/system/xbin`，这样系统才能够使用所有Linux命令（个别命令不能使用）。同时记得开启CPU唤醒和开机自动启动，遇到无故重启的时候也能够自动启动服务器。

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/31MEOM-H5BnmU.jpg' alt='31MEOM-H5BnmU' style='zoom:33%;'/>

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/10eLfs-CRfcsd.jpg' alt='10eLfs-CRfcsd' style='zoom:33%;'/>

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/hfxxSH-4kIfAc.jpg' alt='hfxxSH-4kIfAc' style='zoom:33%;'/>

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/ex5vUy-2VzkMX.jpg' alt='ex5vUy-2VzkMX' style='zoom:33%;'/>

### 2. 配置Linux Deploy

进入主页，点击右上角打开菜单，选择配置文件，修改当前配置文件或者添加新的配置文件，该配置文件用于切换不同的配置。

回到主页，先不要着急安装，先点击右下角的配置按钮，进入配置窗口。

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/STemN8-27zm6b.jpg' alt='STemN8-27zm6b'/>

建议修改的内容：

1. 修改架构
如为 arm64 架构的 CPU，建议将架构修改为 arm64。其实armhf也是arm架构，只是版本较低，适合低端手机处理器，arm64兼容armhf，顾这里选择arm64即arrch64。

2. 修改源地址
如果在国内，请将源地址改为国内的镜像，海外的源下载速度可能会慢。

例如 Debian 的源：<https://mirrors.163.com/debian/> 或 <https://mirrors.tuna.tsinghua.edu.cn/debian/>
如果选择安装的其他发行版本，如CentOs或Ubuntu，个人使用的是Debian，网上也有用Ubuntu的，其实Ubuntu可能会更适合arm64结构的处理器。

3. 设置安装类型和安装路径
安装类型有很多种，这里选择目录进行安装，镜像安装会出现一些问题，如果镜像安装出现问题可以查看[Linux Deploy 项目介绍](https://www.htcp.net/4427.html)中的常见问题。
这里安装类型选择目录，安装路径选择`/data/sdcard/debian`，可以根据自己需要自行设置，建议下载[re管理器](http://download.pc6.com/down/56118)便于管理目录。

4. 修改文件系统
将文件系统修改为 ext4，可提高性能。

5. 修改用户名
可以将用户名修改为其它的。

6. 修改用户密码
可以将用户密码修改为其它的，安装完毕后即可使用自己设置的密码。

7. 挂载
启用挂载，可以将手机本机存储挂载到Linux服务器中，这样载服务器就能利用本地存储存取数据了。
勾选启用按钮，编辑挂载点列表，输入`/sdcard:/sdcard`即可。

8. 启用 SSH
选中『允许使用 SSH 服务器』复选框，可顺便在『SSH 设置』中，修改 SSH 的端口。这样即可使用 SSH 连接容器。

9. **下面是我的个人配置，供参考：**

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/HtlMLk-6UjeHP.jpg' alt='HtlMLk-6UjeHP' style='zoom:33%;' />

另外，如果有需要，可以在配置里开启初始化功能，这样会在服务器`/etc/rc.local`中创建一个自启动文件，可以自定义添加一些脚本命令，每次启动服务器就会自动执行。

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/XYYGrp-WpOjyS.jpg' alt='XYYGrp-WpOjyS' style='zoom:45%;'/>

## 安装Linux

配置完成后，点击右上角，选择安装，点击确定就会开始安装。

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/25bTfm-Ln2Kb4.jpg' alt='25bTfm-Ln2Kb4'/>

</br>

</br>

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/YqEHI1-QT1bxH.jpg' alt='YqEHI1-QT1bxH'/>

</br>

系统会在配置的目录下面下载所需的文件，等待安装完成后会显示`<<< deploy`。

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/GKnz5H-device-2018-03-31-144354.png' alt='GKnz5H-device-2018-03-31-144354'/>

安装完成后先别急着启动，先垫一下停止后，再点右下角的『▶启动』按钮，即可启动 Linux。

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/dFy0RY-zjVn76.jpg' alt='dFy0RY-zjVn76'/>

启动完毕后，将会显示 `<<< start`。
到此安装部分结束。

## 通过SSH登录服务器

在同一个局域网下，通过Mac或Windows终端进行连接，我这里用的是Mac平台的[iTerm2](https://iterm2.com)（搭配oh-my-zsh真的超级好用），一款很好用的终端替代工具，结合朋友推荐的[FinalShell](http://www.hostbuf.com/t/988.html)共同用于服务器开发。

在命令行输入`ssh codechf@192.168.1.8 -p 22`，解释过来就是`ssh 用户名@主页顶部的ip地址 -p 端口号`。

<img src='https://gitee.com/codechf/uPic-file/raw/master/uPic/2021/01/fjy2gy-sNsELx.png' alt='fjy2gy-sNsELx'/>

现在就可以远程操控我们的服务器啦。
