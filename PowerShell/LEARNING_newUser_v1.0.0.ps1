function New-LabUser {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter()]
        [string]
        $Server=(Get-ADDomain).PDCEmulator,
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $Path,
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $FirstName,
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $LastName,
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $SamAccountName,
        # Parameter help description
        [Parameter(Mandatory)]
        [securestring]
        $Password,
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $AccountExpiration,
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $Description,
        # Parameter help description
        [string]
        $Country = "PL"
    )
    begin {
        $Domain = (Get-ADDomain).DNSRoot
    }
    process {
        try {
            $account_expiration = ([datetime]::ParseExact($AccountExpiration, "yyyy-MM-dd", $null)).ToString()
            $UserPrincipalName = "$SamAccountName@$Domain"
            $FullName = "$FirstName $LastName"
        }
        catch [FormatException] {
            Write-Host "Wrong DateTime format, it should be (yyyy-MM-dd)" -ForegroundColor Red
            exit
        }
        catch {
            Write-Output $_
            exit
        }
        try {
            New-ADUser -DisplayName $FullName `
                -GivenName $FirstName `
                -Name $FullName `
                -Path $Path `
                -SamAccountName $SamAccountName `
                -Server $Server `
                -Surname $LastName `
                -Type "user" `
                -UserPrincipalName $UserPrincipalName
            Set-ADAccountPassword -Identity $SamAccountName `
                -NewPassword $Password `
                -Server $Server
            Enable-ADAccount -Identity $SamAccountName `
                -Server $Server
            Set-ADAccountExpiration -DateTime $account_expiration `
                -Identity $SamAccountName `
                -Server $Server
            Set-ADUser -ChangePasswordAtLogon $true `
                -Identity $SamAccountName `
                -Server $Server `
                -SmartcardLogonRequired $false `
                -Description $Description `
                -EmailAddress $UserPrincipalName `
                -Country $Country
        }
        catch {
            Write-Output $_
        }
    }
    end {
        Write-Output "Thats all"
    }
}


