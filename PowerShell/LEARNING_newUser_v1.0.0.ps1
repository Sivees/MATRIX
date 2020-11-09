Clear-Host
$pdc_server = (Get-ADDomain).PDCEmulator
$domain_name = (Get-ADDomain).DNSRoot
$ou_path = "OU=STANDARD,OU=USERS,OU=LABORATORY,DC=laboratory,DC=int"

$first_name = Read-Host -Prompt "Imię"
$last_name = Read-Host -Prompt "Nazwisko"
$login = Read-Host -Prompt "Login"
$user_password = Read-Host -AsSecureString -Prompt "Hasło"
$expiration_date = Read-Host -Prompt "Data ważności (yyyy-mm-dd)"
try {
    $account_expiration = ([datetime]::ParseExact($expiration_date, "yyyy-MM-dd", $null)).ToString()
}
catch [FormatException] {
    Write-Host "Wrong DateTime format, it should be (yyyy-MM-dd)" -ForegroundColor Red
    exit
}
catch {
    Write-Output $_
    exit
}
$user_description = Read-Host -Prompt "Opis konta"
$user_name = "$first_name $last_name"

$user_upn = "$login@$domain_name"

New-ADUser -DisplayName $user_name `
    -GivenName $first_name `
    -Name $user_name `
    -Path $ou_path `
    -SamAccountName $login `
    -Server $pdc_server `
    -Surname $last_name `
    -Type "user" `
    -UserPrincipalName $user_upn
Set-ADAccountPassword -Identity $login `
    -NewPassword $user_password `
    -Server $pdc_server
Enable-ADAccount -Identity $login `
    -Server $pdc_server
Set-ADAccountExpiration -DateTime $account_expiration `
    -Identity $login `
    -Server $pdc_server
Set-ADUser -ChangePasswordAtLogon $true `
    -Identity $login `
    -Server $pdc_server `
    -SmartcardLogonRequired $false `
    -Description $user_description `
    -EmailAddress $user_upn `
    -Country "PL"
