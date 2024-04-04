###################################################################
######  Get-NetworkShortCut.ps1             #######################
###### 	DO NOT ANY CHANGE ON THIS SCRIPT 	#######################
###### 	AUTHOR:  ibrahim KARSU              #######################
######  DATE:    04.04.2024                 #######################
###### 	WWW:    www.ibrahimkarsu.com        #######################
###### 	TWITTER: @ikarsu                    #######################
######  LINKEDIN: /ibrahimkarsu             #######################
###################################################################

$dir="$($env:temp)"
# Example
# $dir="\\servername\sharingname"

$opath="$($dir)\$($env:COMPUTERNAME).txt"

$lpath="$($env:temp)\GetAllNwSc_Log_$(get-date -f 'ddMMyy').txt"

Add-Content $lpath "Script Started at $(Get-Date)"
Add-Content $opath "computer,user,folder,path"

If(Test-Path $opath){Add-Content $lpath "Output File Created: $($opath)"}
Else{Add-Content $lpath "ERROR: Output File Not Created: $($opath)"}

$users=(ls C:\Users | select name).name

$users | % {

$path="C:\users\$($_)\Appdata\Roaming\Microsoft\Windows\Network Shortcuts"

#region Get Network Folder

$folders=gci $path -Directory -ea 0

If($folders.count -gt 0){

Add-Content $lpath "$($_)-Network Folder Count: $($folders.count)"

Foreach ($folder in $folders) {

$path = Join-Path $folder.fullname 'target.lnk'
$WSHshell = New-Object -ComObject WScript.Shell
$shortcut = $WSHshell.CreateShortcut($Path)

Add-Content $opath "$($env:COMPUTERNAME),$($_),$($folder.name),$($shortcut.TargetPath)"

}

}

Else{Add-Content $lpath "$($_)-ERROR: No Network Folder Found"}

#endregion
}

#region Get Network Drive

$drives=Get-ChildItem -path HKCU:\Network -recurse

If($drives.count -gt 0){

Add-Content $lpath "$($env:USERNAME)-Network Drive Count: $($drives.count)"

Foreach ($drive in $drives) {

Add-Content $opath "$($env:COMPUTERNAME),$($env:USERNAME),$(($drive | Get-ItemProperty).pschildname),$(($drive | Get-ItemProperty).remotepath)"

}

}

Else{Add-Content $lpath "$($env:USERNAME)-ERROR: No Network Folder Found"}

#endregion

Add-Content $lpath "Script Ended at $(Get-Date)"

