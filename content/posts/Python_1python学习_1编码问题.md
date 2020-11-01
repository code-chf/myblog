---
title: "BeautifulSoup编码问题"
date: 2020-10-01T09:27:39+08:00
draft: false
cover: /img/爬虫BeautifulSoup编码问题.jpg
author: codechf
authorlink: https://github.com/code-chf
categories:
  - Python
tags:
  - 编程语言
  - 技术帖
---
写爬虫遇到的BeautifulSoup编码问题。

<!--more-->

### 出问题的代码：


```python
beautifulSoup_list = []  # 保存建立的各省份BeautifulSoup
for item in province_url:
    req_second = urllib.request.Request(url=item, headers=headers)
    respoae_second = urllib.request.urlopen(req_second)
    soup_second = BeautifulSoup(respoae_second, 'html.parser')
    beautifulSoup_list.append(soup_second)
# 获取第二页面内容
index = 0
sql_clearn = "truncate table 超市省份表;"
effect_row = cursor.execute(sql_clearn)
connection.commit()
for item in beautifulSoup_list:
    so_second = beautifulSoup_list[index].find_all('tr', attrs={'height': '20'})
    for idx, tr in enumerate(so_second):
        if idx >= 0:
            tds = tr.find_all('td')
            print(tds[0].contents[0], tds[1].contents[0], tds[2].contents[0], tds[3].contents[0], tds[4].contents[0], tds[5].contents[0])
    index = index + 1
```

### 运行结果：

![image-20200710082914960](https://gitee.com/codechf/uPic-file/raw/master/uPic/image-20200710082914960.png)

#### 结果分析，可以看到部分出现了乱码，初步判定时页面编码问题，这个时候去看了一下爬取的url，网页上查看源代码，发现这样一条：

<META http-equiv=Content-Type content="text/html; charset=gb2312">

#### 每个页面都相同的一条，按理说网页编码已经是"GB2312"，怎么爬取下来会出现乱码呢？</br></br>

### 初步解决方法：在输出的时候先decode()解码为Unicode，再encode()编码为utf8，像这样：

```python
index = 0
sql_clearn = "truncate table 超市省份表;"
effect_row = cursor.execute(sql_clearn)
connection.commit()
for item in beautifulSoup_list:
    so_second = beautifulSoup_list[index].find_all('tr', attrs={'height': '20'})
    for idx, tr in enumerate(so_second):
        if idx >= 0:
            tds = tr.find_all('td')
            print(str(tds[0].contents[0]).decode('gb2312').encode('utf8'), str(tds[1].contents[0]).decode('gb2312').encode('utf8'), str(tds[2].contents[0]).decode('gb2312').encode('utf8'), str(tds[3].contents[0]).decode('gb2312').encode('utf8'), str(tds[4].contents[0]).decode('gb2312').encode('utf8'), str(tds[5].contents[0]).decode('gb2312').encode('utf8'))
    index = index + 1
```

### 结果报错：

![image-20200710084148545](https://gitee.com/codechf/uPic-file/raw/master/uPic/image-20200710084148545.png)

#### 说明str（）方法中没有decode（）属性

#### 尝试去掉str（），可是结果还是：

![image-20200710084511173](https://gitee.com/codechf/uPic-file/raw/master/uPic/image-20200710084511173.png)

#### 说明去掉str（）后，结果是一个对象，不能用decode（）</br>

### 思考一下，输出结果部分是乱码，那这样所以用decode（‘gb2312’）解码的时候，就会出现问题，愿意可能是因为输出编码不止一种编码，如果是其他编码的话，用gb2312去解码就会出现问题。

### 换一种思路，爬取网页的时候，先将页面全部转换为一种编码。

#### 先用这段代码判断一下爬取到的网页的编码：

```python
print(soup_second.original_encoding)
```

#### 结果如下：

![image-20200710085232037](https://gitee.com/codechf/uPic-file/raw/master/uPic/image-20200710085232037.png)

#### 结果分析：爬取到的编码果然不同，两种编码方式。怎么统一呢？

### 查找原因，发现这是Beautifulsoup4框架内部的结果，Beautifuldoup4网页解码的时候，会自动去猜测网页的编码格式，但是也有猜错的时候，像上面这样的结果就是猜错的情况。

</br>

### 最终解决办法，建立Beautiful对象的时候指定编码为gb18030。

```python
beautifulSoup_list = []  # 保存建立的各省份BeautifulSoup
for item in province_url:
    req_second = urllib.request.Request(url=item, headers=headers)
    respoae_second = urllib.request.urlopen(req_second)
    soup_second = BeautifulSoup(respoae_second, 'html.parser', from_encoding='gb18030')
    beautifulSoup_list.append(soup_second)
```

### 完美解决问题。

### 附上所有代码：

```python
# -*- coding: utf-8 -*-
import urllib.request
from urllib import request
from bs4 import BeautifulSoup
import re
import pymysql
import chardet

quote_url = "http://www.wal-martchina.com/walmart/store/province.htm"
headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36'
    }
req =urllib.request.Request(url=quote_url, headers=headers)
respoae = urllib.request.urlopen(req)
soup = BeautifulSoup(respoae, 'html.parser')

so = soup.find('table', attrs={'class': 'style5'})
name_province = so.find_all(href=re.compile(".htm"))
province_url = []  # 定义url空列表
province_name = []  # 定义name空列表

# 正则表达式获取短链接，拼接成长链接
# 正则表达式获取省份名字
for item in name_province:
    province_url.append("http://www.wal-martchina.com/walmart/store/"+re.search(r'[a-zA-z]+.htm', str(item)).group())
    province_name.append(re.search(r'[\u4e00-\u9fa5].*[\u4e00-\u9fa5]', str(item)).group())

beautifulSoup_list = []  # 保存建立的各省份BeautifulSoup
for item in province_url:
    req_second = urllib.request.Request(url=item, headers=headers)
    respoae_second = urllib.request.urlopen(req_second)
    soup_second = BeautifulSoup(respoae_second, 'html.parser', from_encoding='gb18030')
    # print(soup_second.original_encoding)
    beautifulSoup_list.append(soup_second)

connection = pymysql.connect(host='localhost', port=3306, user='root', password='cc122112', db='databases', charset='utf8')
# 获取游标
cursor = connection.cursor()
# 创建数据表
sql_clearn = "truncate table 省份表;"
effect_row = cursor.execute(sql_clearn)
index = 0
for i in province_name:
    sql = "insert into `省份表` values ('沃尔玛', '"+i+"', '"+province_url[index]+"');"
    effect_row = cursor.execute(sql)
    index = index + 1
connection.commit()

# 获取第二页面内容
index = 0
sql_clearn = "truncate table 超市省份表;"
effect_row = cursor.execute(sql_clearn)
connection.commit()
for item in beautifulSoup_list:
    so_second = beautifulSoup_list[index].find_all('tr', attrs={'height': '20'})
    for idx, tr in enumerate(so_second):
        if idx >= 0:
            tds = tr.find_all('td')
            # print(tds[0].contents[0], tds[1].contents[0], tds[2].contents[0], tds[3].contents[0], tds[4].contents[0], tds[5].contents[0])
            sql = "insert into 超市省份表 values ('沃尔玛', '"+str(tds[0].contents[0])+"', '"+str(tds[1].contents[0])+"', '"+str(tds[2].contents[0])+"', '"+str(tds[3].contents[0])+"', '"+str(tds[4].contents[0])+"', '"+str(tds[5].contents[0])+"');"
            # effect_row = cursor.execute(sql)
    index = index + 1
connection.commit()
```