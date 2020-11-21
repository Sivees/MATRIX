# zmienne globalne
$domain_dn = (Get-ADDomain).DistinguishedName
$pdc_server = (Get-ADDomain).PDCEmulator

# utworzenie bazowej struktury jednostek organizacyjnych
New-ADOrganizationalUnit -Server $pdc_server -Name 'LABORATORY' -Path $domain_dn -ProtectedFromAccidentalDeletion $false
$base_ou = Get-ADOrganizationalUnit -Server $pdc_server -Filter {Name -eq 'LABORATORY'}
$lab_ous = @(
    'GROUPS',
    'USERS',
    'SERVERS',
    'TERMINALS'
)
foreach ($ou in $lab_ous) {
    New-ADOrganizationalUnit -Server $pdc_server -Name $ou -Path $base_ou.DistinguishedName -ProtectedFromAccidentalDeletion $false
}


New-ADGroup -Server $pdc_server -GroupCategory Security -GroupScope DomainLocal -Name 'LAB_MSQL_Servers' -Path 'OU=GROUPS,OU=LABORATORY,DC=laboratory,DC=int'
New-ADComputer -Server $pdc_server -Name 'ALP-MSQL-010' -Path 'OU=SERVERS,OU=LABORATORY,DC=laboratory,DC=int'
Add-ADGroupMember -Server $pdc_server -Identity 'LAB_MSQL_Servers' -Members 'ALP-MSQL-010$'

# Wykreowanie klucza KDS z z utworzeniem konta serwisowego dla MSSQL
# Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))
# New-ADServiceAccount -Server $pdc_server -Name 'LAB_MSQL_SVC' -DNSHostName $pdc_server -PrincipalsAllowedToRetrieveManagedPassword 'LAB_MSQL_Servers'

New-SelfSignedCertificate -Type Custom -Subject "E=administrator@laboratory.int,CN=Administrator" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.4","2.5.29.17={text}email=administrator@laboratory.int&upn=administrator@laboratory.int") `
    -KeyAlgorithm ECDSA_nistP384 `
    -HashAlgorithm sha384 `
    -SmimeCapabilities `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeyUsage DigitalSignature 

Set-ADObject -Identity "CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=laboratory,DC=int" `
    -Partition "CN=Configuration,DC=laboratory,DC=int" `
    -Replace:@{"msDS-DeletedObjectLifetime" = 60}