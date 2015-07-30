@echo off
for /F "tokens=*" %%A in (app_list.txt) do echo --%%A
pause