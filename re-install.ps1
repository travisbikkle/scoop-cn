[Environment]::SetEnvironmentVariable('SCOOP', 'D:\APPS\LOCAL', 'User')
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', 'D:\APPS\ALL_USER', 'Machine')
[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + "; " + [Environment]::GetEnvironmentVariable('SCOOP', 'User') + "\shims", 'User')
# 注意下面的命令需要管理员权限。
[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + "; " + [Environment]::GetEnvironmentVariable('SCOOP_GLOBAL', 'Machine') + "\shims", 'Machine')
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

scoop reset *

## TODO 将已安装的应用有右键菜单的加入右键菜单