---
title: Python爬虫_3Request模块
date: 2020-10-25T18:24:24+08:00
lastmod: 2020-10-25T18:24:24+08:00
author: codechf
authorlink: https://github.com/code-chf
cover: https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/10/u2zXfx-qQpUod.png
categories:
  - Python
tags:
  - 编程语言
  - 技术帖
draft: false
---
学习使用Requests模块实现简单爬取数据的目标，完成get/post两种方式的学习，以及学习异步请求，局部刷新AJAX的数据如何爬取，包含一些实践内容。
<!--more-->

## Request模块

- urlib模块
- requests模块

### 概念

Python中原生的一款基于网络请求的模块，功能强大，简单便捷，效率极高。

### 作用

模拟浏览器发送请求。

### 浏览器请求步骤（requests模块的编码流程）

1. 指定URL
2. 发起请求get/post
3. 获取响应数据
4. 数据分析并持久化存储

### 环境配置：

1. 编程软件如Pycharm、vscode等
2. Python环境，Anaconda或其他
3. requests第三方包：pip install requests

### 实战模拟

1. **爬取搜狗首页页面数据**

   ```python
   import requests
   if __name__ == "__main__":
       # set url
       url = "https://www.sogou.com/"
       # 发送get请求，返回一个对象
       response = requests.get(url)
       # 获取响应数据.text返回的是字符串形式的响应数据
       page_text = response.text
       print(page_text)
       # 持久化存储
       with open('./sogou.html', 'w', encoding='utf-8') as fp:
           fp.write(page_text)
       print('end！')
   ```

2. **爬取搜狗指定词条对应的搜索结果页面（简易网页采集器）**

   - UA检测
   - UA伪装

   ```python
   # 简易网页采集器
   import requests
   if __name__ == "__main__":
       # UA伪装，设置浏览器表识，简单防反扒机制，封装在请求字典中
       headers = {
           'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36'
       }
       # 静态url：https://www.sogou.com/web?query=你好
       url = 'https://www.sogou.com/web'
   
       # 设置动态参数，处理携带的参数
       # 封装到字典中
       kw = input('Enter a keyword:')
       param = {
           'query':kw
       }
   
       # 对指定的url携带参数，并且请求过程中处理了参数，动态拼接了参数
       response = requests.get(url=url, params=param, headers=headers)
   
       page_text = response.text
       fileName = kw + '.html'
       with open(fileName, 'w', encoding='utf-8') as fp:
           fp.write(page_text)
       print(fileName, 'successful!')
   ```

3. 破解百度翻译

   - post请求，异步刷新，AJAX请求（携带参数）
   - 响应的数据是一组json数据，`Content-Type: application/json; charset=utf-8`

   1. 静态获取

   ```python
   # 破解百度翻译，页面局部刷新，异步请求AJAX
   import requests
   import json
   
   if __name__ == '__main__':
       headers = {
           'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36'
       }
       # AJAX异步请求的地址，POST请求并携带了参数
       post_url = 'https://fanyi.baidu.com/sug'
   
       # post请求参数处理（与get请求一致）
       data = {
           'kw':'book'
       }
       # 使用requests发送POST请求,本案例中返回的是json数据
       response = requests.post(url=post_url, data=data, headers=headers)
   
       # 获取响应数据：json()方法返回的是object数据（只有响应数据类型为json格式，才能够使用本方法）
       dic_obj = response.json()
   
       # 持久化存储
       fp = open('./dog.json', 'w', encoding='utf-8')  # 创建空json文件
       json.dump(dic_obj, fp=fp, ensure_ascii=False)  # 将json存入到文件
   
       print('Successful!')
   ```

   2. 动态获取

   ```python
   # 动态破解百度翻译，页面局部刷新，异步请求AJAX
   import requests
   import json
   
   if __name__ == '__main__':
       headers = {
           'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36'
       }
       # AJAX异步请求的地址，POST请求并携带了参数
       post_url = 'https://fanyi.baidu.com/sug'
   
       # post请求参数处理（与get请求一致）
       word = input('Enter a word:')
       data = {
           'kw':word
       }
       # 使用requests发送POST请求,本案例中返回的是json数据
       response = requests.post(url=post_url, data=data, headers=headers)
   
       # 获取响应数据：json()方法返回的是object数据（只有响应数据类型为json格式，才能够使用本方法）
       dic_obj = response.json()
   
       # 持久化存储
       fileName = word + '.json'
       fp = open(fileName, 'w', encoding='utf-8')  # 创建空json文件
       json.dump(dic_obj, fp=fp, ensure_ascii=False)  # 将json存入到文件
   
       print('Successful!')
   ```

