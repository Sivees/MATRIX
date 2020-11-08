# Install-WindowsFeature -Name "ADCS-Cert-Authority", "ADCS-Online-Cert" -IncludeManagementTools
Install-AdcsCertificationAuthority `
    -CAType EnterpriseRootCA `
    -CACommonName "Laboratory CA" `
    -CADistinguishedNameSuffix "DC=laboratory,DC=int" `
    -CryptoProviderName "ECDSA_P384#Microsoft Software Key Storage Provider" `
    -KeyLength 384 `
    -HashAlgorithmName SHA384 `
    -ValidityPeriod Years `
    -ValidityPeriodUnits 10 `

# install shares for CA extensions
New-Item -ItemType Directory -Name "PKI" -Path "C:\"
New-SmbShare -Name "PKI" -Path C:\PKI -FullAccess "LABORATORY\Domain Admins" -ChangeAccess "Authenticated Users" -ReadAccess "Everyone"
$pki_acl = Get-Acl -Path C:\PKI
$pki_acl_rule = New-Object System.Security.AccessControl.FileSystemAccessRule("LABORATORY\Cert Publishers", "Modify", "Allow")
$pki_acl.SetAccessRule($pki_acl_rule)
$pki_acl | Set-Acl -Path C:\PKI
$pki_acl_rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "Read", "Allow")
$pki_acl.SetAccessRule($pki_acl_rule)
$pki_acl | Set-Acl -Path C:\PKI

# install and configure IIS for AIA
Install-WindowsFeature Web-WebServer -IncludeManagementTools
New-WebVirtualDirectory -Site "Default Web Site" -Name PKI -PhysicalPath C:\PKI
$pki_acl_rule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS APPPOOL\DefaultAppPool", "ReadAndExecute, Synchronize", "Allow")
$pki_acl.SetAccessRule($pki_acl_rule)
$pki_acl | Set-Acl -Path C:\PKI
appcmd set config /section:requestfiltering /allowdoubleescaping:true

$crllist = Get-CACrlDistributionPoint; foreach ($crl in $crllist) {Remove-CACrlDistributionPoint $crl.uri -Force};
Add-CACRLDistributionPoint -Uri C:\Windows\System32\CertSrv\CertEnroll\%2.crl -PublishToServer -Force
Add-CACRLDistributionPoint -Uri http://alp-pkis-010/pki/%2.crl -AddToCertificateCDP -Force
Add-CACRLDistributionPoint -Uri file://\\alp-pkis-010\pki\%2.crl -PublishToServer -Force
$aialist = Get-CAAuthorityInformationAccess; foreach ($aia in $aialist) {Remove-CAAuthorityInformationAccess $aia.uri -Force};
Add-CAAuthorityInformationAccess http://alp-pkis-010/pki/%2.crt -AddToCertificateAia -Force
Add-CAAuthorityInformationAccess -Uri http://alp-pkis-010/ocsp -AddToCertificateOcsp 
Certutil -setreg CA\CRLPeriodUnits 2
Certutil -setreg CA\CRLPeriod "Weeks"
Certutil -setreg CA\CRLDeltaPeriodUnits 0
Certutil -setreg CA\CRLDeltaPeriod "Days"
Certutil -setreg CA\CRLOverlapPeriodUnits 12
Certutil -setreg CA\CRLOverlapPeriod "Hours"
Certutil -setreg CA\ValidityPeriodUnits 5
Certutil -setreg CA\ValidityPeriod "Years"
certutil -setreg CA\AuditFilter 127
restart-service certsvc
Start-Sleep -Seconds 10
certutil -crl