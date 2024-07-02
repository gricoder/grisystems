Function Get-AuditFolder {
<#
.SYNOPSIS
    The Get-AuditFolder function allows you to get information from an folder shares.

.DESCRIPTION
    The Get-AuditFolder function allows you to get information from an folder shares.

.PARAMETER Level
    Specifies the level value: low, medium, high
    Default is medium

.EXAMPLE
    Get-AuditFolder

    This will show all the shares in the server which working on

.NOTES
    NAME:    Get-AuditFolder.ps1
    AUTHOR:  ibrahim KARSU  
    DATE:    02.07.2024
    WWW:    www.ibrahimkarsu.com
    TWITTER: @ikarsu
    LINKEDIN: /ibrahimkarsu

    VERSION HISTORY:
    1.0 02.07.2024
        Initial Version
#>

    [CmdletBinding()]
    PARAM(
        [Parameter(
            ValueFromPipelineByPropertyName=$true,
            ValueFromPipeline=$true)]
        [String[]]$eventid="4663"

    )#PARAM

    PROCESS{
             $filterHashTable = @{
             LogName = 'Security'
             ID = $eventid
             StartTime = (Get-Date).AddDays(-1)  # Son 1 gün
             EndTime = Get-Date
             }

             Write-Host "Script Started: $(Get-Date)" -Fore Yellow
             $events=Get-WinEvent -FilterHashtable $filterhashtable
             $afolders=@()
             Write-Host "All $($eventid) Events Enumrated" -Fore Green
             Write-Host "Events Count: $($events.count)" -Fore Green

             $Error.Clear()
             $res=mkdir "C:\Tempsc" -ea 0
             
                If(Test-Path "C:\Tempsc"){
                    $lpath="C:\tempsc\$(hostname)_auditfolder_$(get-date -f "hhmm_ddMMyy").csv"
                    Write-Host "Log File Created" -Fore Magenta
                    Write-Host $lpath -Fore Green
                          }
                Else{
                    $lpath="$($env:temp)\$(hostname)_auditfolder_$(get-date -f "hhmm_ddMMyy").csv"
                    Write-Host "Log File Created" -Fore Magenta
                    Write-Host $lpath -Fore Magenta
                    }

                
                Foreach($event in $events){

                If($event.properties.value -contains 'File'){
                
                $afolder=$null
                $afolder=("$($event.Properties.value)" -split " " -match ':\\')[0]
                
                If($afolder -match ':\\'){
                
                $afolders+=$afolder
                #Write-Host $afolder -fore Magenta
                
                } 
                
                }
                
                }
                
                $afolders=$afolders | sort -Unique

                $safolders=@()
                
                $afolders | % {
                
                If($_ -match "\."){
                $safolders+=$_.Substring(0, $_.LastIndexOf("\"))
                }
                Else{
                $safolders+=$_
                }
                
                }

                $safolders=$safolders | sort -Unique

                Write-Host "Uniq Folders Count: $($safolders.count)" -Fore Green
                Add-Content -Path $lpath $safolders
                Write-Host "Result Exported: $($lpath)" -Fore Green
       }#PROCESS
    END{Write-Host "Script Completed: $(Get-Date)" -fore Yellow
    }
}#function

#Get-AuditFolder
