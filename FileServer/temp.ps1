 $shares=Get-SmbShare | ?{($_.name -ne "Admin$") -and ($_.name -ne "C$") -and ($_.name -ne "IPC$")}
 Write-Host "Sharing Folder Count: $($shares.count)" -Fore Green

 $lpath="C:\tempsc\$(hostname)_folderanalyses_$(get-date -f "hhmm_ddMMyy").csv"

 Foreach($share in $shares){

 $access=$null
 $accessflt=$null

 $access=Get-Acl $share.path
 $accessflts=$access.Access | ?{($_.IdentityReference -notmatch 'Everyone|BUILTIN\\Administrators|NT AUTHORITY\\System|Builtin\\Users|NT AUTHORITY\\Authenticated Users')}
 

 If($accessflts.Count -gt 0){
 $accessflts | % {
 Add-Content $lpath "$($share.name),$(($share.path -split '\\')[0]),$($share.path),$($_.Identityreference),$(($_.FileSystemRights -split ',')[0])"
 }

 }
 
 } 


 
 
 
 