#region TAG

### NAME:     Get-AuditFolder.ps1
### AUTHOR:   ibrahim KARSU  
### DATE:     20.10.2024
### WWW:      www.cybervisir.com
### GITHUB:   gricoder
### TWITTER:  @ikarsu
### LINKEDIN: /ibrahimkarsu
### MEDIUM:   cybervisir.medium.com

#endregion TAG


$sfolder=""
$dfolder=""

$rcopy="C:\Windows\System32\robocopy.exe"
$rlpath="C:\Scripts\CopyFolders\robocopy_$(Get-Date -f "hhmm_ddMMyy").txt"

#region Initial Job

&$rcopy $sfolder $dfolder /B /E /COPY:DAT /R:3 /W:5 /MT:64 /UNILOG+:$rlpath /TEE

# /R:3 hata aldığında 3 kez dene
# /W:5 sn bekle her denemede
# /COPY:DAT Data, Attribute, Time
# /E: tüm alt dizinleri, boş olanlar dahil kopyala
# /B: erişim izni olmayan dosyaları da kopyala
# /MT:64 adet paralel işlem çalıştır
# /TEE konsola yazdır

#endregion Initial Job

#region Update Job

&$rcopy $sfolder $dfolder /B /E /COPY:DAT /R:3 /W:5 /MT:64 /XO /UNILOG+:$rlpath /TEE

# /R:3 hata aldığında 3 kez dene
# /W:5 sn bekle her denemede
# /COPY:DAT Data, Attribute, Time
# /E: tüm alt dizinleri, boş olanlar dahil kopyala
# /B: erişim izni olmayan dosyaları da kopyala
# /MT:64 adet paralel işlem çalıştır
# /TEE konsola yazdır
# /XO yeni dosyaları kopyalar

#endregion Update Job