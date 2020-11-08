# Wykreowanie klucza KDS z natychmiastowym działaniem (domuślnie klucz jest aktywny po ostatniej replikacji - 10 godzin)
Add-KdsRootKey –EffectiveTime ((get-date).addhours(-10))
Get-KdsRootKey

# Dodanie nowego konta serwisowego (Group Managed Service Account - GMSA)
New-ADServiceAccount -Name LAB_MSQL_SVC -DNSHostName FQDN_SerweraPrzechowującego -PrincipalsAllowedToRetrieveManagedPassword "GrupaADmaszynUprawnionych"

# Uruchomieni funkcji zdalnej administracji AD przez PowerShell na maszynie przeznaczonej do kożystania z GMSA
Add-WindowsFeature RSAT-AD-PowerShell

# Instalacja i test GMSA na maszynie
Install-ADServiceAccount -Identity NazwaKonta
Test-ADServiceAccount NazwaKonta