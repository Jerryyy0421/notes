---
title: Linux 学习笔记
date: 2023-07-22 16:38:10
tags:
- Linux
---

Linux 基础配置，包括 pacman 包管理，ranger 文件管理。

<!--more-->

### 更改字体大小

```bash
nvim ~/.Xresources
```

进去之后输入

```bash
Xft.dpi: 120
```

即可将字体调整到合适的大小了。

### 联网

刚开始的时候需要输入一下命令:

```
wpa_passphrase Wifi_name Wifi_password > internet.conf
```

之后每次启动都要输入以下命令：

```
ip link set wlo1 up
sudo wpa_supplicant -c internet.conf -i wlo1 &
sudo dhcpcd
```

### 配置 VPN

xfce 桌面环境下的 manjaro 没有图形化界面可以设置代理，只能用终端环境去编辑。

更改 proxy 配置，首先打开终端并输入:

```
sudo vim /etc/environment
```

然后找到以 “http_proxy” 开头的设置，如果没有就自己新建。

添加如下：

```
http_proxy="http://your_proxy_server:proxy_port"
https_proxy="http://your_proxy_server:proxy_port"
socks_proxy="http://your_proxy_server:proxy_port"
```

**参考：** [xface如何设置系统代理?](https://www.zhihu.com/question/586110918/answer/2910628561)

### pacman 教程

pacman 之于 Arch，就好比 App store 之于 IOS。

- `pacman -S xx`

    安装 xx 软件。

- `pacman -Sy`

    查询软件库是否是最新并更新。

- `pacman -Syy`

    强行刷新并更新至最新软件库。

- `pacman -Su`

    更新软件。

- `pacman -Syu`

    更新软件库并更新软件。

- `pacman -Syyu`

    强行刷新，更新至最新软件库并更新软件。

- `pacman -Ss xx`

    查询所有名称带 xx 的软件。

- `pacman -Sc`

    删除一些安装包等缓存。

- `pacman -R xx`

    删除软件。

- `pacman -Rs xx`

    删除软件及其相关依赖。

- `pacman -Rns xx`（推荐）

    删除软件，相关依赖以及全局配置文件（但不会删除个人配置文件，如.vimrc）。

- `pacman -Q`

    查询电脑上所有软件。

- `pacman -Q | wc -l`

    快速知道有多少软件。

- `pacman -Qe`

    查询自己装的所有软件。

- `pacman -Qeq`

    查询自己装的所有软件且不显示版本号。

- `pacman -Qs xx`

    查询所有名字带 xx 的软件。

- `pacman -Qdt`

    查询所有不再被依赖的软件。

- `pacman -Qdtq`

    查询所有不再被依赖的软件且不显示版本号。

- `pacman -R $(pacman -Qdtq)`

    删除所有不再被依赖的软件。

- `nvim /etc/pacman.conf` 

    编辑 pacman 的配置文件。

### Ranger 教程

- `k` `j` 控制同目录下上下文件移动

- `[` `]`  控制上级目录的上下文件移动
- `<Shift> + H` 在历史记录中退回 `<Shift> + L` 在历史记录中前进
- `zh` 或 `<Ctrl> + h` 显示或隐藏系统文件





### 其他

- 查看桌面环境（DE）

打开终端并复制粘贴此命令：

```text
echo $XDG_CURRENT_DESKTOP
```

- 查看系统信息

在终端中输入 `screenfetch` 即可，显示桌面环境版本以及其他系统信息。
