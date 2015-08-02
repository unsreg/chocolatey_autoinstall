:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights http://stackoverflow.com/questions/7044985/how-can-i-auto-elevate-my-batch-file-so-that-it-requests-from-uac-administrator
:::::::::::::::::::::::::::::::::::::::::
@echo off
CLS
::ECHO =============================
::ECHO Running Admin shell
::ECHO =============================
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )
:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)
::ECHO.
::ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
::ECHO **************************************
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B
:gotPrivileges
::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
setlocal & pushd .
REM Run shell as admin (example) - put here code as you like
::cmd /k
:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::
::===============================================================================

:: enable PowerShell scripts execution
@powershell Set-ExecutionPolicy RemoteSigned

:: install DotNET 4.0
cls
echo installing dotNetFx 4.0
%~dp0\res\dotNetFx40_Full_setup.exe /q /norestart

cls
echo check chocolatey installation
:: exec installed chocolatey application
for /f %%G in ('choco') do (
	set _dtm=%%G
)
if (%_dtm%) == () set _dtm=not_installed
:: check substring in string
@setlocal enableextensions enabledelayedexpansion
if not x%_dtm:Chocolatey=%==x%_dtm% set tmp_value=true
if (%tmp_value%) == () set tmp_value=false
endlocal&set EXIST=%tmp_value%

cls
:: install chocolatey if not exist
if %EXIST% == true (	
	echo chocolatey is already installed
) else (
	cls
	echo installing chocolateye
	@powershell -NoProfile -ExecutionPolicy unrestricted -File %~dp0\res\install_chocolatey.ps1
)

cls
set PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
:: install all applications
echo installing all applications
@powershell -NoProfile -ExecutionPolicy unrestricted -File %~dp0\res\install_chocolatey_app_list.ps1 -app_list_path %~dp0\app_list.txt

:EOF
pause