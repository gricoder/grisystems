Function Get-FolderPerm {
<#
.SYNOPSIS
    The Get-FolderPerm function allows you to get information from an folder shares.

.DESCRIPTION
    The Get-FolderPerm function allows you to get information from an folder shares.

.PARAMETER Level
    Specifies the level value: low, medium, high
    Default is medium

.EXAMPLE
    Get-FolderPerm

    This will show all the shares in the server which working on

.NOTES
    NAME:    Get-FolderPerm.ps1
    AUTHOR:  ibrahim KARSU  
    DATE:    27.06.2024
    WWW:    www.ibrahimkarsu.com
    TWITTER: @ikarsu
    LINKEDIN: /ibrahimkarsu

    VERSION HISTORY:
    1.0 27.06.2024
        Initial Version
#>

    [CmdletBinding()]
    PARAM(
        [Parameter(
            ValueFromPipelineByPropertyName=$true,
            ValueFromPipeline=$true)]
        [String[]]$sname

    )#PARAM

    PROCESS{
             $shares=Get-SmbShare | ?{($_.name -eq $sname)} | gci -Depth 0 -Directory
             Write-Host "Folder Count: $($shares.count)" -Fore Green

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

                Add-Content $lpath "fserver,fname,fpath,fidentity,fpermisson,flastwrite"

                Foreach($share in $shares){

                    $access=$null
                    $accessflt=$null

                    $access=Get-Acl $share.fullname
                    $accessflts=$access.Access | ?{($_.IdentityReference -notmatch 'Everyone|BUILTIN\\Administrators|NT AUTHORITY\\System|BUILTIN\\Users|CREATOR OWNER|NT AUTHORITY\\Authenticated Users')}
                    

                        If($accessflts.Count -gt 0){
                        
                            $accessflts | % {
                            Add-Content $lpath "$(hostname),$($share.name),$($share.fullname),$($_.Identityreference),$(($_.FileSystemRights -split ',')[0]),$($share.lastwritetime)"
                            }

                        }
                        Else{
                            Add-Content $lpath "$(hostname),$($share.name),$($share.fullname),RegularPerm,RegularPerm,$($share.lastwritetime)"
                        }
             }
       }#PROCESS
    END{Write-Host "Script Completed" -fore Yellow
    #notepad.exe $lpath
    }
}#function

#Get-FolderPerm
