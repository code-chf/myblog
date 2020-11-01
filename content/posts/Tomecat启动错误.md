---
title: "Tomcat启动错误"
date: 2020-10-01T09:27:39+08:00
draft: false
cover: /img/tomcat无法启动.jpg
author: codechf
authorlink: https://github.com/code-chf
categories:
  - bug处理
tags:
  - 技术帖
---

Eclipse开发过程中，Tomcat无法启动的问题。
<!--more-->

### 描述：通过 eclipse 进行 java web 开发的时候偶尔会出现 tomcat 无法启动的问题。

![image-20200710123655732](https://gitee.com/codechf/uPic-file/raw/master/uPic/image-20200710123655732.png)

### 解决办法：

#### 有以下几种原因造成：

1. #### 端口被占用

2. #### tomcat 启动时间不够

3. #### eclipse 在管理 tomcat 时出现了问题。</br>

   #### 最后，发现 Servlet3.0 中出现了新增注释 @WebServlet ，在 Eclipse 生成一个新的 Servlet 类时会自动增加 @WebServlet 注释，改注释会自动为我们配置 web.xml，所以这时候我们再去配置 web.xml 就会产生冲突，tomcat 就不能启动。这个时候我们只需要删除  @WebServlet 或者删除 web.xml 配置就能正常启动 tomcat 了。

   #### @WebServlet注解和web.xml冲突导致的。

