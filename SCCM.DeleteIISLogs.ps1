# Declare Variables
$maxDaystoKeep = -7
$LogPath = get-childitem "PathA, PathB" -recurse -force -include *.* |Where LastWriteTime -lt ((get-date).AddDays($maxDaystoKeep))  
    
ForEach ($item in $LogPath)
    {Get-item $item | Remove-Item}
