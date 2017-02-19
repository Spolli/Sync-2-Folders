@echo off
set $src$ = 'D:\Alberto\Test\src'
set $dst$ = 'D:\Alberto\Test\dst'

set $Folder1Files$ = Get-ChildIte -Path $src$
set $Folder2Files$ = Get-ChildIte -Path $dst$

set $FileDiffs$ = Compare-Object -ReferenceObject $Folder1Files$ -DifferenceObject $Folder2Files$

$FileDiffs$ | foreach {
  Remove-Item -Path $_.InputObject.FullName
}

pause
