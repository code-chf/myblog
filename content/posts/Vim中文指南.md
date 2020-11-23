---
title: Vim中文指南
date: 2020-10-06T11:39:37+08:00
lastmod: 2020-10-06T11:39:37+08:00
author: codechf
authorlink: https://github.com/code-chf
cover: /img/vim操作指南.jpeg
categories:
  - 文档
tags:
  - 文档
draft: false
---

收录Vim中文操作指南，方便自己学习vim。
<!--more-->
# Vim 中文指南

帮助
--

`:help command`

查找帮助

例如`:help v` 查找关于命令 `v` 的帮助文档，养成查找帮助文档的好习惯～

退出 Vim
------

`:q[uit]`

退出 Vim

操作在当文件有更改时会失败.

`:q[uit]!`

忽略更改并退出 Vim

`:qa`

退出所有打开的文件

`:cq[uit]`

忽略更改并退出所有打开的文件

`:wq`

保存并退出 Vim

`:wqa`

保存并退出所有文件

`:wq!`

强制保存并退出 Vim

`:wq {file}`

保存当前文件到 {file}, 文件如果在编辑的话会失败

`:wq! {file}`

强制保存当前文件到 {file}

`:[range]wq[!]`

只保存指定行范围内的内容并且退出

例如 `1,2wq!` 表示只保存第一和第二行的内容，其他的的删除，然后退出

`ZZ`

保存并且强制退出 Vim

等同于 `wq!`

`ZQ`

强制退出不保存

相当于 `q!`

编辑文件
----

`:e[dit]`

编辑 (重新载入) 当前文件

当文件被另一个用户重新保存时，:e 命令会重新从文件系统加载文件

`:e[dit]!`

强制编辑 (重新载入) 当前文件

忽略当前更改，强制从文件系统重新加载文件，当需要忽略当前更改时有用

`:e[dit] {file}`

编辑 {file}

`:e[dit]! {file}`

编辑 {file}

忽略当前文件的更改，强制编辑 {file}

`gf`

编辑光标下文件名所代表的文件

助记: goto file

插入文本
----

`a`

在光标后开始插入

`A`

在光标所在行尾开始插入

`i`

在光标前开始插入

`I`

在光标所在行头开始插入

`o`

在当前光标下新起一行开始编辑

`O`

在当前光标上新起一行开始编辑

插入文件
----

`:r[ead] [name]`

读取并插入 \[name\] 的文件内容到当前光标下

例如 `:r sys.log` 将 sys.log 的内容插入到当前光标下

`:r[ead] !{cmd}`

执行命令并且将命令的标准输出插入到当前光标下

例如 `:r !date` 把当前日期插入到当前光标下一行

删除文本
----

`x`

删除光标之后的字符

`<Del>`

`X`

删除光标之前的字符

`d{motion}`

删除 {motion} 所代表范围内的文本

例如 `dw` 删除光标所在单词中光标以及后面的单词；`daw` 删除光标所在单词；`d$` 删除光标所在行后面的字符；`d0` 删除光标所在行前面的字符

`[count]dd`

删除光标及以下一共 \[count\] 行， 如不指定 \[count\] 则删除光标所在行

`D`

删除光标所在行后面的字符

相当于 `d$`

`{Visual}x`

`{Visual}d`

在可视化模式下删除选中的字符

查看可视化模式下的文本选择类目

`{Visual}CTRL-H`

`{Visual}<BS>`

在选择模式下删除选中的文本，`gh` 进入选择模式

`{Visual}X`

`{Visual}D`

在可视化模式下删除选中的行

`:[range]d[elete]`

删除 \[range\] 范围内的行

默认情况下删除当前光标所在行，例如`:2d` 删除第二行，`:2,3d` 删除第二到第三行

`:[range]d[elete] {count}`

从指定范围开始删除 {count} 行

例如`:2d 10` 从第二行开始删除十行

变更 / 替换文本
---------

`r{char}`

用 {char} 替换光标下的字符

`R`

进入插入模式，但是对于输入是替换而不是插入

例如按 `R` 后输入 1234, 如果插入的位置原本有字符，那么原来的字符将被替换成 1234, 行的长度不会增加

`~`

切换光标所在字符的大小写，并且光标向右移

可以在光标所在处连续将后面的字符的大小写更改

`g~{motion}`

替换 {motion} 范围内的文本的大小写

`{Visual}~`

切换选中文本的大小写

`{Visual}U`

