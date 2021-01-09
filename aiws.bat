@echo off

SET FILE_URL=https://github.com/wsldl-pg/CentWSL/releases/download/7.0.1907.3/CentOS7.zip
SET FILE_NAME=baota.zip
SET CENTOS_EXE=CentOS7.exe
SET WSL_FILE=baota
SET DOCKERBOTA=https://github.com/dooioomoo/docker-bota.git


call :Resume
goto %current%
goto :eof

setlocal
:one
echo ���ڿ�ʼ׼����װϵͳ����
echo .
echo ��Ҫ���ڻ���Centos��docker��ǰ�˿����ͺ�̨��������
echo .
echo ���а���WSL2\DOCKER\VSCODE\GIT\COMPOSER\BOTA...��
echo .
 
SET /P AREYOUSURE=�Ƿ�ʼ��װ (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
echo.
echo.
echo.
echo.
echo ���ڰ�װ choco ...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco feature enable -n=allowGlobalConfirmation
echo.
echo.
echo.
echo.
echo ���ڰ�װ PHP 7.4 ...

powershell choco install --yes php --version=7.4.14
echo.
echo.
echo.
echo.
echo ���ڰ�װ git ...

powershell choco install --yes git
echo.
echo.
echo.
echo.
echo ���ڰ�װ composer ...

powershell choco install --yes composer
echo.
echo.
echo.
echo.
echo ���ڰ�װ Nodejs ...

powershell choco install --yes nodejs --version=14.15.4
echo.
echo.
echo.
echo.
echo ���ڰ�װ VSCODE ...

powershell choco install --yes vscode
echo.
echo.
echo.
echo ��ʼ����WINDOWS������� 
echo ===============================
echo.       
echo ������������� ...
powershell dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
echo.        
echo ����Hyper-V ...
powershell dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart
echo.    
echo ����WSL ...
powershell dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
echo.
echo.
echo ��ʼ����WINDOWS������� 
echo ===============================
echo.
echo ��ʼ��������ƽ̨ ...
powershell Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
echo.
echo.
echo ��ʼ����WSL ...
powershell Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

::Add script to Run key
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v %~n0 /d %~dpnx0 /f
echo two >%~dp0current.txt
echo -- Section one --
pause
shutdown -r -t 0

goto :eof


:two
::Remove script from Run key
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v %~n0 /f
del %~dp0current.txt
echo.
echo.
echo ����WSL2 ...
start /wait powershell curl https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -o wsl_update_x64.msi
powershell msiexec /i wsl_update_x64.msi /qn
echo.
echo.
echo ����wslĬ�ϰ汾Ϊ2
powershell wsl --set-default-version 2
echo.
if not exist %FILE_NAME% (
echo ���� CENTOS FOR WSL 7.0 ...
echo.
start /wait powershell curl %FILE_URL% -o %FILE_NAME%
echo.
)
if not exist %WSL_FILE%.exe (
echo ��ѹ�� ...
echo.
powershell Expand-Archive -Force %FILE_NAME% "./" && powershell Rename-Item %CENTOS_EXE% %WSL_FILE%.exe
)
echo.
echo ��ʼ��װcentos��WSL�� ...
echo.
powershell .\%WSL_FILE%.exe < nul
powershell wsl -s %WSL_FILE%
echo.
echo.
echo ��ʼ����docker�����ļ����� ...
echo.
powershell .\%WSL_FILE%.exe run \"[ -d /%WSL_FILE% ] || mkdir /%WSL_FILE% && cd /%WSL_FILE% && yum install git -y && git clone %DOCKERBOTA%  ./ && cp .env-example .env && mv build.bat build.sh \"
echo.
echo.
echo.
echo ����docker�н�wsl������%WSL_FILE%�����趨Ϊ��״̬��
echo ���� wsl -d %WSL_FILE%,������/%WSL_FILE%Ŀ¼������ sh build.sh
echo ��ɱ����İ�װ
:END

goto :eof

:resume
if exist %~dp0current.txt (
    set /p current=<%~dp0current.txt
) else (
    set current=one
)
endlocal
