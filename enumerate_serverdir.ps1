Get-Content "c:\computers.txt" | Select-Object @{Name='ComputerName';Expression={$_}},@{Name='FolderExist';Expression={Test-path "\\$_\c$\file path\"}}
