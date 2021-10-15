<#
    .SYNOPSIS
        Yubikey TOTP Config Prep for Azure Import.

    .DESCRIPTION
        Script to mass configure TOTP to Yubico Yubikeys & Export Compatible CSV for Azure Import.

    .NOTES
    Author : Jonathan Gonzalez
    Email : itjohnny@gmail.com

    .REQUIREMENTS
    Yubikey Manager CLI https://developers.yubico.com/yubikey-manager/

#>

#Direct path to ykamn.exe which is part of the Yubikey Manager CLI install (https://developers.yubico.com/yubikey-manager/)
$yubipath = "C:\Program Files\Yubico\Yubikey Manager\ykman.exe"

#Desired Path for Azure Inv Import CSV File.
$azinvpath = "C:\Users\" + [Environment]::UserName + "\Desktop\Yubikey_inv.csv"

$azimportcsv = @()
$azfinalcsv = @()

<#

Yubico Auto configures keys if you're purchasing 1000+ keys
My Solution : A massive USB Hub + Forloop which will detect any Yubikey plugged into the PC (ykman.exe list --serials)
#>
& $yubipath list --serials | % {
$yubiserial = $_
$base32key = ""

#Generate Base32 key - NOTE: Base32 consist of A-Z and 2-7
1..32 | % { $base32key += $(Get-Random -InputObject a,b,c,d,e,f,g,h,i,j,k,m,n,o,p,q,r,s,t,u,v,w,x,y,z,2,3,4,5,6,7)}

#Declaring Yubikey Name & Model
$yubikeymodel = ((& $yubipath -d $yubiserial info | Select-String Yubikey).ToString() -replace 'Device Type: ').ToString()
$yubiserialname = "$yubikeymodel -:$yubiserial"

#Configuring Yubikey
$yubiparameter = ("otpauth://totp/" + $yubiserialname + "?secret=$base32key").ToString()
& $yubipath -d $yubiserial oath uri -t $yubiparameter
Write-Host "$yubiserial Configured"

#& $yubipath -d $yubiserial oath uri $yubiparameter
#& $yubipath -d $yubiserial oath add $yubiserialname $base32key

#Building Compatible AZ Report
$azimportcsv = @{'upn'="$yubikeymodel";'serial number'=$yubiserial;'secret key'=$base32key;'timeinterval'='30';'manufacturer'='Yubico';'model'=$yubikeymodel}
$azfinalcsv = New-Object PSObject -Property $azimportcsv
$azfinalcsv | Select-Object 'upn','serial number','secret key','timeinterval','manufacturer','model'| Expost-csv -path $azinvpath -NoType -Append -Force
Start-Sleep -Seconds 5
}