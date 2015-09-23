Function Get-LastLogonTime 
{
    $user = Read-Host "Enter username of AD user to check"
    $output = @()
    $DCs = Get-QADComputer -searchroot 'domain.com/Domain Controllers'
    foreach($DC in $DCs)
    {
      Connect-QADService $DC.Name
      $result = Get-QADUser -Identity DOMAIN\$user | Select LastLogon
      $customObj = [PSCustomObject] @{DC=$DC;LastLogon = $result}
      $output += $customObj
    }
    $output | Sort LastLogon | FT -AutoSize
}

Get-LastLogonTime
