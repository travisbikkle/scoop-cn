<!-- omit in toc -->

此外仓库中的 aria2c.exe，大家只可意会。

## Scoop 在中国使用的问题

Scoop 是一个很优秀的软件包管理工具，官方的安装说明也简单易懂，但是在中国访问却可能在每个环节都会遇到无法下载的问题。依次会遇到的是：

1. 首先从 GitHub Raw 下载 [Scoop 安装脚本](https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1)，此时下载会失败。
2. 如果第一步成功后，会下载 [Scoop 仓库存档](https://github.com/ScoopInstaller/Scoop/archive/master.zip) 和 [Main 应用仓库存档](https://github.com/ScoopInstaller/Main/archive/master.zip)，此时下载又会失败。
3. 如果第二步成功后，会先下载 7-Zip 和 Git 来做后面的事，因为 [7-Zip 的官网](https://www.7-zip.org/) 也是会偶尔无法访问，Git 下载地址在 [GitHub Releases](https://github.com/git-for-windows/git/releases)，此时下载又会失败。
4. 如果第三步成功后，会从官方 Main 应用仓库检出代码，地址在 [GitHub 仓库](https://github.com/ScoopInstaller/Main)，此时下载又会失败。
5. 如果第四步成功后，更新 Scoop 时会从官方 Scoop 仓库检出代码，地址在 [GitHub 仓库](https://github.com/ScoopInstaller/Scoop/)，此时下载又会失败。
6. 后续添加、检出 extras 等应用库都会失败。

如果你使用 Scoop 没有遇到这些问题，恭喜你，后面的内容不用看了。

## 本应用库介绍

本应用库为了解决上述问题，把各个环节的下载地址替换成了国内可加速访问的地址。本应用库使用的是 [GitHub Proxy](https://mirror.ghproxy.com/) 和 [GitHub Actions](https://github.com/features/actions) 。

特性有：

1. 本应用库包含 Scoop 的安装脚本，用于国内用户初次下载安装 Scoop。
2. 本应用库同时包含了 Scoop 官方的十个应用库：main、extras、versions、nirsoft、sysinternals、php、nerd-fonts、nonportable、java、games（可使用命令 `scoop bucket known` 查看），用一个库包含了各家的库，用户不用在多个地方搜索应用。
3. 本应用库把应用的下载地址替换成了国内可加速访问的地址，真正做到能更快更方便地下载和安装应用。
4. 本应用库每天自动更新一次

## 前提条件

[PowerShell](https://learn.microsoft.com/zh-cn/powershell/) 版本在 5.1 或以上，如果没有 PowerShell 大于 5.1 版本，可以下载安装 [PowerShell Core](https://github.com/PowerShell/PowerShell)。运行以下命令查看：

```powershell
$PSVersionTable.PSVersion.Major # should be >= 5.1
```

需要事先安装git。

其次，允许本地运行 PowerShell 脚本，以管理员打开 PowerShell，运行以下命令，回答 Y：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 安装 Scoop 和 easy-win

```bash
git clone git@gitee.com:easy-win/scoop-mirror.git
cd scoop-mirror
powershell install.ps1
```

## 只添加 easy-win 仓库

如果已经安装了 scoop，不想重新安装可以按以下步骤进行：

1. 添加本仓库，运行命令

    ```powershell
    scoop bucket add easy-win https://gitee.com/easy-win/scoop-mirror
    ```

2. 把已经安装的 app 改为使用 easy-win 来更新。每个 app 安装后在 app 的 current 路径下有个 install.json，里面的 bucket 项的值改为 easy-win，这样就把已安装的 app 换到 easy-win 了。可以运行 scoop list 来检查替换成功。如果要批量修改，可以借助 grepWin 来写个正则表达式搜索替换这个值。

3. 如果执行失败，可以直接到 buckets 目录执行
   ```
   cd D:\APPS\LOCAL\buckets
   git clone git@gitee.com:easy-win/scoop-mirror easy-win
   ```

## 安装应用

搜索应用：

```powershell
scoop search APPNAME
```

安装应用：

```powershell
scoop install easy-win/APPNAME
```

如果不想每次输入都带 easy-win/，可以把已包含的十个库删掉，例如：

```powershell
scoop bucket rm main
scoop bucket rm extras
```

智能安装应用，将会卸载，重装，并添加右键菜单（如果有）。适用于重装系统，app都找不到，希望重装的场景

```powershell
scoop si APPNAME
```

## 急救措施
scoop 依赖 git，如果不小心删了 git，可以这么安装。
```powershell
scoop install https://gitee.com/easy-win/scoop-mirror/raw/master/bucket/git.json
```

## 系统重装

```powershell
[Environment]::SetEnvironmentVariable('SCOOP', 'D:\APPS\LOCAL', 'User')
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', 'D:\APPS\ALL_USER', 'Machine')
[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + "; " + [Environment]::GetEnvironmentVariable('SCOOP', 'User') + "\shims", 'User')
# 注意下面的命令需要管理员权限。
[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + "; " + [Environment]::GetEnvironmentVariable('SCOOP_GLOBAL', 'Machine') + "\shims", 'Machine')
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

scoop reset *
```

或管理员执行执行 re-install.ps1 即可。

## 查看帮助

要了解 Scoop 的更多用法，请查看 [Scoop 官网](https://scoop.sh/)。或运行命令查看简要的帮助：

```powershell
scoop help
```

