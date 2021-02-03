---
title: clash+动态域名解析+crontab实现完美科学上网
date: 2021-02-03T17:02:04+08:00
lastmod: 2021-02-03T17:02:04+08:00
author: codechf
authorlink: https://github.com/code-chf
cover: /img/default1.jpg
categories:
  - 其他
tags:
  - 其他
draft: false
---
本教程通过clash以及它的局域网共享功能实现所有设备的科学上网（设备需设置手动代理），并利用DNSPod + 个人域名 + ArDNSPod脚本实现动态域名的绑定，利用crontab实现自动更新域名。

<!--more-->
# 用clash实现多终端科学上网
clash是比较推荐的一个科学上网工具，支持MacOS、Windows、路由器等终端，还有一个比较好的功能，那就是电脑实现了科学上网，只需要把“允许局域网连接”打开，局域网下的所有设备通过手动设置代理就可以实现科学上网，既不用买昂贵的软路由，也避免了手机等设备使用VPN的电量损耗，还能享受电脑强大的CPU算力，带来更稳定的科学上网体验。我们这里假设已经实现了科学上网。

## 1.实现多设备科学上网
- **我的终端设备：**
Clash for MacOs、iPhone 8、iPad 10.5、小米5

- **电脑端准备**
电脑端点击上方任务栏的clash图标，勾选“允许局域网连接”，一定要勾选此项，这样clash的端口才会开放出来。
然后打开电脑设置里的“网络”，记下当前电脑的局域网IP地址，我的是`192.168.1.17`，然后打开clash的控制台，点击“设置”，记下“HTTP代理端口”，默认是"7890"。

