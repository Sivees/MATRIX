function New-LabUser {
    <#
    .DESCRIPTION

    Adds new user .
    Takes any strings for the file name or extension.

    .PARAMETER Name
    Specifies the file name.

    .PARAMETER Extension
    Specifies the extension. "Txt" is the default.

    .INPUTS

    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS

    System.String. Add-Extension returns a string with the extension
    or file name.

    .EXAMPLE

    PS> extension -name "File"
    File.txt

    .EXAMPLE

    PS> extension -name "File" -extension "doc"
    File.doc

    .EXAMPLE

    PS> extension "File" "doc"
    File.doc

    .LINK

    http://www.fabrikam.com/extension.html

    .LINK

    Set-Item
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Server=(Get-ADDomain).PDCEmulator,
        [Parameter(Mandatory=$true)]
        [string]
        $Path,
        [Parameter(Mandatory)]
        [string]
        $FirstName,
        [Parameter(Mandatory)]
        [string]
        $LastName,
        [Parameter(Mandatory)]
        [string]
        $SamAccountName,
        [Parameter(Mandatory)]
        [securestring]
        $Password,
        [Parameter(Mandatory)]
        [string]
        $AccountExpiration,
        [Parameter(Mandatory)]
        [string]
        $Description,
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