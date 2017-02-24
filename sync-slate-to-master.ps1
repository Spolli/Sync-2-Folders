### DEFINISCO I FOLDER E I FILTRI
$master = '\\flornf06\adsyst\ADSyst_Test\ADSyst_User_Data\NP_Bid\vettorgr'
$slave = '\\win10-londpeifp025.corporate.ge.com\ADSyst_Test\ADSyst_User_Data\NP_Bid\vettorgr'
$filter = '*.*'  # You can enter a wildcard filter here.

# In the following line, you can change 'IncludeSubdirectories to $true if required.
$fsw = New-Object IO.FileSystemWatcher $master, $filter -Property @{IncludeSubdirectories = $true;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

$pso = new-object psobject -property @{master = $master; slave = $slave}
# Here, all three events are registerd.  You need only subscribe to events that you need:

Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -MessageData $pso -Action {
  $srcRootDir = $Event.MessageData.master
  $desRootDir = $Event.MessageData.slave
  $name = $Event.SourceEventArgs.Name
  $changeType = $Event.SourceEventArgs.ChangeType
  $timeStamp = $Event.TimeGenerated
  $fileName = Split-Path $Event.SourceEventArgs.Name -Leaf
  $relPath = Split-Path $Event.SourceEventArgs.Name -Parent
  #Write-Host "The file '$name' was $changeType at $timeStamp" -fore green
  Out-File -FilePath D:\paolo\syncrop.log -Append -InputObject "The file '$fileName' in dir '$relPath' was $changeType at $timeStamp"
  robocopy $srcRootDir\$relPath $desRootDir\$relPath $fileName /S /MT:16 /Z
  #Copy-Item $Event.SourceEventArgs.fullPath -Destination $desRootDir\$relPath
  Out-File -FilePath D:\paolo\syncro2-copy.log -Append -InputObject "Copy file '$fileName' from '$srcRootDir\$relPath' to '$desRootDir\$relPath'"
}

Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -MessageData $pso -Action {
  $srcRootDir = $Event.MessageData.master
  $desRootDir = $Event.MessageData.slave
  $name = $Event.SourceEventArgs.Name
  $changeType = $Event.SourceEventArgs.ChangeType
  $timeStamp = $Event.TimeGenerated
  $fileName = Split-Path $Event.SourceEventArgs.Name -Leaf
  $relPath = Split-Path $Event.SourceEventArgs.Name -Parent
  Write-Host "The file '$name' was $changeType at $timeStamp" -fore white
  robocopy $srcRootDir\$relPath $desRootDir\$relPath $fileName /S /MT:16 /Z
  Out-File -FilePath D:\paolo\syncrop.log -Append -InputObject "The file '$path\$name' was $changeType at $timeStamp"
}

# To stop the monitoring, run the following commands:
# Unregister-Event FileCreated
# Unregister-Event FileChanged
