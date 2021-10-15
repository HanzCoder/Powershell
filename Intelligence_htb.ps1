﻿$months = @()
$days = @()
1..12 | ForEach-Object { $months += $_.ToString("00") }
1..31 | ForEach-Object { $days += $_.ToString("00") }

foreach ($month in $months) {
    foreach ($day in $days) {
    $filename = "2020-$month-$day.pdf"
    $url = "http://0.0.0.0/$filename"
    $HTTP_Request = [System.Net.WebRequest]::Create($url)
    $HTTP_Response = [int]$HTTP_Request.GetResponse().StatusCode | Out-Null
    if($HTTP_Response -eq 200){(iwr -Uri "$url" ,$filename)}
    else{"File Doesn't Exist"}
    #clean up the http request by closing it.
    If ($HTTP_Response -eq $null) { } 
    Else { $HTTP_Response.Close() }
    }
}