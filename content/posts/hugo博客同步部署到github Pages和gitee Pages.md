---
title: Hugo博客同步部署到github Pages和gitee Pages
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

<!--more-->

# hugo博客同步部署到github和gitee的两种方法

## 方法一



## 方法二

在hugo站点根目录hugo/myblog下，新建脚本deploy.sh，因为我用的是mac电脑，能够运行.sh后缀的脚本文件，如果是windows就需要新建deploy.bat文件，然后里面写上需要执行的终端命令，即完成博客发布的一系列过程，hugo发布目录默认是public作为gitee的本地仓库，通过`hugo --destination="public_github"`命令指定hugo发布的目录，作为github的本地仓库。

deploy.sh

```sh
#该脚本实现myblog/content下的文章更新、config.toml配置文件更新和同时部署到gitee码云和github

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



#自动部署到gitee码云
echo "\033[0;32mDeploying updates to Gitee...\033[0m"
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



#同步部署到github上面
echo "\033[0;32mDeploying updates to GitHub...\033[0m"
hugo
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

```

站点根目录结构：

![截屏2020-11-02 12.59.05](https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/11/sPkuiL-%E6%88%AA%E5%B1%8F2020-11-02%2012.59.05.png)