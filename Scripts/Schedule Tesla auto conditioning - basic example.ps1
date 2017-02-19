Import-Module -Name Tesla

Connect-Tesla

Write-Output "$(Get-Date): Starting heating and sleeping for 10 minutes"
Set-Tesla -Command auto_conditioning_start

Start-Sleep 600

Write-Output "$(Get-Date): Stopping heating"
Set-Tesla -Command auto_conditioning_stop