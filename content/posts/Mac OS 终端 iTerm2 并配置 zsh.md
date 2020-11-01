---
title: "Mac OS 终端 iTerm2 并配置 zsh"
date: 2020-06-18T09:27:39+08:00
draft: false
cover: /img/mac终端iterm2有关配置.png
author: codechf
authorlink: https://github.com/code-chf
categories:
  - Mac操作相关
tags:
  - Mac
  - 技术帖
---

MacOs 第三方shell（iTerm）并配置zsh
<!--more-->
Mac OS 终端 iTerm2
================

之前一直使用的 Mac OS 自带的终端，觉得也还可以，后来看大神 onevcat 的直播视频，发现他用的是 iTerm，真的是非常好用，于是自己也开始倒腾起来。

iTerm2
------

### 1\. 下载安装

[官网下载地址](https://link.jianshu.com?t=https%3A%2F%2Fwww.iterm2.com%2Fdownloads.html)

下载下来直接是一个 App ，你可以直接打开，也可以把它拖到 Applications 目录下。

### 2\. 偏好设置

`菜单` —> `Preferences` —> `Profiles`

![](/i/3aeb5c3a-00f6-47fb-bbc4-9cdb6cdfabad.jpg)

在左侧的列表里显示了你的所有配置文件（`Profile`），目前列表里只有一个默认的 `Default`，这个是 iTerm 默认的窗口模板配置文件，我们接下来创建自己的窗口配置文件。

点击列表下方的 `+` 号，新建配置文件

![](/i/8be1c671-57d4-4a83-8c5a-355b0b827f29.jpg)

`General` 里面填写基础的配置：

* **Name**：配置文件名称
* **Shortcut Key**：打开该窗口的快捷键
* **Tags**：标签，方便在左侧列表快速查找到该配置文件
* **Badge**：标记，在窗口上显示你的个人标识。

`Colors` 里面设置颜色相关的配置：

* **Foreground**：前景色，窗口文字颜色
* **Background**：窗口背景色
* **Links**：链接的颜色
* **Selection**：选中内容的背景色
* **Selected Text**：选中文字的颜色
* **Badge**：标记的颜色
* **Cursor**：光标的颜色

> 这里还可以去网上下载主题配色，然后使用别人配置的主题，[下载地址](https://link.jianshu.com?t=https%3A%2F%2Fgithub.com%2Fmbadolato%2FiTerm2-Color-Schemes)，下载完成以后，选择 `Color Presets` —> `Import`，选择你下载的文件夹，找到目录下的 `schemes` 文件夹，选中里面你想要的主题，点击 `open` 导入，然后就可以使用了。

> [修改 mac 终端 (terminal) 字体颜色](https://link.jianshu.com?t=http%3A%2F%2Fblog.csdn.net%2Fzhongtiankai%2Farticle%2Fdetails%2F71597499)

`Text` 里面设置窗口文字相关的配置：

* **Cursor**：光标的样式
* **Font**：文字字体

`Window` 里设置窗口相关的配置：

* **Transparency**：窗口的透明度
* **Background Image**：窗口的背景图片

### 3\. 亮点功能

#### 快速隐藏和显示

`Profiles` —> `Keys` —> `Hotkey`，选中，默认的快捷键是：`option + Space`

#### 自动补齐

iTerm2 可以自动补齐命令，输入若干字符，按 `Command + ;` 弹出自动补齐窗口，列出曾经使用过的命令。

#### 时间轴

如果你想查看你最近一段时间执行的操作，可以使用时间轴功能。

快捷键：`Command + Option + B`

#### 智能选中

在 iTerm2 中，双击选中，三击选中整行。可以识别网址，引号引起的字符串，邮箱地址等。

在 iTerm2 中，选中即复制。即任何选中状态的字符串都被放到了系统剪切板中。

#### 强大的 Command 键

按住 `command` 键：

* 可以拖拽选中的字符串
* 点击 `url`：调用默认浏览器访问该网址
* 点击文件：调用默认程序打开文件
* 点击文件夹：在 `Finder` 中打开该文件夹
* 同时按住 `option` 键，可以以矩形选中

#### 常用快捷键

快捷键

说明

`Command + Shift + H`

历史粘贴记录

`Command + Shift + ;`

历史命令记录

`Command + D`

同个窗口横向分屏

`Command + Shift + D`

同个窗口竖向分屏

`Command + Option + E`

快速预览所有窗口

`Command + /`

高亮当前鼠标的位置

`Command + T`

新建窗口

`Command + W`

关闭窗口

`Command + 左右方向键`

切换窗口

`Command + 上下方向键`

上下滚动内容

`Command + 数字`

切换至指定窗口

`Command + ,`

打开偏好设置

`Command + F`

智能查找

zsh
---

### 1\. 下载安装

Mac 系统自带了 `zsh`, 一般不是最新版，如果需要最新版可通过 `Homebrew` 来安装。

```bash
brew install zsh
```

可通过 `zsh --version` 查看 `zsh` 的版本。

安装完成以后，将 `zsh` 设置为默认的 `Shell`。

```bash
chsh -s /bin/zsh
```

### 2\. 安装 oh my zsh

使用 `crul` 安装：

```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

使用 `wget` 安装：

```bash
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

安装成功：

```bash
Cloning Oh My Zsh...
Cloning into '/root/.oh-my-zsh'...
remote: Counting objects: 712, done.
remote: Compressing objects: 100% (584/584), done.
remote: Total 712 (delta 15), reused 522 (delta 4), pack-reused 0
Receiving objects: 100% (712/712), 443.58 KiB | 27.00 KiB/s, done.
Resolving deltas: 100% (15/15), done.
Checking connectivity... done.
Looking for an existing zsh config...
Using the Oh My Zsh template file and adding it to ~/.zshrc
Copying your current PATH and adding it to the end of ~/.zshrc for you.
Time to change your default shell to zsh!
        __                                     __
 ____  / /_     ____ ___  __  __   ____  _____/ /_
/ __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \
/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / /
\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/
                       /____/                       ....is now installed!

Please look over the ~/.zshrc file to select plugins, themes, and options.
p.s. Follow us at https://twitter.com/ohmyzsh.
p.p.s. Get stickers and t-shirts at http://shop.planetargon.com.
```

> 安装完成以后，默认 `Shell` 的 `~/.bashrc` 文件默认不再加载了，替代的是 `~/.zlogin` 和 `~/.zshrc`。所以如果你在 `~/.bashrc` 里配置了某些设置，需要把她们复制到 `~/.zshrc` 中。

#### oh my zsh 目录结构

进入 `~/.oh-my-zsh` 目录后，看看该目录的结构

```bash
~ ls ~/.oh-my-zsh
CONTRIBUTING.md cache           log             templates
LICENSE.txt     custom          oh-my-zsh.sh    themes
README.md       lib             plugins         tools
```

* lib 提供了核心功能的脚本库
* tools 提供安装、升级等功能的快捷工具
* plugins 自带插件的存在放位置
* templates 自带模板的存在放位置
* themes 自带主题文件的存在放位置
* custom 个性化配置目录，自安装的插件和主题可放这里

### 3\. 配置

`zsh` 的配置主要集中在 `~/.zshrc` 里，用 `vim` 或你喜欢的其他编辑器打开`.zshrc`。

可以在此处定义自己的环境变量和别名，当然，`oh my zsh` 在安装时已经自动读取当前的环境变量并进行了设置，你可以继续追加其他环境变量。

#### 别名设置：

`zsh` 不仅可以设置通用别名，还能针对文件类型设置对应的打开程序，比如：

* `alias -s html=vi`，意思就是你在命令行输入 `hello.html`，`zsh` 会为你自动打开 `vim` 并读取 `hello.html`；

* `alias -s gz='tar -xzvf'`，表示自动解压后缀为 `gz` 的压缩包。
  
  ```bash
  alias cls='clear'
  alias ll='ls -l'
  alias la='ls -a'
  alias vi='vim'
  alias javac="javac -J-Dfile.encoding=utf8"
  alias grep="grep --color=auto"
  alias -s html=vi   # 在命令行直接输入后缀为 html 的文件名，会在 vim 中打开
  alias -s rb=vi     # 在命令行直接输入 ruby 文件，会在 vim 中打开
  alias -s py=vi       # 在命令行直接输入 python 文件，会用 vim 中打开，以下类似
  alias -s js=vi
  alias -s c=vi
  alias -s java=vi
  alias -s txt=vi
  alias -s gz='tar -xzvf'
  alias -s tgz='tar -xzvf'
  alias -s zip='unzip'
  alias -s bz2='tar -xjvf'
  ```

#### 主题设置：

`oh my zsh` 提供了数十种主题，相关文件在 `~/.oh-my-zsh/themes` 目录下，你可以自己选择，也可以自己编写主题。

在`.zshrc` 里找到 `ZSH_THEME`，就可以设置主题了，默认主题是：`ZSH_THEME=”robbyrussell”`

`ZSH_THEME="random"`，主题设置为随机，这样我们每打开一个窗口，都会随机在默认主题中选择一个。

#### 插件设置：

`oh my zsh` 项目提供了完善的插件体系，相关的文件在 `~/.oh-my-zsh/plugins` 目录下，默认提供了 100 多种，大家可以根据自己的实际学习和工作环境采用，想了解每个插件的功能，只要打开相关目录下的 `zsh` 文件看一下就知道了。插件也是在`.zshrc` 里配置，找到 `plugins` 关键字，你就可以加载自己的插件了，系统默认加载 `git`，你可以在后面追加内容，如下：

```bash
plugins=(git zsh-autosuggestions autojump zsh-syntax-highlighting)
```

##### 安装 `zsh-autosuggestions`

```bash
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

添加至 `plugins`

##### 安装 `zsh-syntax-highlighting`

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

添加至 `plugins`

### 卸载 oh my zsh

直接在终端中，运行 `uninstall_oh_my_zsh` 既可以卸载。

参考文章
----

[终极 Shell zsh](https://link.jianshu.com?t=http%3A%2F%2Fmacshuo.com%2F%3Fp%3D676)  
[zsh 全程指南](https://link.jianshu.com?t=http%3A%2F%2Fwdxtub.com%2F2016%2F02%2F18%2Foh-my-zsh%2F)