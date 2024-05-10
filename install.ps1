param(
    $github_proxy="mirror.ghproxy.com", 
    $bucket_name="scoop-cn",
    $install_scoop_to='D:\APPS\LOCAL',
    $install_global_to='D:\APPS\ALL_USER\'
)

## 设置scoop安装变量：scoop安装的位置，以及scoop安装软件的位置
$env:SCOOP=$install_scoop_to
$env:SCOOP_GLOBAL=$install_global_to
$env:TEMP_BUCKET_DIR="$env:SCOOP\buckets"

# [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
# [environment]::setEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL,'Machine')

# 开启调试
# Set-PSDebug -Trace 1

# 安装 Scoop
(Invoke-RestMethod https://$github_proxy/https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1).Replace('https://github.com', "https://$github_proxy/https://github.com") > .\install_scoop_official.ps1
.\install_scoop_official.ps1 -RunAsAdmin -ScoopDir $env:SCOOP -ScoopGlobalDir $env:SCOOP_GLOBAL -NoProxy

# 将 Scoop 的仓库源替换为代理的
scoop config scoop_repo https://$github_proxy/https://github.com/ScoopInstaller/Scoop

# 目前没有安装 Git，所以先下载几个必需的软件的 JSON，组成一个临时的应用仓库
New-Item -ItemType "directory" -Path "$env:TEMP_BUCKET_DIR\$bucket_name\bucket"
New-Item -ItemType "directory" -Path "$env:TEMP_BUCKET_DIR\$bucket_name\scripts\7-zip"
New-Item -ItemType "directory" -Path "$env:TEMP_BUCKET_DIR\$bucket_name\scripts\git"

Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/bucket/7zip.json -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\bucket\7zip.json"
Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/scripts/7-zip/install-context.reg -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\scripts\7-zip\install-context.reg"
Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/scripts/7-zip/uninstall-context.reg -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\scripts\7-zip\uninstall-context.reg"

Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/bucket/git.json -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\bucket\git.json"
Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/scripts/git/install-context.reg -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\scripts\git\install-context.reg"
Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/scripts/git/uninstall-context.reg -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\scripts\git\uninstall-context.reg"
Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/scripts/git/install-file-associations.reg -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\scripts\git\install-file-associations.reg"
Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/scripts/git/uninstall-file-associations.reg -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\scripts\git\uninstall-file-associations.reg"

# Invoke-RestMethod -Uri https://$github_proxy/https://raw.githubusercontent.com/travisbikkle/$bucket_name/master/bucket/aria2.json -OutFile "$env:TEMP_BUCKET_DIR\$bucket_name\bucket\aria2.json"

# 安装时注意顺序是 7-Zip, Git, Aria2
scoop install $bucket_name/7zip
scoop install $bucket_name/git
# scoop install $bucket_name/aria2

# $bucket_name 库还不是 Git 仓库，删掉后，重新添加 Git 仓库
if (Test-Path -Path "$env:SCOOP\buckets\$bucket_name") {
    scoop bucket rm $bucket_name
}
Write-Host "Adding $bucket_name bucket..."
scoop bucket add $bucket_name https://$github_proxy/https://github.com/travisbikkle/scoop-cn
# 删除 Scoop 的 main 仓库
if (Test-Path -Path "$env:SCOOP\buckets\main") {
    scoop bucket rm main
}

# Set-Location "$env:TEMP_BUCKET_DIR\$bucket_name"
# git config pull.rebase true

Write-Host "scoop and $bucket_name was installed successfully!"

## 必须安装 7z git sudo aria2
scoop uninstall 7zip git aria2
scoop bucket rm main
scoop install 7zip
scoop install git
scoop install aria2

## 必要的 git 配置
git config --global core.eol lf
git config --global core.autocrlf input
git config --global core.quotepath false

