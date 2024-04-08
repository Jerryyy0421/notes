---
title: Linux学习笔记：git专题
date: 2023-08-27 21:11:29
tags:
- Linux
---

git 学习笔记。

<!--more-->

### 0. 前言

git 是一款非常强大的版本管理软件，它可以使你的文字稿 / 代码 / 图片等很好地存储管理起来，让其不在丢失，甚至能看到你修改过的不同痕迹。而 github 是一个著名开源平台，你可以将代码放在该网站上，它上面的一个个仓库既可以让你存放你的代码，让别人看见，也可以让你学习到别人的代码，起到 ”我为人人，人人为我“ 的开源作用。

本文参考于 [再也不丢文件的方法～ Git从入门到精通](https://www.bilibili.com/video/BV1Yx411f7Cu/?spm_id_from=333.1007.top_right_bar_window_custom_collection.content.click&vd_source=0f0f84fd4f7853dba4619576003d75fb)。

### 1. 本地基础操作

把当前文件夹变为一个 git 仓库 创建 git 仓库：`git init`。

查看当前仓库文件变化情况：`git status`。

> 如果文件是红色的，说明新的修改还未被添加，只有被添加的修改才能被提交，被保存好。

添加修改：`git add xx`（xx 为想添加的文件名称）。

> 可使用 `git add .` 来添加当前仓库所有修改。

本次还没有提交的更改：`git diff`（比较工作区与暂存区的区别）。

回滚，撤销提交操作：`git reset`。

向 git 提交自己身份（name）：`git config --global user.name "xxx"`。

向 git 提交自己身份（email）：`git config --global user.email "xxx@xx.com"`。

向 git 提交内容：`git commit -m “xx”` （xx为对提交的内容进行描述）。

> 如果直接 `git commit` 会进入一个编辑器界面，要求你对本次的修改进行描述。
>
> 修改默认编辑器：`git config --global core.editor vim / vscode / emacs `。
>
> `git commit -a` 可以直接

让 git 不提交某些文件/忽略某些文件：创建文件 `.gitignore` 并在文件中添加文件名/文件夹名 即可。 

> 若想让 `.gitignore` 忽略某些文件，但这些文件在之前已经被追踪过了，可以用：`git rm --cached xx （xx为文件名）` 来使 git 不再追踪这些文件。



### 2. git 分支

git 添加分支：`git branch xx` （xx为分支名）。

git 切换分支：`git checkout xx` （xx为分支名）。

合并分支：`git merge xx`（xx为分支名）。

列出本地分支：`git branch`。

删除分支：`git branch -d xx` (xx为分支名，-D强制删除)。

> 若 xx 分支有内容未被保存，git 会提醒你，不让你进行操作。

### 3. 与别人共享代码 —— github 上线

首先确保你在 github 上新建了一个仓库，使你本地的文件有仓库可以存放。

添加远程仓库：`git remote add origin git@server-name:path/repo-name.git` 。

查看远程仓库信息可以用：`git remote -v`。

当远程仓库不小心添加错了，也可以删除这个远程仓库：`git remote rm orgin`

首次将本地分支提交到远程仓库：`git push -u origin xx`（`xx` 指的是 origin 仓库的分支名字）。

> 之后会让你输入用户名和密码，若你想输入一次之后就不用再输入，则只用在 `git push` 之前加上一句 `git config credential.helper store`。
>
> 在次之后再提交这个分支只用 `git push` 即可。

此后，每次本地提交后，只要有必要，就可以使用命令 `git push origin master` 推送最新修改。

> 当 `git push` 失败的时候，常见情况是远程仓库和本地不一致导致冲突，可以先 `git pull origin main --allow-unrelated-histories`，强行拉去远程仓库信息然后合并，之后再 `git push` 就不冲突了。

克隆仓库：`git clone xxx`（xxx为远程地址）。

若和别人合作之后，再次想把代码拉去下来只需要：`git pull` 即可。 