- **设备端准备**
打开手机或其他设备的Wi-Fi设置选项，保证电脑和设备在一个局域网下，及一个网关下，打开Wi-Fi选择界面，点击Wi-Fi右侧的按钮进入Wi-Fi高级设置界面，找到` 代理 `或` HTTP代理 `，选择` 手动 `，输入服务器地址（电脑的IP地址），以及端口（clash的HTTP代理端口，默认7890），点击存储后浏览器打开[www.google.com](https://www.google.com)或[www.youtube.com](https://www.youtube.com)就能够正常访问了，可以看到手机无需打开vpn，也不用折腾软路由，就能够实现科学上网，前提是电脑不关机。

## 2.实现DDNS动态域名解析
- **为什么需要动态域名解析？**
手机设置代理上网，需要电脑的局域网IP地址，在不固定IP的情况下，IP地址会受网关重启、断电等因素重新分配，所以局域网IP地址也是动态的，每次IP变化后，都需要在手机端重新设置代理IP，个人觉得超级麻烦，前几天折腾IPV6 DDNS动态解析的时候，就想把局域网IP绑定域名，这样在手机设置代理的时候只需要设置绑定好的域名就可以了。

- **购买域名并设置好域名解析**
  我的域名是在腾讯云中购买，价格周到，域名地址：[codechf.cn](codechf.cn)
  进入控制台，选择“DNS 解析 DNSPod”进入域名解析窗口，选择“添加记录”，内容如下：
  
  |   主机记录   |          记录类型           | 线路类型 |     记录值     | MX优先级 | TTL  |
  | :----------: | :-------------------------: | :------: | :------------: | :------: | :--: |
  |    clash     |              A              |   默认   |       v        |    -     | 600  |
  | 可以随便设置 | A表示ipv4<br />AAAA表示ipv6 |   默认   | 电脑的IPV4地址 |    -     | 默认 |

- **设置自动化脚本，定时更新ipv4地址**
这里用到了ArDNSPod脚本（作者[imki911](https://github.com/imki911/ArDNSPod),改自[anrip](https://github.com/anrip/dnspod-shell))。
开始设计脚本前，我们要先利用腾讯云的接口，在dnspod的管理界面[https://console.dnspod.cn/account/token#](https://console.dnspod.cn/account/token#)创建API Token，创建成功后获得ID和Token，利用这两个信息，就可以通过API修改域名解析值了，详见API文档：[https://www.dnspod.cn/docs/info.html#d](https://www.dnspod.cn/docs/info.html#d)。

首先进入[https://github.com/imki911/ArDNSPod](https://github.com/imki911/ArDNSPod)，下载脚本文件，将之前得到的ID和token写入dns.conf 文件, 并指定要绑定的子域名。注意arToken由ID和Token通过英文逗号组合而成。

**dns.conf**
```bash

# 1. Combine your token ID and token together as follows
arToken="211315,0ad030f2ff924e3add1ddsfs454fs1d"

# 2. Place each domain you want to check as follows
# you can have multiple arDdnsCheck blocks
arDdnsCheck "codechf.cn" "clash"

```

ddnspod.sh中，IPtype选择1或2，如果没有nvram，将`ip addr show dev eth0 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d' | awk 'NR==1'`中的 eth0 改为本机上的网口设备（通过ipconfig命令查看网络接口）

我将文件dns.conf中的内容复制到ddnspod.sh的最后，并注释掉. $DIR/dns.conf（也可以不用合并成两个文件，参照作者描述方法）。最终形成一个文件ddnspod.sh。

**ddnspod.sh**
```bash
#!/bin/bash
source /etc/profile
#################################################
# AnripDdns v5.08
# Dynamic DNS using DNSPod API
# Original by anrip<mail@anrip.com>, http://www.anrip.com/ddnspod
# Edited by ProfFan
#################################################

#################################################
# 2018-11-06 
# support  LAN / WAN / IPV6 resolution
# 2019-05-24
# Support Ipv6 truly (Yes, it was just claimed to, but actually not = =!)
# Add another way resolving IPv6, for machines without nvram.

#if you have any issues, please let me know.
# https://blog.csdn.net/Imkiimki/article/details/83794355
# Daleshen mailto:gf@gfshen.cn

#################################################

#Please select IP type
IPtype=2  #1.WAN 2.LAN 3.IPv6
#---------------------
if [ $IPtype = '3' ]; then
    record_type='AAAA'
else
    record_type='A'
fi
echo Type: ${record_type}

# OS Detection
case $(uname) in
  'Linux')
    echo "OS: Linux"
    arIpAddress() {

	case $IPtype in
		'1')
				
		curltest=`which curl`
		if [ -z "$curltest" ] || [ ! -s "`which curl`" ] 
		then
			#根据实际情况选择使用合适的网址
			#wget --no-check-certificate --quiet --output-document=- "https://www.ipip.net" | grep "IP地址" | grep -E -o '([0-9]+\.){3}[0-9]+' | head -n1 | cut -d' ' -f1
			wget --no-check-certificate --secure-protocol=TLSv1_2 --quiet --output-document=- "http://members.3322.org/dyndns/getip" | grep -E -o '([0-9]+\.){3}[0-9]+' | head -n1 | cut -d' ' -f1
			#wget --no-check-certificate --secure-protocol=TLSv1_2 --quiet --output-document=- "ip.6655.com/ip.aspx" | grep -E -o '([0-9]+\.){3}[0-9]+' | head -n1 | cut -d' ' -f1
			#wget --no-check-certificate --secure-protocol=TLSv1_2 --quiet --output-document=- "ip.3322.net" | grep -E -o '([0-9]+\.){3}[0-9]+' | head -n1 | cut -d' ' -f1
		else
		curl -k -s "http://members.3322.org/dyndns/getip" | grep -E -o '([0-9]+\.){3}[0-9]+' | head -n1 | cut -d' ' -f1
		#curl -L -k -s "https://www.ipip.net" | grep "IP地址" | grep -E -o '([0-9]+\.){3}[0-9]+' | head -n1 | cut -d' ' -f1

		#curl -k -s ip.6655.com/ip.aspx | grep -E -o '([0-9]+\.){3}[0-9]+' | head -n1 | cut -d' ' -f1
		#curl -k -s ip.3322.net | grep -E -o '([0-9]+\.){3}[0-9]+' | head -n1 | cut -d' ' -f1		
		fi
		;;
 
		'2')
		
		ip -o -4 addr list | grep -Ev '\s(docker|lo)' | awk '{print $4}' | cut -d/ -f1 
		;;
 
		'3')
		
		# 因为一般ipv6没有nat ipv6的获得可以本机获得
		#ifconfig $(nvram get wan0_ifname_t) | awk '/Global/{print $3}' | awk -F/ '{print $1}' 
		ip addr show dev en0 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d' | awk 'NR==1' #如果没有nvram，使用这条，注意将eth0改为本机上的网口设备 （通过 ifconfig 查看网络接口）
		;;
 	esac
 
    }
    ;;
  'FreeBSD')
    echo 'FreeBSD'
    exit 100
    ;;
  'WindowsNT')
    echo "Windows"
    exit 100
    ;;
  'Darwin')
    echo "Mac"
    arIpAddress() {
        ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
    }
    ;;
  'SunOS')
    echo 'Solaris'
    exit 100
    ;;
  'AIX')
    echo 'AIX'
    exit 100
    ;;
  *) ;;
esac

echo "Address: $(arIpAddress)"

# Get script dir
# See: http://stackoverflow.com/a/29835459/4449544
rreadlink() ( # Execute the function in a *subshell* to localize variables and the effect of `cd`.

  target=$1 fname= targetDir= CDPATH=

  # Try to make the execution environment as predictable as possible:
  # All commands below are invoked via `command`, so we must make sure that `command`
  # itself is not redefined as an alias or shell function.
  # (Note that command is too inconsistent across shells, so we don't use it.)
  # `command` is a *builtin* in bash, dash, ksh, zsh, and some platforms do not even have
  # an external utility version of it (e.g, Ubuntu).
  # `command` bypasses aliases and shell functions and also finds builtins 
  # in bash, dash, and ksh. In zsh, option POSIX_BUILTINS must be turned on for that
  # to happen.
  { \unalias command; \unset -f command; } >/dev/null 2>&1
  [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on # make zsh find *builtins* with `command` too.

  while :; do # Resolve potential symlinks until the ultimate target is found.
      [ -L "$target" ] || [ -e "$target" ] || { command printf '%s\n' "ERROR: '$target' does not exist." >&2; return 1; }
      command cd "$(command dirname -- "$target")" # Change to target dir; necessary for correct resolution of target path.
      fname=$(command basename -- "$target") # Extract filename.
      [ "$fname" = '/' ] && fname='' # !! curiously, `basename /` returns '/'
      if [ -L "$fname" ]; then
        # Extract [next] target path, which may be defined
        # *relative* to the symlink's own directory.
        # Note: We parse `ls -l` output to find the symlink target
        #       which is the only POSIX-compliant, albeit somewhat fragile, way.
        target=$(command ls -l "$fname")
        target=${target#* -> }
        continue # Resolve [next] symlink target.
      fi
      break # Ultimate target reached.
  done
  targetDir=$(command pwd -P) # Get canonical dir. path
  # Output the ultimate target's canonical path.
  # Note that we manually resolve paths ending in /. and /.. to make sure we have a normalized path.
  if [ "$fname" = '.' ]; then
    command printf '%s\n' "${targetDir%/}"
  elif  [ "$fname" = '..' ]; then
    # Caveat: something like /var/.. will resolve to /private (assuming /var@ -> /private/var), i.e. the '..' is applied
    # AFTER canonicalization.
    command printf '%s\n' "$(command dirname -- "${targetDir}")"
  else
    command printf '%s\n' "${targetDir%/}/$fname"
  fi
)

DIR=$(dirname -- "$(readlink "$0")")

# Global Variables:

# Token-based Authentication
arToken=""
# Account-based Authentication
arMail=""
arPass=""

# Load config

#. $DIR/dns.conf

# Get Domain IP
# arg: domain
arDdnsInfo() {
    local domainID recordID recordIP
    # Get domain ID
    domainID=$(arApiPost "Domain.Info" "domain=${1}")
    
    domainID=$(echo $domainID | sed 's/.*{"id":"\([0-9]*\)".*/\1/')
    
    # Get Record ID
    recordID=$(arApiPost "Record.List" "domain_id=${domainID}&sub_domain=${2}&record_type=${record_type}")
    
    recordID=$(echo $recordID | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
    
    # Last IP
    recordIP=$(arApiPost "Record.Info" "domain_id=${domainID}&record_id=${recordID}&record_type=${record_type}")
    
    recordIP=$(echo $recordIP | sed 's/.*,"value":"\([0-9a-z\.:]*\)".*/\1/')
    
    # Output IP
    case "$recordIP" in 
      [1-9a-z]*)
        echo $recordIP
        return 0
        ;;
      *)
        echo "Get Record Info Failed!"
        return 1
        ;;
    esac
}

# Get data
# arg: type data
# see Api doc: https://www.dnspod.cn/docs/records.html#
arApiPost() {
    local agent="AnripDdns/5.07(mail@anrip.com)"
    #local inter="https://dnsapi.cn/${1:?'Info.Version'}"
    local inter="https://dnsapi.cn/${1}"
    if [ "x${arToken}" = "x" ]; then # undefine token
        local param="login_email=${arMail}&login_password=${arPass}&format=json&${2}"
    else
        local param="login_token=${arToken}&format=json&${2}"
    fi
    wget --quiet --no-check-certificate --secure-protocol=TLSv1_2 --output-document=- --user-agent=$agent --post-data $param $inter
}

# Update
# arg: main domain  sub domain
arDdnsUpdate() {
    local domainID recordID recordRS recordCD recordIP myIP
    
  
    # Get domain ID
    domainID=$(arApiPost "Domain.Info" "domain=${1}")
    domainID=$(echo $domainID | sed 's/.*{"id":"\([0-9]*\)".*/\1/')
    #echo $domainID
    # Get Record ID
    recordID=$(arApiPost "Record.List" "domain_id=${domainID}&record_type=${record_type}&sub_domain=${2}")
    recordID=$(echo $recordID | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
    #echo $recordID
    # Update IP
    myIP=$(arIpAddress)
    recordRS=$(arApiPost "Record.Modify" "domain_id=${domainID}&sub_domain=${2}&record_type=${record_type}&record_id=${recordID}&record_line=默认&value=${myIP}")
    recordCD=$(echo $recordRS | sed 's/.*{"code":"\([0-9]*\)".*/\1/')
    recordIP=$(echo $recordRS | sed 's/.*,"value":"\([0-9a-z\.:]*\)".*/\1/')
    
    # Output IP
    if [ "$recordIP" = "$myIP" ]; then
        if [ "$recordCD" = "1" ]; then
            echo $recordIP
            return 0
        fi
        # Echo error message
        echo $recordRS | sed 's/.*,"message":"\([^"]*\)".*/\1/'
        return 1
    else
        echo $recordIP #"Update Failed! Please check your network."
        return 1
    fi
}

# DDNS Check
# Arg: Main Sub
arDdnsCheck() {
    local postRS
    local lastIP
    local hostIP=$(arIpAddress)
    echo "Updating Domain: ${2}.${1}"
    echo "hostIP: ${hostIP}"
    lastIP=$(arDdnsInfo $1 $2)
    if [ $? -eq 0 ]; then
        echo "lastIP: ${lastIP}"
        if [ "$lastIP" != "$hostIP" ]; then
            postRS=$(arDdnsUpdate $1 $2)
             
            if [ $? -eq 0 ]; then
                echo "update to ${postRS} successed."
                return 0
            else
                echo ${postRS}
                return 1
            fi
        fi
        echo "Last IP is the same as current, no action."
        return 1
    fi
    echo ${lastIP}
    return 1
}

# DDNS
#echo ${#domains[@]}
#for index in ${!domains[@]}; do
#    echo "${domains[index]} ${subdomains[index]}"
#    arDdnsCheck "${domains[index]}" "${subdomains[index]}"
#done

#载入dns.conf
#. $DIR/dns.conf
# 1. Combine your token ID and token together as follows
arToken="211315,0ad030f2ff924e3add1dd44c57d5231b"

# 2. Place each domain you want to check as follows
# you can have multiple arDdnsCheck blocks
arDdnsCheck "codechf.cn" "clash"


```
