@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

set src="C:\Progetti\Sync2Folder\src"
set dst="C:\Progetti\Sync2Folder\dst"
set time_file="C:\Progetti\Sync2Folder\log.txt"

:copy
  echo !date! - !time! [SYNCRO] - Start syncro Mirroring >> %time_file%t
  robocopy %src% %dst% /mir
  echo !date! - !time! [SYNCRO] - End syncro Mirroring >> %time_file%
goto loop

:loop
  ping -n 1 -w 500 127.0.0.1 > NUL
goto copy

exit
