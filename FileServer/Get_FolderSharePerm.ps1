Function Get-FolderSharePerm {
<#
.SYNOPSIS
    The Get-FolderShare function allows you to get information from an folder shares.

.DESCRIPTION
    The Get-FolderShare function allows you to get information from an folder shares.

.PARAMETER Level
    Specifies the level value: low, medium, high
    Default is medium

.EXAMPLE
    Get-FolderShare

    This will show all the shares in the server which working on

.NOTES
    NAME:    Get-FolderSharePerm.ps1
    AUTHOR:  ibrahim KARSU  
    DATE:    12.03.2024
    WWW:    www.ibrahimkarsu.com
    TWITTER: @ikarsu
    LINKEDIN: /ibrahimkarsu

    VERSION HISTORY:
    1.0 12.03.2024
        Initial Version
#>

    [CmdletBinding()]
    PARAM(
        [Parameter(
            ValueFromPipelineByPropertyName=$true,
            ValueFromPipeline=$true)]
        [Alias("Low","Medium","High")]
        [String[]]$level

    )#PARAM

    PROCESS{
             $shares=Get-SmbShare | ?{($_.name -ne "Admin$") -and ($_.name -ne "C$") -and ($_.name -ne "IPC$")}
             Write-Host "Sharing Folder Count: $($shares.count)" -Fore Green

             $Error.Clear()
             $res=mkdir "C:\Tempsc" -ea 0
             
                If(Test-Path "C:\Tempsc"){
                    $lpath="C:\tempsc\$(hostname)_folderanalyses_$(get-date -f "hhmm_ddMMyy").csv"
                    Write-Host "Log File Created" -Fore Magenta
                    Write-Host $lpath -Fore Green
                          }
                Else{
                    $lpath="$($env:temp)\$(hostname)_folderanalyses_$(get-date -f "hhmm_ddMMyy").csv"
                    Write-Host "Log File Created" -Fore Magenta
                    Write-Host $lpath -Fore Magenta
                    }

                Add-Content $lpath "fserver,fname,fdisk,fpath,fidentity,fpermisson"

                Foreach($share in $shares){

                    $access=$null
                    $accessflt=$null

                    $access=Get-Acl $share.path
                    $accessflts=$access.Access | ?{($_.IdentityReference -notmatch 'Everyone|BUILTIN\\Administrators|NT AUTHORITY\\System|Builtin\\Users|NT AUTHORITY\\Authenticated Users')}
                    

                        If($accessflts.Count -gt 0){
                        
                            $accessflts | % {
                            Add-Content $lpath "$(hostname),$($share.name),$(($share.path -split '\\')[0]),$($share.path),$($_.Identityreference),$(($_.FileSystemRights -split ',')[0])"
                            }

                        }
                        Else{
                            Add-Content $lpath "$(hostname),$($share.name),$(($share.path -split '\\')[0]),$($share.path),RegularPerm,RegularPerm"
                        }
             }
       }#PROCESS
    END{Write-Host "Script Completed" -fore Yellow
    #notepad.exe $lpath
    }
}#function

#Get-FolderSharePerm
