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

cls
set PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
:: upgrade all applications
choco upgrade all -y

:EOF
pause