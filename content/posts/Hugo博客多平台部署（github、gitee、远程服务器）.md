---
title: Hugo博客多平台部署（github、gitee、远程服务器）
date: 2020-11-02T12:45:22+08:00
lastmod: 2020-11-02T12:45:22+08:00
author: codechf
authorlink: https://github.com/code-chf
cover: https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/11/lK8wV7-0Wcd50.png
categories:
  - 教程
tags:
  - 技术帖
draft: false
---

自动将博客部署到github、gitee和远程服务器的方法，实现博客的自动化过程。

<!--more-->

# hugo博客多平台自动部署

用hugo搭建个人博客时，常常需要部署到github或gitee，因为github支持自动部署但国内访问速度很慢，gitee免费版速度快但却不支持自动部署，而且还不能绑定自己的域名，所以最后研究出下面的同时部署的方法。

同时，自己搭建了一个服务器，所以加上远程服务器，现在有三个平台需要同步。

## 方法一

手动部署，用git手动部署，缺点是麻烦，优点是可以针对性部署。

## 方法二

在hugo站点根目录hugo/myblog下，新建脚本deploy.sh，因为我用的是mac电脑，能够运行.sh后缀的脚本文件，如果是windows就需要新建deploy.bat文件，然后里面写上需要执行的终端命令，即完成博客发布的一系列过程，hugo发布目录默认是public作为gitee的本地仓库，通过`hugo --destination="public_github"`命令指定hugo发布的目录，作为github的本地仓库。

**自动化脚本deploy.sh**

```sh

#该脚本实现myblog/content下的文章更新、config.toml配置文件更新和同时部署到gitee码云和github

echo "\033[0;32m开始同步hugo博客站点！!\033[0m"
#git博客站点主要文件
git add config.toml
git add content/*
git add deploy.sh
git add README.md

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
#删除url并重新添加url
git remote rm origin
git remote add origin https://github.com/code-chf/myblog.git
git push -u origin master
echo "\033[0;32mHugo站点同步成功！!\033[0m"


#自动部署到gitee码云
echo "\033[0;32m开始部署到Gitee...\033[0m"
# 用hugo建立一个静态站点
hugo --baseURL="https://codechf.gitee.io"
# Go To Public folder
cd public
# Add changes to git.
# git init
git add .
# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
#删除url并重新添加url
git remote rm origin
git remote add origin https://gitee.com/codechf/codechf.git
# Push source and build repos.
git push -u origin master
# Come Back up to the Project Root
cd ..
echo "\033[0;32mGitee部署成功！\033[0m"


#同步部署到github上面
echo "\033[0;32m开始部署到GitHub...\033[0m"
#自定义创建public_github发布目录
hugo --destination="public_github"
# Go To Public folder
cd public_github
# git init
git add .
# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
#删除url并重新添加url
git remote rm origin
git remote add origin https://github.com/code-chf/code-chf.github.io.git
# Push source and build repos.
git push -u origin master
# Come Back up to the Project Root
cd ..
echo "\033[0;32mGithub部署成功！\033[0m"

#部署到个人本地服务器
echo "\033[0;32m开始部署到远程服务器...\033[0m"
#自定义创建public_server发布目录
hugo --destination="public_server" --baseURL="/"
# Go To Public folder
cd public_server
# git init
git add .
# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
#删除url并重新添加url
git remote rm origin
git remote add origin git@ipv6.codechf.cn:/home/gitrepo/public_server.git
# Push source and build repos.
git push origin master
# Come Back up to the Project Root
cd ..

#登录ssh自动从git服务器pull到/root/myblog/public_server
ssh codechf@ipv6.codechf.cn > /dev/null 2>&1 << eeooff
cd /root/myblog/public_server
git pull /home/gitrepo/public_server.git
exit
eeooff
echo "\033[0;32m远程服务器部署成功！\033[0m"
echo "\033[0;32m脚本运行完毕！\033[0m"

```

站点根目录结构：

![截屏2020-11-02 12.59.05](https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/11/sPkuiL-%E6%88%AA%E5%B1%8F2020-11-02%2012.59.05.png)
