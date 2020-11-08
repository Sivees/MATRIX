$pdc_server = (Get-ADDomain).PDCEmulator

$firstName = Read-Host -Prompt 'Imię'
$lastName = Read-Host -Prompt 'Nazwisko'
$login = Read-Host -Prompt 'Login'


New-ADUser -DisplayName:"Kajser Soze" -GivenName $firstName -Name:"OR-9 Kajser Soze" -Path:"OU=USERS,OU=LABORATORY,DC=laboratory,DC=int" -SamAccountName $login -Server$pdc_server -Surname $lastName -Type:"user" -UserPrincipalName:"ksoze@laboratory.int"
# Set-ADAccountPassword -Identity:"CN=OR-9 Kajser Soze,OU=USERS,OU=LABORATORY,DC=laboratory,DC=int" -NewPassword:"System.Security.SecureString" -Reset:$true -Server$pdc_server
Enable-ADAccount -Identity:"CN=OR-9 Kajser Soze,OU=USERS,OU=LABORATORY,DC=laboratory,DC=int" -Server$pdc_server
Set-ADAccountExpiration -DateTime:"10/11/2030 00:00:00" -Identity:"CN=OR-9 Kajser Soze,OU=USERS,OU=LABORATORY,DC=laboratory,DC=int" -Server$pdc_server
Set-ADAccountControl -AccountNotDelegated:$false -AllowReversiblePasswordEncryption:$false -CannotChangePassword:$false -DoesNotRequirePreAuth:$false -Identity:"CN=OR-9 Kajser Soze,OU=USERS,OU=LABORATORY,DC=laboratory,DC=int" -PasswordNeverExpires:$false -Server$pdc_server -UseDESKeyOnly:$false
Set-ADUser -ChangePasswordAtLogon:$false -Identity:"CN=OR-9 Kajser Soze,OU=USERS,OU=LABORATORY,DC=laboratory,DC=int" -Server$pdc_server -SmartcardLogonRequired:$false