#region TAG #########################

### NAME:     Get-AuditFolder.ps1
### AUTHOR:   ibrahim KARSU  
### DATE:     20.10.2024
### WWW:      www.cybervisir.com
### GITHUB:   gricoder
### TWITTER:  @ikarsu
### LINKEDIN: /ibrahimkarsu
### MEDIUM:   cybervisir.medium.com

#endregion TAG ######################


$rootPath = "\\contoso.com\sharedfolders"
$lpath="$env:TEMP\$(Get-Date -f "hhmm_ddMMyyyy").log"

Add-Content -Path $lpath "Script Started: $(Get-Date)" -Encoding Unicode
Add-Content -Path $lpath "Sharing Path Enumerating"

$acsdirs = @()

$Error.Clear()
#$dirs=gci -Path $rootPath -Directory -Recurse -Depth 3 -ea 0
$dirs=gci -Directory -Path $rootPath -Recurse -Depth 3 -ea 0 | ?{ $_.Name -match '^\d+-' } 

#region Check Problem Path Access
If($Error){
Add-Content -Path $lpath "Hata oluştu: Root Path Erişilemedi" 
}
Else{
Foreach ($dir in $dirs) {
    try {
        # Accessed Dirs
        gci -Path $dir.FullName -ea 1
        $acsdirs += $dir.FullName
        Add-Content -Path $lpath "$($dir.FullName)"
    } catch {
        # Not Accessed Dirs. Do nothing
    }
}

#region Check Hiyerarch
If($acsdirs.Length -eq 3){

$bb=($acsdirs[2] -split "\\")[4]
$md=($acsdirs[2] -split "\\")[5]
$yn=($acsdirs[2] -split "\\")[6]

    try {
        # Map Path
        New-PSDrive -Name Y -PSProvider FileSystem -Root "$($rootPath)\$($bb)\$($md)" -Description "MÜDÜRLÜK" -Persist -ea 1
        Add-Content -Path $lpath "Y:$($rootPath)\$($bb)\$($md) Added"
    } catch {
        Add-Content -Path $lpath "Y: Hata oluştu: $($Error[0])"
    }

        try {
        # Map Path
        New-PSDrive -Name Z -PSProvider FileSystem -Root "$($rootPath)\$($bb)\$($md)\$($yn)" -Description "YÖNETİCİLİK" -Persist -ea 1
        Add-Content -Path $lpath "Z:$($rootPath)\$($bb)\$($md)\$($yn) Added"
    } catch {
        Add-Content -Path $lpath "Z: Hata oluştu: $($Error[0])" 
    }

}
Else{
Add-Content -Path $lpath "Hata oluştu: Path Bilgileri Düzgün Alınamadı(BB,MD,YY Bilgileri düzgün değil)" 
}
#region Check Hiyerarch

}
#endregion Check Problem Path Access

Add-Content -Path $lpath "Script Ended: $(Get-Date)"