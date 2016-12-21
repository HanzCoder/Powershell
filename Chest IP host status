GC C:\Test\IP.txt | %{
	If (Test-Connection $_ -Quiet -Count 2){
	"$_ is UP"
	}
	Else{
	"$_ is Down"
	}
} | Out-File C:\result.txt
