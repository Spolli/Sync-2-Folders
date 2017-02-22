@echo off
set folder="C:\Progetti\Sync2Folder\src"

forfiles /p %folder% /s /d -1 /C "cmd /c del /q @path"
pause
