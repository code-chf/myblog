---
title: 我的vimrc配置
date: 2020-11-23T16:39:44+08:00
lastmod: 2020-11-23T16:39:44+08:00
author: codechf
authorlink: https://github.com/code-chf
cover: https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/11/63kt4U-L5Xr73.png
categories:
  - 文档
tags:
  - 文档
draft: false
---

这是我的个人vimrc配置，vim编辑器的使用还在不断学习过程中。
<!--more-->

我的vimrc配置文件
-----

```javascript


"  __  __        __     _____ __  __ ____   ____ "
" |  \/  |_   _  \ \   / /_ _|  \/  |  _ \ / ___|"
" | |\/| | | | |  \ \ / / | || |\/| | |_) | |    "
" | |  | | |_| |   \ V /  | || |  | |  _ <| |___ "
" |_|  |_|\__, |    \_/  |___|_|  |_|_| \_\\____|"

"为Vim脚本文件设置折叠{{{"
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}"

" When started as 'evim', evim.vim will already have done these settings, bail out."
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want."
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead "
else
  set backup		" keep a backup file (restore to previous version) "
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing) "
  endif
endif

" Put these in an autocmd group, so that we can delete them easily. "
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters."
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages."
" The matchit plugin makes the % command work better, but it is not backwards compatible."
" The ! means the package won't be loaded right away but when plugins are loaded during initialization."
if has('syntax') && has('eval')
  packadd! matchit
endif

" 适合自己用的vimrc配置{{{"
" ======================================="

set number "设置添加序号"
set ts=4 "设TAB宽度为4个空格"
set softtabstop=4 "在编辑模式的时候按退格键的时候退回缩进的长度"
set shiftwidth=4 "每一级缩进的长度"
set noexpandtab "缩进用空格来表示，noexpandtab 则是用制表符表示一个缩进"
set autoindent "自动缩进"
set formatoptions=tcrqn "自动格式化"
set showcmd "输入的命令显示出来，看的清楚些"
set relativenumber "以特别的方式显示行号"
if has("syntax") "设置代码高亮，加了判断，代码文件才高亮"
    syntax on
endif

autocmd BufWritePost $MYVIMRC source $MYVIMRC "保存.vimrc文件时，自动重启加载文件，让文件立即生效"
"set cursorline "" 突出显示当前行"
set hlsearch "高亮显示所有搜索到的内容，后面用map映射快捷键来方便关闭当前搜索的高亮"
set incsearch "光标立刻跳转到搜索到的内容"
set confirm "处理未保存或只读文件的适合，弹出确认"
set nocompatible "去除有关vi一致性模式，避免操作习惯上的局限"
set showmatch "高亮显示括号匹配"
set listchars=tab:>-,trail:- "显示空格和tab"
set laststatus=2 "1:启动显示状态行，2:总是显示状态行"
set history=200 "文件中需要记录的行数"
set clipboard+=unnamed "共享剪贴板"
setlocal foldmethod=marker "打开折叠功能"
filetype indent on "打开文件类型检查，并且载入该类型对应的缩进规则。"
set linebreak "不在单词内部拆"
set noerrorbells "出错时，不要发出响声"
set visualbell "出错时，屏幕闪烁"

"}}}"

"=============新建.c,.h,.sh,.java文件，自动插入文件头{{{"
autocmd BufNewFile *.md,*.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()"
"定义函数SetTitle，自动插入文件头"
func SetTitle()
    "如果文件类型为.md文件，则保存文件的时候添加头部信息，用于博客"
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

    "新建文件后，自动定位到文件末尾"
    autocmd BufNewFile * normal G
endfunc
"}}}"
"=>编码设置<={{{"
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
"}}}"

```

