---
title: "Mac加速时间机器备份"
date: 2020-06-18T09:27:39+08:00
draft: false
cover: /img/macos时间机器加速备份.png
author: codechf
authorlink: https://github.com/code-chf
categories:
  - Mac操作相关
tags:
  - Mac
  - 技术帖
---
解决Macos时间机器备份速度慢的问题。
<!--more-->
### macOS时间机器备份加速命令

```bash
sudo sysctl debug.lowpri_throttle_enabled=0
```

### 回恢复为原来的速度的命令

```bash
sudo sysctl debug.lowpri_throttle_enabled=1
```

