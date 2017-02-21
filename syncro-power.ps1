$block = {
    function copyFile{
      $changeType = $Event.SourceEventArgs.ChangeType
      $fileName = $Event.SourceEventArgs.Name
      $pathDst = "C:\Progetti\Sync2Folder\dst"
      $pathSrc = $Event.SourceEventArgs.FullPath
      robocopy $pathSrc $pathDst $fileName
      $logline = "$(Get-Date), $fileName, $changeType"
          Add-content "C:\Progetti\Sync2Folder\log.txt" -value $logline
    }

    function delFile{
      $changeType = $Event.SourceEventArgs.ChangeType
      $fileName = $Event.SourceEventArgs.Name
      $pathDst = "C:\Progetti\Sync2Folder\dst"
      $pathSrc = $Event.SourceEventArgs.FullPath
      Remove-Item -Path $_.Event.SourceEventArgs.Name
      #Remove-Item $pathDst $fileName
      $logline = "$(Get-Date), $fileName, $changeType"
          Add-content "C:\Progetti\Sync2Folder\log.txt" -value $logline
    }

    #Src folder
    $watchedFolder = "C:\Progetti\Sync2Folder\src"
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $watchedFolder
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true

    ### DECIDE WHICH EVENTS SHOULD BE WATCHED
    Register-ObjectEvent -InputObject $watcher -EventName Created -SourceIdentifier File.Created -Action { copyFile }
    Register-ObjectEvent -InputObject $watcher -EventName Deleted -SourceIdentifier File.Deleted -Action { delFile }
    Register-ObjectEvent -InputObject $watcher -EventName Changed -SourceIdentifier File.Changed -Action { copyFile }
    Register-ObjectEvent -InputObject $watcher -EventName Renamed -SourceIdentifier File.Renamed -Action { copyFile }
}

$encodedBlock = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($block))

Start-Process PowerShell.exe -verb Runas -argumentlist '-WindowStyle Hidden', '-NoExit', '-EncodedCommand', $encodedBlock
