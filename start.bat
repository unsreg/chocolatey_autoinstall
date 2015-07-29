@echo off

:: enable PowerShell scripts execution
@powershell Set-ExecutionPolicy RemoteSigned

echo installing dotNetFx 4.0
%~dp0\dotNetFx40_Full_setup.exe /q

:: check chocolatey install
for /f %%G in ('choco') do (
	set _dtm=%%G
)
if (%_dtm%) == () set _dtm=not_installed
:: check substring in string
@setlocal enableextensions enabledelayedexpansion
if not x%_dtm:Chocolatey=%==x%_dtm% set tmp_value=true
if (%tmp_value%) == () set tmp_value=false
endlocal&set EXIST=%tmp_value%

:: install chocolatey is not exist
if %EXIST% == true (	
	echo +EXIST+	
) else (
	cls
	echo install chocolatey
	@powershell -NoProfile -ExecutionPolicy unrestricted -File %~dp0\install_chocolatey.ps1
)

:: install all applications
@powershell -NoProfile -ExecutionPolicy unrestricted -File %~dp0\win_autoinstall_chocolatey.ps1
pause
