@echo off
rem set src = "D:\Alberto\Test\src"
rem set dst = "D:\Alberto\Test\dst"

robocopy "D:\Alberto\Test\src" "D:\Alberto\Test\dst" /PURGE /MIR /R:1000000 /W:30

pause