4. 爬取豆瓣电影分类喜剧排行榜数据：[https://movie.douban.com/j/chart/top_list](https://movie.douban.com/j/chart/top_list/)中的电影详情数据

   ```python
   # 多页爬取豆瓣内容，AJAX局部刷新
   import requests
   import json
   
   if __name__ == '__main__':
       headers = {
           'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36'
       }
       # AJAX异步请求的地址，get请求并携带了参数
       url = 'https://movie.douban.com/j/chart/top_list/'
   
       # get请求参数处理
       param = {
           'type': '24',
           'interval_id': '100:90',
           'action': '',
           'start': '120',  # 从库中的第几部电影去取
           'limit': '20'  # 一次取出的个数
       }
       response = requests.get(url=url, params=param, headers=headers)
   
       list_data = response.json()
   
       fp = open('./douban.json', 'w', encoding='utf-8')
       json.dump(list_data, fp=fp, ensure_ascii=False)
   
       print('successful!')
   ```

5. 爬取肯德基餐厅位置信息 [http://www.kfc.com.cn/kfccda/storelist/index.aspx](http://www.kfc.com.cn/kfccda/storelist/index.aspx)

   - 实现自定义城市查询

   ```python
   # 多页爬取肯德基门店信息
   import requests
   import json
   
   if __name__ == '__main__':
       headers = {
           'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36'
       }
       # AJAX异步请求的地址，post请求并携带了参数
       post_url = 'http://www.kfc.com.cn/kfccda/ashx/GetStoreList.ashx?op=keyword'
   
       # post请求参数处理
       word = input('请输入城市：')
       data = {
           'cname': '',
           'pid': '',
           'keyword': word,  # 关键字
           'pageIndex': '1',  # 获取的是第几页的数据
           'pageSize': '10',  # 每页显示的数据数量
       }
       response = requests.post(url=post_url, data=data, headers=headers)
   
       list_data = response.text
   
       fileName = word + '.json'
       fp = open(fileName, 'w', encoding='utf-8')
       json.dump(list_data, fp=fp, ensure_ascii=False)
   
       print('successful!')
   ```

   - 实现自定义城市多页查询

   ```python
   # 多页爬取肯德基门店信息
   import requests
   import json
   
   if __name__ == '__main__':
       headers = {
           'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36'
       }
       # AJAX异步请求的地址，post请求并携带了参数
       post_url = 'http://www.kfc.com.cn/kfccda/ashx/GetStoreList.ashx?op=keyword'
   
       # post请求参数处理
       word = input('请输入城市：')
       index = input('请输入每页显示记录的数目：')
       data = {
           'cname': '',
           'pid': '',
           'keyword': word,  # 关键字
           'pageIndex': '1',  # 获取的是第几页的数据
           'pageSize': index,  # 每页显示的数据数量
       }
       page_txt = requests.post(url=post_url, data=data, headers=headers).json()
   
       # 数据处理
       store_txt = []
       store_txt.append(page_txt['Table1'])  # page_txt中的Table1对应的就是数据
       cnt = page_txt['Table'][0]['rowcount']  # page_txt中的Table对应的是记录总数
       page_cnt = cnt//eval(index) + 2  # 页数
   
       # 多页查询
       for i in range(2, page_cnt):
           ki = str(i)
           data = {
               'cname': '',
               'pid': '',
               'keyword': word,  # 关键字
               'pageIndex': ki,  # 获取的是第几页的数据
               'pageSize': index,  # 每页显示的数据数量
           }
           page_txt = requests.post(post_url, data, headers).json()
           store_txt.append(page_txt['Table1'])
   
       # 持久化存储
       fileName = word + '.json'
       fp = open(fileName, 'w', encoding='utf-8')
       json.dump(store_txt, fp=fp, ensure_ascii=False)
   
       print('successful!')
   ```


6. 爬取国家药品监督管理总局中基于中华人民共和国化妆品生产许可证相关数据，[http://scxk.nmpa.gov.cn:81/xk/](http://scxk.nmpa.gov.cn:81/xk/)

   - 动态获取数据，找到正确的链接，通过ajax的方式请求数据。
   - 如何获取每个企业的详情页呢？


   ![e3ugDK-截屏2020-10-2620.18.07](https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/10/TCqGyn-e3ugDK-%E6%88%AA%E5%B1%8F2020-10-26%2020.18.07.png)


   1. 通过抓包工具分析，发现请求的数据是json格式，格式化后可以看到每条记录的详细信息：

      ![KQn195-截屏2020-10-2620.24.45](https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/10/2Ygdea-KQn195-%E6%88%AA%E5%B1%8F2020-10-26%2020.24.45.png)
      
      
      
      ### JSON数据
      
      ```json
      {
            		"ID": "ff83aff95c5541cdab5ca6e847514f88",
            	"EPS_NAME": "广东天姿化妆品科技有限公司",
            		"PRODUCT_SN": "粤妆20200022",
            		"CITY_CODE": null,
            		"XK_COMPLETE_DATE": {
            			"date": 17,
            			"day": 1,
            			"hours": 0,
            			"minutes": 0,
            			"month": 4,
            			"nanos": 0,
            			"seconds": 0,
            			"time": 1621180800000,
            			"timezoneOffset": -480,
            			"year": 121
            		},
            		"XK_DATE": "2025-01-16",
            		"QF_MANAGER_NAME": "广东省药品监督管理局",
            		"BUSINESS_LICENSE_NUMBER": "91440101MA5CYUF0XX",
            		"XC_DATE": "2021-05-17",
            		"NUM_": 1
            	}
      ```
      
      


   1. 可以发现，json数据中并没有相关url信息，无法提取对应的url。

   2. 通过观察，发现每个json数据中，都有 'ID'关键词，考虑是否和每个详情页的url相关。

   3. 分析详情页的url，`http://scxk.nmpa.gov.cn:81/xk/itownet/portal/dzpz.jsp?id=ff83aff95c5541cdab5ca6e847514f88`  ，发现链接url后面带了参数：`id=ff83aff95c5541cdab5ca6e847514f88` ，这个正好和每个json字段的id号相同，检验其他数据，发现规律，所有url都一样，只是id值不同，可以通过拼接url动态获取每个页面的信息。

   4. 难点：详情页中的企业详情数据也是动态加载出来的，所以不能通过动态url获取每个数据。

   5. 分析企业详情页数据，捕获AJAX请求，发现携带的参数是id，Content-Type是JSON，且每个企业详情页对应的AJAX请求url都一样，只有id不一样。

      URL：`http://scxk.nmpa.gov.cn:81/xk/itownet/portalAction.do?method=getXkzsById` 。

      ![6erGol-截屏2020-10-2620.39.23](https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/10/QoZBD9-6erGol-%E6%88%AA%E5%B1%8F2020-10-26%2020.39.23.png)

   **批量获取多家企业的id，将id和详情页数据的ajax的url，发送请求后就可以获得对应的json数据，关键问题是如何批量获取每个企业的id。**

   




