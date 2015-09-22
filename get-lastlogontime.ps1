Function Get-LastLogonTime 
{
    $user = Read-Host "Enter username of AD user to check"
    $output = @()
    $DCs = Get-QADComputer -searchroot 'corp.natpal.com/Domain Controllers'
    foreach($DC in $DCs)
    {
      Connect-QADService $DC.Name
      $result = Get-QADUser -Identity NATPAL\$user | Select LastLogon
      $customObj = [PSCustomObject] @{DC=$DC;LastLogon = $result}
      $output += $customObj
    }
    $output | Sort LastLogon | FT -AutoSize
}

Get-LastLogonTime