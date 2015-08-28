##Get Groups Containing a certain String and Output it to a Text File
Get-ADGroup -Filter 'SamAccountName -like "randomstring*"' | Select -Exp Name | Out-File C:\output.txt
Get-ADGroup -Filter 'SamAccountName -like "*randomgstring"' | Select -Exp Name | Out-File C:\output.txt

##Get workstations containing a certain string and output it to a text file
Get-ADComputer -Filter 'SamAccountName -like "randomstring*"' | Select -Exp Name | Out-File C:\output.txt\
Get-ADComputer -Filter 'SamAccountName -like "*randomstring"' | Select -Exp Name | Out-File C:\output.txt\


#Run a Function against a list containing IP's to grab DNS host name info.
Get-Content C:\audit.txt | Get-ComputerNameByIP

##Copy Group Members to Another Group
$Source_Group = "Group1" 
$Destination_Group = "Group2" 
$Target = Get-ADGroupMember -Identity $Source_Group 
foreach ($Person in $Target) { 
    Add-ADGroupMember -Identity $Destination_Group -Members $Person.distinguishedname 
}

##Copy Content members to Distribution group
$Destination_Group = "Distroname" 
$Target = Get-Content C:\csvname.csv
foreach ($Person in $Target) { 
    Add-ADGroupMember -Identity $Destination_Group -Members $Person
}

##Copy Directory to a list of workstations
$computers = Get-Content "C:\comp.txt"
Foreach ($computer in $computers){
    Copy-Item "C:\directorypath" -Destination "\\$computer\C$" -Recurse
}

##Remove Direcotry to a list of workstations
$computers = Get-Content "C:\comp.txt"
$destination = "C$\directorypath"
Foreach ($computer in $computers) {
    Remove-Item "\\$computer\$destination" -Recurse
}

##Output Distribution Group members to CSV
Get-DistributionGroupMember -identity "testdl" | Export-Csv C:\MyFile.Csv\

##Obtain specific info from a CSV File and Export info to another CSV
Import-CSV .\excel.csv | select column1, coulumn2, coulumn3, coulumn4 | Export-csv exceloutput.csv

## Get Computer Host name By IPAddress
function Get-ComputerNameByIP {
    param(
        $IPAddress = $null
    )
    BEGIN {
    }
    PROCESS {
        if ($IPAddress -and $_) {
            throw 'Please use either pipeline or input parameter'
            break
        } elseif ($IPAddress) {
            ([System.Net.Dns]::GetHostbyAddress($IPAddress)).HostName
        } elseif ($_) {
            [System.Net.Dns]::GetHostbyAddress($_).HostName
        } else {
            $IPAddress = Read-Host "Please supply the IP Address"
            [System.Net.Dns]::GetHostbyAddress($IPAddress).HostName
        }
    }
    END {
    }
}


#Get Logged in user based on IP or computer name
Function Get-LoggedInUser
{
    
    $computername = Read-Host "Enter computer name or IP Address"
    $user = @(Get-WmiObject -ComputerName $computername -Namespace root\cimv2 -Class Win32_ComputerSystem)[0].UserName
    $hostname = [system.net.dns]::gethostentry($computername) | select HostName
    $hostname2 = $hostname.hostname
    
    Write-Host "Currently logged in user is" -nonewline
    Write-Host " $user" -ForegroundColor yellow
    Write-Host "Hostname is" -nonewline
    Write-Host " $hostname2" -ForegroundColor yellow
    
}

Function Runagain
{
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", ""
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", ""
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $caption = "Script completed"
    $message = "Run this script again?"
    
    $result = $Host.UI.PromptForChoice($caption, $message, $choices, 0)
    If ($result -eq 0)
    {
        Get-LoggedInUser
    }
    If ($result -eq 1)
    {
        Write-Host "Exiting script"
    }
}

Get-LoggedInUser
Runagain

<#
    .CHANGELOG
        v1  - initial script
        v1_1 - added hostname inclusion in results
#>



