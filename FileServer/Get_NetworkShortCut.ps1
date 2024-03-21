###################################################################
######  Get-NetworkShortCut.ps1             #######################
###### 	DO NOT ANY CHANGE ON THIS SCRIPT 	#######################
###### 	AUTHOR:  ibrahim KARSU              #######################
######  DATE:    21.03.2024                 #######################
###### 	WWW:    www.ibrahimkarsu.com        #######################
###### 	TWITTER: @ikarsu                    #######################
######  LINKEDIN: /ibrahimkarsu             #######################
###################################################################

$dir="$($env:temp)"
# Example
# $dir="\\servername\sharingname"

$opath="$($dir)\$($env:USERNAME).txt"

$lpath="$($env:temp)\$(get-date -f 'ddMMyy')_Log.txt"

Add-Content $lpath "Script Started at $(Get-Date)"

If(Test-Path $opath){Add-Content $lpath "Output File Created: $($opath)"}
Else{Add-Content $lpath "ERROR: Output File Not Created: $($opath)"}

$path="$($env:APPDATA)\Microsoft\Windows\Network Shortcuts"

#region Get Network Folder

$folders=gci $path -Directory -ea 0

If($folders.count -gt 0){

Add-Content $lpath "Network Folder Count: $($folders.count)"

Foreach ($folder in $folders) {

$path = join-path $folder.fullname 'target.lnk'
$WSHshell = New-Object -ComObject WScript.Shell
$shortcut = $WSHshell.CreateShortcut($Path)

Add-Content $opath "$($env:COMPUTERNAME),$($env:USERNAME),$($folder.name),$($shortcut.TargetPath)"

}

}

Else{Add-Content $lpath "ERROR: No Network Folder Found"}

#endregion

#region Get Network Drive

$drives=Get-PSDrive | ?{$_.DisplayRoot -match '\\'}

If($drives.count -gt 0){

Add-Content $lpath "Network Drive Count: $($drives.count)"

Foreach ($drive in $drives) {

Add-Content $opath "$($env:COMPUTERNAME),$($env:USERNAME),$($drive.name),$($drive.displayroot)"

}

}

Else{Add-Content $lpath "ERROR: No Network Folder Found"}

#endregion


