# Determine script location and create log file to store the results
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$log      = "$ScriptDir\SCCM.DeleteStaleComputers.log"
$date     = Get-Date -Format "dd-MM-yyyy hh:mm:ss"

"---------------------  Script executed on $date (dd-MM-yyyy hh:mm:ss) ---------------------" + "`r`n" | Out-File $log -append
#try import SCCM Module ,if error catch it.
Try
{
Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)
$SiteCode = Get-PSDrive -PSProvider CMSITE
$SMSProvider=$sitecode.SiteServer
Set-Location "$($SiteCode.Name):\"
}
Catch
{
 "[ERROR]`t SCCM Module couldn't be loaded. Script will exit!" | Out-File $log -append
 Exit 1
 }
 # Read the notepad file for client records
 ForEach ($client in Get-Content $ScriptDir"\SCCM.DeleteStaleComputers.txt")
  {
   $CN=Get-CMDevice -Name $client
   $name=$CN.Name
   if ($name) 
   {
   	try {
       "$date [INFO]`t $name found in SCCM " | Out-File $log -append
	   Remove-CMDevice -name $client -force 
	   "$date [INFO]`t $name removed from SCCM " | Out-File $log -append
	    }
	catch
	  {"$date [INFO]`t $name found in SCCM but unable to delete record.Check further " | Out-File $log -append
	  }
	  }
   else
    { "$date [INFO]`t $client not found in SCCM " | Out-File $log -append}
   }
 
 Remove-Item –path $ScriptDir"\SCCM.DeleteStaleComputers.txt" –recurse
 New-Item -Path $ScriptDir -Name "SCCM.DeleteStaleComputers.txt" -ItemType "file"
