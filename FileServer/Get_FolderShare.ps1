Function Get-FolderShare {
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
    NAME:    Get-FolderShare.ps1
    AUTHOR:  ibrahim KARSU  
    DATE:    28.02.2024
    WWW:    www.ibrahimkarsu.com
    TWITTER: @ikarsu
    LINKEDIN: /ibrahimkarsu

    VERSION HISTORY:
    1.0 28.02.2024
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

                Add-Content $lpath "fname,fdisk,fpath,fsize"

                Foreach($share in $shares){

                $fsize=$null
                $fsize="{0:N2} GB" -f ((gci $share.path |  measure length -s).sum / 1GB)

                Add-Content $lpath "$($share.name),$(($share.path -split '\\')[0]),$($share.path),$fsize"
                } 
    }#PROCESS
    END{Write-Host "Script Completed" -fore Yellow
    #notepad.exe $lpath
    }
}#function

#Get-FolderShare
