function Split([string]$string, [char]$delim)
{
	try 
	{
		$split = $string.split("$delim")
		$string = $split[1].trim()
	}
	catch
	{
		$_ | Out-File $errFile -Append
	}
	Return $string
}

$col = @()
$id = @()
$auth = @()
$key = @()
$cip = @()
$username = $env:Username
$drive = (Get-Location).Drive.Name
$error = (get-date -format yyyy.MM.dd)+"_"+$username+"_Errors"
$errFile = "$drive:\Tools\Scripts\WiFiScript\$error.txt"

$command = netsh wlan show profiles | Select-String "All User"

Out-File $errFile -Append -InputObject "Collecting SSID"
foreach($ssid in $command)
{
	
	$ssid = $ssid.line
	$ssid = Split "$ssid" ":"
	$id += $ssid	
}

$length = $id.length
Out-File $errFile -Append -InputObject "`n`r"

for($i=0; $i -lt $length; $i++)
{
	$currID = $id[$i]
	Out-File $errFile -Append -InputObject "Collecting data for $currID"
	
	$data = netsh wlan show profiles $id[$i] key=clear
	$a = $data | Select-String "Authentication"
	$c = $data | Select-String "Cipher"
	$k = $data | Select-String "Key Content"

	$a = $a.line
	$a = Split "$a" ":"
	$auth += $a

	$c = $c.line
	$c = Split "$c" ":"
	$cip += $c

	$k = $k.line
	if($k -ne $null)
		{$k = Split "$k" ":"}
	else
		{$k = "~No Password~"}
	$key += $k

	Out-File $errFile -Append -InputObject "`n`r"
}

for($j=0; $j -lt $length; $j++)
{
	$obj = New-Object System.Object
	$obj | Add-Member -type NoteProperty -name SSID -value $id[$j]
	$obj | Add-Member -type NoteProperty -name Authentication -value $auth[$j]
	$obj | Add-Member -type NoteProperty -name Cipher -value $cip[$j]
	$obj | Add-Member -type NoteProperty -name Password -value $key[$j]
	$col += $obj
}
$title = (get-date -format yyyy.MM.dd)+"_$username"
$col | Sort-Object Authentication -descending | ft -auto | Out-File "$drive:\Tools\Scripts\WiFiScript\$title.txt"
