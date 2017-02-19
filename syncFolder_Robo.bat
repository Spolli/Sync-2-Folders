@echo off
rem set src = "D:\User\Test\src"
rem set dst = "D:\User\Test\dst"

robocopy "D:\User\Test\src" "D:\User\Test\dst" /PURGE /MIR /R:1000000 /W:30
pause
