---
title: "Mac使用Tips汇总"
date: 2020-06-18T09:27:39+08:00
draft: false
cover: /img/mac使用tips.jpeg
author: codechf
authorlink: https://github.com/code-chf
categories:
  - Mac操作相关
tags:
  - Mac
  - 技术帖
---

Mac常用小技巧及黑苹果优化技巧。
<!--more-->
## 1.Mac访达显示隐藏文件

### 命令行：

   ```bash
   defaults write com.apple.finder AppleShowAllFiles -bool true;
   KillAll Finder
   ```
   > 将true改为false，即可恢复隐藏状态。killall Finder这条命令是重启访达，重启之后就可以看到隐藏的文件或文件夹。

### 快捷键：

   `command + Shift + .`

   

## 2.macOS 10.15.4 系统 / 更新系统后「意外退出」及「崩溃闪退」问题修复方法

### 1.第一步：准备工作

安装 Xcode：商店或网页安装
    
安装 Command Line Tools 工具：`xcode-select --install`
    
弹出安装窗口后选择`继续安装`，安装过程需要几分钟，请耐心等待

### 2.第二步：签名

输入命令：`sudo codesign --force --deep --sign - (应用路径)`

### 3.第三步：解决错误

如果遇到以下错误：
    
````bash
/文件位置 : replacing existing signature
/文件位置 : resource fork,Finder information,or similar detritus not allowed
````

先执行：`xattr -cr /文件位置（直接将应用拖进去即可）`

然后执行：`codesign --force --deep --sign - /文件位置（直接将应用拖进去即可）`

## 3.Mac去除设置小红点：

### 打开终端运行：

   `defaults write com.apple.systempreferences AttentionPrefBundleIDs 0`

   ### 然后重启Dock栏：

   `killall Dock`

   ### 如果上面不起作用的话，用这个：

   ```bash
   sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist LastUpdatesAvailable 0
   sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist LastRecommendedUpdatesAvailable 0
   sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate.plist RecommendedUpdates
   ```

   

## 4.黑果优化命令：

### 1.解决macOS和Windows时间同步：

```bash
Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1
```

### 2.重建Kexts缓存：

```bash
sudo rm /System/Library/PrelinkedKernels/prelinkedkernel
sudo rm /System/Library/Caches/com.apple.kext.caches/Startup/kernelcache
sudo chmod -R 755 /System/Library/Extensions
sudo chmod -R 755 /Library/Extensions
sudo chown -R root:wheel /System/Library/Extensions
sudo chown -R root:wheel /Library/Extensions
sudo touch /System/Library/Extensions
sudo touch /Library/Extensions
sudo kextcache -q -update-volume /
sudo kextcache -system-caches
sudo kextcache -i /
```

### 3.允许安装任何来源：

```bash
sudo spctl --master-disable
```

### 4.解决10.14以上系统字体模糊：

```bash
defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
```

### 5.系统睡眠优化代码：

更新了系统必须执行一次，否则电脑休眠会存在问题
```powershell
sudo pmset -a hibernatemode 0
sudo rm /var/vm/sleepimage
sudo mkdir /var/vm/sleepimage
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0
sudo pmset -a proximitywake 0
```

### 6.清除NvRAM/重置EC

*   请先移除电源适配器 (笔记本使用电池供电)
*   关机状态下按住 **`Fn + D + 电源按钮`**
*   键盘亮松开电源键，保持 **`Fn + D`**按住
*   出现第一屏松开 **`Fn + D`**
*   笔记本屏幕黑屏，按下回车键
*   弹出 CMOS 提示，再次按下回车键
*   电脑自动关机，需手动开机
*   NvRAM / EC 已重置