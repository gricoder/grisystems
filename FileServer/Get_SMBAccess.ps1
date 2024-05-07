Function Get-SMBAccess {
<#
.SYNOPSIS
    The Get-SMBAccess function allows you to get information from an folder shares.

.DESCRIPTION
    The Get-SMBAccess function allows you to get information from an folder shares.

.PARAMETER Level
    Specifies the level value: low, medium, high
    Default is medium

.EXAMPLE
    Get-SMBAccess

    This will show all the shares in the server which working on

.NOTES
    NAME:    Get-SMBAccess.ps1
    AUTHOR:  ibrahim KARSU  
    DATE:    07.05.2024
    WWW:    www.ibrahimkarsu.com
    TWITTER: @ikarsu
    LINKEDIN: /ibrahimkarsu

    VERSION HISTORY:
    1.0 07.05.2024
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
                    $lpath="C:\tempsc\$(hostname)_shareanalyses_$(get-date -f "hhmm_ddMMyy").csv"
                    Write-Host "Log File Created" -Fore Magenta
                    Write-Host $lpath -Fore Green
                          }
                Else{
                    $lpath="$($env:temp)\$(hostname)_shareanalyses_$(get-date -f "hhmm_ddMMyy").csv"
                    Write-Host "Log File Created" -Fore Magenta
                    Write-Host $lpath -Fore Magenta
                    }

                Add-Content $lpath "fserver,fname,fdisk,fpath,fidentity,fpermisson"

                Foreach($share in $shares){

                    $access=$null
                    $accessflt=$null

                    $access=Get-SmbShareAccess $share.name            
                    
                    $access | % {
                            Add-Content $lpath "$(hostname),$($share.name),$(($share.path -split '\\')[0]),$($share.path),$($_.Accountname),$($_.AccessRight)"
                            }
             }
       }#PROCESS
    END{Write-Host "Script Completed" -fore Yellow
    #notepad.exe $lpath
    }
}#function

#Get-SMBAccessPerm
