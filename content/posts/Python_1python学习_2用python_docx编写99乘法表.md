---
title: 用python_docx编写99乘法表
date: 2020-11-02T18:57:31+08:00
lastmod: 2020-11-02T18:57:31+08:00
author: codechf
authorlink: https://github.com/code-chf
cover: https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/11/jzhm9F-OEkeFN.png
categories:
  - python
tags:
  - 编程语言
  - 技术帖
draft: false
---

使用第三方库python_docx实现99乘法表的创建过程，使用python_docx中的table块。

<!--more-->

# 实现步骤：

1. 安装python_docx

   `pip install python_docx`

2. 创建python项目，我使用的是ide工具Pycharm

3. 编写代码，我使用的是面向对象的思想

4. 实现要求：

   - 创建9x9的空表格
   - 赋予表格样式
   - 以三角形式在表格中呈现99乘法表
   - 为99乘法表的每个算式赋予随机色
   - 生成文件名为word_table99.docx的文档

5. 实现代码如下：

   ```python
   import random
   
   from docx import Document
   from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT
   from docx.enum.text import WD_PARAGRAPH_ALIGNMENT
   from docx.shared import RGBColor, Pt
   
   class createTable:
       row = 0
       line = 0
       # set row and line.
       def setrow(self, row):
           self.row = row
       def setline(self, line):
           self.line = line
   
       # get row and line.
       def getrow(self):
           return  self.row
       def getline(self):
           return  self.line
   
       def getText(self):
           result = self.getrow()*self.getline()
           text = str(self.getrow())+"×"+str(self.getline())+"=" + str(result)
           return text
   
   
   if __name__=='__main__':
       # Create a object.
       document = Document()
       # Create a table.
       document.styles['Normal'].font.name = u'Cambria'
       table = document.add_table(9, 9)
       # Add style.
       table.style = 'Light Shading'
       ct = createTable()
   
       for i in range(1, 10):
           for j in range(i, 10):
               cell = table.cell(j-1, i-1)
               ct.setrow(i)
               ct.setline(j)
               cell.text = ct.getText()
               run = cell.paragraphs[0]
               cell_text = run.runs[0]
               cell_text.font.color.rgb =RGBColor(random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
               run.alignment = WD_PARAGRAPH_ALIGNMENT.CENTER
   
       # Saved as a file.
       document.add_page_break()
       document.save('word_table99.docx')
   ```

6. 在项目根目录生成文件`word_table99.docx`

7. 文件内容：

   ![截屏2020-11-02 19.06.36](https://gitee.com/codechf/uPic-file/raw/master/uPic/2020/11/MDbVWm-%E6%88%AA%E5%B1%8F2020-11-02%2019.06.36.png)



# 总结

1. 第三方包python_docx实现用python对docx文件的读写操作，含有大量的方法实现对docx文档的编辑操作。
2. 官方文档：[https://python-docx.readthedocs.io/en/latest/index.html](https://python-docx.readthedocs.io/en/latest/index.html)
3. python_docx项目地址： [python_docx@GitHub](http://github.com/python-openxml/python-docx)