切换选中文本到大写

`SHIFT+I+<comment-char>+ESC+ESC`

块插入

按 `CTRL+V` 进入块选择，选择完之后按照上述操作输入想插入的字符

`x`

块删除

按 `CTRL+V` 进入块选择，然后 `x` 删除选中的字符

信息
--

`%`

跳转和光标上的字符对应的字符上去

例如文本 \[error\], 在 \[上 `%` 会跳转到\] 上，反之跳转到 \[上

`*`

搜索光标所在单词并高亮

范围
--

范围允许将命令应用于当前缓冲区中的一组行。对于大多数命令，默认范围是当前行。

*   `:21s/old/new/g` - 替换第 21 行的 old 为 new
*   `:1s/old/new/g` - 第一行
*   `:$s/old/new/g` - 最后一行
*   `:%s/old/new/g` - 所有行
*   `:.,$s/old/new/g` - 当前行到最后一行

替换 (substitute)
---------------

对范围内的每一行替换 {pattern} 为 {string}

:\[range\]s\[ubstitute\]/{pattern}/{string}/\[c\]\[e\]\[g\]\[p\]\[r\]\[i\]\[I\] \[count\]

重复上一步：使用相同的搜索模式和替换字符串进行替换，但不使用相同的标志

:\[range\]s\[ubstitute\] \[c\]\[e\]\[g\]\[r\]\[i\]\[I\] \[count\] :\[range\]&\[c\]\[e\]\[g\]\[r\]\[i\]\[I\] \[count\]

你可以添加其他的标志。

替换时你能使用的参数如下:

*   `[c]` 确认每一次替换，Vim 会执行对应匹配的内容。你能输入以下命令:

    *   `y` 替换 (Y)
    *   `n` 跳过 (N)
    *   `a` 替换其余所有
    *   `q` 退出
    *   `CTRL-E` 向上滚动屏幕
    *   `CTRL-Y` 向下滚动屏幕
*   `[e]` 当搜索模式失败时，不要发出错误消息，继续进行

*   `[g]` 替换行中出现的所有项。如果没有此参数，则仅对每行中的第一个匹配进行替换

*   `[i]` 忽略匹配时的大小写

*   `[I]` 不忽略匹配时的大小写

*   `[p]` 打印替换的最后一行内容

拷贝 / 移动文本
---------

`"{a-zA-Z0-9.%#:-"}`

使用寄存器存储临时数据，用于下一次操作

[寄存器分类](https://harttle.land/2016/07/25/vim-registers.html)

`:reg[isters]`

`:di[splay]`

展示所有寄存器的值

`:reg[isters] {arg}`

`:di[splay] [arg]`

查看指定寄存器的值

`["x]y{motion}`

复制 {motion} 所代表的内容 \[到寄存器 x\]

`["x][count]yy`

`["x][count]Y`

复制 \[count\] 行 (默认当前行)\[到寄存器 x\]

`{Visual}["x]y`

可视化模式下复制选中文本 \[到寄存器 x\]

见选择文本相关内容

`{Visual}["x]Y`

可视化模式下复制选中行 \[到寄存器 x\]

`:[range]y[ank] [x]`

复制 \[range\] 行范围 \[到寄存器 x\]

`:[range]y[ank] [x] {count}`

复制 {count} 行 \[到寄存器 x\], \[range\] 取最后一个数字

默认取当前行

`["x][count]p`

粘贴 \[寄存器 x\] 内容 \[count\] 次到光标后

默认是匿名寄存器

`["x][count]P`

粘贴 \[寄存器 x\] 内容 \[count\] 次到光标前

`["x]gp`

同 `p`, 然后将光标移至新文本后

`["x]gP`

同 `P`, 然后将光标移至新文本后

`:[line]pu[t] [x]`

粘贴 \[寄存器 x\] 内容到 \[line\] 行后

默认当前行

`:[line]pu[t]! [x]`

粘贴 \[寄存器 x\] 内容到 \[line\] 行前

撤消、重做和重复
--------

`[count]u`

撤销前 \[count\] 个修改

`:u[ndo]`

撤销上一次操作

`[count]CTRL-R`

重做 \[count\] 个撤销操作，即恢复

`:red[o]`

重做上个撤销操作

`U`

恢复当前行（即一次撤销对当前行的全部操作）

`.`

重复上一命令对编辑缓冲区的修改

光标移动
----

基础命令

  k              <上>
h   l      <左>         <右>
  j              <下>

`[count]h`

`[count]<Left>`

向左移动

`[count]l`

`[count]<Right>`

`[count]<Space>`

向右移动

`[count]k`

`[count]<Up>`

`[count]CTRL-P`

向上移动

`[count]j`

`[count]<Down>`

`[count]CTRL-J`

`[count]<NL>`

`[count]CTRL-N`

向下移动

`0`

`<Home>`

行首

`^`

到行首的第一个非空字符

`$`

`<End>`

行尾

`g0`

`g<Home>`

对于超出屏幕的一行，移动到屏幕的最左边不是整行的最左边，而是屏幕的最左边

`g^`

与 `g0` 不同的是移动到第一个非空字符

`g$`

`g<End>`

对于超出屏幕的一行，移动到屏幕的最右边不是整行的最右边，而是屏幕的最右边

`f{char}`

在当前行往右边寻找下一个 {char} 出现的位置

`fd` 寻找下一个 d 出现的位置

`F{char}`

在当前行往左边寻找上一个 {char} 出现的位置

与 `f{char}` 命令相反

`t{char}`

正向移动到下一个 {char} 的前一个字符上

`T{char}`

反向移动到上一个 {char} 的后一个字符上

`[count];`

重复上一个 `f``F``t``T` 命令 \[count\] 次

`[count],`

反方向重复上一个 `f``F``t``T` 命令 \[count\] 次

当跳转过头了之后可以使用 `,` 操作回到之前的位置

`- <minus>`

向上 \[count\] 行，光标回到行首第一个非空字符上

`+`

`CTRL-M`

`<CR>`

向下 \[count\] 行，光标回到行首第一个非空字符上

`_ <underscore>`

向下 \[count\]-1 行，光标回到行首第一个非空字符上

`CTRL-End`

`G`

去第 \[count\] 行首第一个非空字符

默认：最后一行

`CTRL-Home`

`gg`

去第 \[count\] 行首第一个非空字符

默认：第一行

`SHIFT-Right`

`w`

按照标点或者空格向右移动 \[count\] 个词，光标在词的开头

例如 ii d d d,e,d w,dd, 对于空格和标点 w 都作为分隔符

`CTRL-Right`

`W`

按照空格向右移动 \[count\] 个词，光标在词的开头

例如 ii d d d,e,d w,dd, 对于空格 W 作为分隔符

`e`

按照标点或者空格向右移动 \[count\] 个词，光标在词的结尾

`E`

按照空格向右移动 \[count\] 个词，光标在词的结尾

`SHIFT-Left`

`b`

按照标点或者空格向左移动 \[count\] 个词，光标在词的开头

`CTRL-Left`

`B`

按照空格向左移动 \[count\] 个词，光标在词的开头

`ge`

按照标点或者空格向左移动 \[count\] 个词，光标在词的结尾

`gE`

按照空格向左移动 \[count\] 个词，光标在词的结尾

`H`

移动光标到屏幕上方

`M`

移动光标到屏幕中间

`L`

移动光标到屏幕底部

`zz`

当前行滚动到屏幕中间

`zt`

当前行滚动到屏幕顶部

`zb`

当前行滚动到屏幕底部

以下命令在 `words` 或者 `WORDS` 间移动 `word` 由字母、数字和下划线组成，或者由其他非空白字符组成，用空格 (空格、制表符、<EOL>) 分隔。这可以通过 “iskeyword” 选项进行更改。 `WORD` 由一系列非空白字符组成，用空格分隔。空行也被认为是一个单词和一个单词。

`(`

向后跳过 \[count\] 个 sentences

`)`

向前跳过 \[count\] 个 sentences

`{`

向后跳过 \[count\] 个段落

`}`

向前跳过 \[count\] 个段落

`]]`

向前跳过 \[count\] 节或者跳到下个第一列的 {

通过`:help ]]` 获取帮助信息

`][`

向前跳过 \[count\] 节或者跳到下个第一列的}

通过`:help ][`获取帮助信息

`[[`

向后跳过 \[count\] 节或者跳到下个第一列的 {

通过`:help [[`获取帮助信息

`[]`

向后跳过 \[count\] 节或者跳到下个第一列的}

通过`:help []` 获取帮助信息

标记
--

`m{a-zA-Z}`

在光标所在位置设置标记 {a-zA-Z}

标记可以方便在文档的不同位置之间跳转

`m'`

``m\` ``

设置前面的上下文标记

通过`:help m'` 获取更多信息

`:[range]ma[rk] {a-zA-Z}`

`:[range]k{a-zA-Z}`

在 \[range\] 的最后一个数字所在行首设置标记 {a-zA-Z}

默认为光标所在行

`'{a-z}`

跳转到标记 {a-z}

例如`'a` 跳转到标记 a

`'{A-Z0-9}`

跳转到标记 {A-Z0-9}

大写标记可以跨越不同的缓冲区，即可以在不同的文件之间跳转

`` `{a-z}``

跳转到标记 {a-z}

`` `{A-Z0-9}``

跳转到标记 {A-Z0-9}, 这个命令跨越不同的缓冲区

`:marks`

列出所有标记

`:marks {arg}`

列出指定的标记

搜索
--

`/{pattern}[/]<CR>`

往前搜索匹配 {pattern} 的内容

例如 `/df` 从光标处向前搜索匹配 df 的内容

`/{pattern}/{offset}<CR>`

往上或往下 {offset} 行向前搜索匹配 {pattern} 的内容

`/<CR>`

重复上一次向前搜索

`//{offset}<CR>`

重复上一次向前搜索

`?{pattern}[?]<CR>`

向后搜索匹配 {pattern} 的内容

`?{pattern}?{offset}<CR>`

往上或往下 {offset} 行向后搜索匹配 {pattern} 的内容

`?<CR>`

重复上一次向后搜索

`??{offset}<CR>`

重复上一次向后搜索

`n`

跳到下一个搜索结果

`N`

跳到上一个搜索结果

`:lv {pattern} [g][j] {file(s)}`

使用内部的 grep 命令在文件中搜索，，

结果放在 QuickFix 列表中，列表可以使用`:cw` 打开

*   'g' 返回所有匹配项，而不仅仅是每行一个匹配项
*   'j' 不自动调到第一个匹配项
*   递归搜索使用 `**` 模式例如 `**/*.c`

选择文本 (可视化模式 Visual Mode)
------------------------

要选择文本，请使用下面的命令之一进入可视化模式，并使用运动命令高亮显示感兴趣的文本。然后，对文本使用一些命令。

可以使用的操作符是:

*   `~` 切换大小写
*   `d` 删除
*   `c` 更改
*   `y` 复制
*   `>` 右挪
*   `<` 左挪
*   `!` 使用外部命令过滤
*   `=` 使用 'equalprg' 过滤
*   `gq` 将行格式化为 “textwidth” 长度

`v`

按字符启动可视化模式

`V`

按行启动可视化模式 (水平方向)

`CTRL-V`

按行启动可视化模式 (垂直方向)

`<Esc>`

退出可视化模式

`viw`

可视化模式下选择当前光标所在单词

暂停
--

`CTRL-Z`

暂停 Vim

将 vim 放置在后台，使用 `jobs` 命令可以查看有哪些后台 vim 在运行， 使用 `fg 序号`命令可以将对应的 vim 转到前台

`:sus[pend][!]`

`:st[op][!]`

暂停 Vim!

多窗口
---

`:e filename`

编辑另一个文件

`:split filename`

水平拆分窗口然后打开另一个文件

`CTRL-W v`

垂直拆分窗口

`CTRL-W s`

水平拆分当前窗口

`CTRL-W Arrow Up`

移动光标到上一个窗口

`CTRL-W CTRL-W`

循环切换窗口

`CTRL-W_`

最大化当前矿口

`CTRL-W=`

所有窗口一样大

`10 CTRL-W+`

将当前窗口增大 10 行高度

`:vsplit file`

垂直拆分并打开另一个文件

`:sview file`

`split` 的 readonly 模式

`:hide`

关闭当前窗口

`:only`

仅保持当前窗口打开

`:ls`

展示当前缓存区列表（文件列表）

`:b 2`

打开缓冲区中编号为 2 的文件

`:bd[n]`

关闭当前缓冲区

标签式浏览
-----

当编辑程序时，通常需要跳转到另一个位置。Vim 使用一个标记文件来列出每个单词和 的位置。标记文件必须由能够处理文件语法的实用程序创建，并且必须在进行了重要的编辑之后进行更新。

`CTRL-]`

`LMB-on-tag+CTRL`

`g LMB-on-tag`

跳转到标签

`CTRL+t`

跳转后返回

`:tags`

显示标签堆栈

内部列表
----

*   Vim 使用一个全局的 QuickFix 列表。列表包含了由其他命令填充的文件位置.
*   Vim 每个窗口有一个位置列表。该列表类似于 QuickFix 列表，包含文件中的位置列表。

`:cw`

打开全局的 QuickFix 列表

`:ccl`

关闭 QuickFix 列表

`:lw`

打开位置列表

Notes
-----

*   基于 [fprintf](http://www.fprintf.net/vimCheatSheet.html).
*   由 [cstfb](https://github.com/cstfb) 基于 [Arief Bayu Purwanto](https://github.com/ariefbayu) 制作的 Vim 速查表翻译而来.

vim使用操作技巧，日常使用整理
-----
1. `cw`表示修改单词并进入插入模式，需要光标在单词的第一个字母，如果光标在单词内，需要按`ciw`表示`change in word`

我的vimrc配置文件
-----

```vimScript

"为Vim脚本文件设置折叠{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" 适合自己用的vimrc配置{{{
" =======================================

set number "设置添加序号
set ts=4 "设TAB宽度为4个空格
set softtabstop=4 "在编辑模式的时候按退格键的时候退回缩进的长度
set shiftwidth=4 "每一级缩进的长度
set noexpandtab "缩进用空格来表示，noexpandtab 则是用制表符表示一个缩进
set autoindent "自动缩进
set formatoptions=tcrqn "自动格式化
set showcmd "输入的命令显示出来，看的清楚些
set relativenumber "以特别的方式显示行号
if has("syntax") "设置代码高亮，加了判断，代码文件才高亮
    syntax on
endif

autocmd BufWritePost $MYVIMRC source $MYVIMRC "保存.vimrc文件时，自动重启加载文件，让文件立即生效
"set cursorline " 突出显示当前行
set hlsearch "高亮显示所有搜索到的内容，后面用map映射快捷键来方便关闭当前搜索的高亮
set incsearch "光标立刻跳转到搜索到的内容
set confirm "处理未保存或只读文件的适合，弹出确认
set nocompatible "去除有关vi一致性模式，避免操作习惯上的局限
set showmatch "高亮显示括号匹配
set listchars=tab:>-,trail:- "显示空格和tab
set laststatus=2 "1:启动显示状态行，2:总是显示状态行
set history=200 "文件中需要记录的行数
set clipboard+=unnamed "共享剪贴板
setlocal foldmethod=marker "打开折叠功能
filetype indent on "打开文件类型检查，并且载入该类型对应的缩进规则。
set linebreak "不在单词内部拆
set noerrorbells "出错时，不要发出响声
set visualbell "出错时，屏幕闪烁

"}}}

"=============新建.c,.h,.sh,.java文件，自动插入文件头{{{
autocmd BufNewFile *.md,*.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()"
"定义函数SetTitle，自动插入文件头
func SetTitle()
    "如果文件类型为.md文件
	let type = &filetype
    if type == 'markdown'
        call setline(1, "---")
        call append(line("."), "title: ".expand("%"))
        call append(line(".")+1, "date: ".strftime("%FT%T+08:00"))
        call append(line(".")+2, "lastmod: ".strftime("%FT%T+08:00"))
        call append(line(".")+3, "author: codechf")
        call append(line(".")+4, "authorlink: https://github.com/code-chf")
        call append(line(".")+5, "cover: /img/default1.jpg")
        call append(line(".")+6, "categories:")
        call append(line(".")+7, "  - 其他")
        call append(line(".")+8, "tags:")
        call append(line(".")+9, "  - 其他")
        call append(line(".")+10, "draft: true")
        call append(line(".")+11, "---")
        call append(line(".")+12, "")
        call append(line(".")+13, "")
        call append(line(".")+14, "<!--more-->")
	endif

	if type == 'sh'
    	call setline(1, "/******************************")
        call append(line("."), "    > File Name: ".expand("%"))
        call append(line(".")+1, "    > Author:codechf")
        call append(line(".")+2, "    > Mail: 1968173984@qq.com")
        call append(line(".")+3, "    > Created Time: ".strftime("%F %T"))
        call append(line(".")+4, " *****************************/")
        call append(line(".")+5, "")
    endif

    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc
"}}}
"""=>编码设置<="""{{{
"设置编码"
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936

"设置文件编码"
set fileencodings=utf-8

"设置终端编码"
set termencoding=utf-8

"设置语言编码"
set langmenu=zh_CN.UTF-8
set helplang=cn
"}}}

```


