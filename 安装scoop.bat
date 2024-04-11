powershell set-executionpolicy remotesigned -scope currentuser

cd /D %~dp0
powershell .\install.ps1 %*

pause