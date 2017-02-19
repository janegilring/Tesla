Import-Module -Name Tesla

$MyTeslaCred = Get-AutomationPSCredential -Name cred-MyTesla
$Office365SMTPCred = Get-AutomationPSCredential -Name cred-Office365SMTP


Connect-Tesla -Credential $MyTeslaCred

$OutsideTemp = (Get-Tesla -Command climate_state).outside_temp

Write-Output "Outside temp is: $OutsideTemp"

if($OutsideTemp -lt 1) {

    Send-MailMessage -From "Tesla Model X - Falcon I <user@office365domain.com>" -To user@domain.com -Subject 'Started auto conditioning' -Body "Outside temperate is $OutsideTemp , starting heating" -SmtpServer smtp.office365.com -Port 587 -Credential $Office365SMTPCred -UseSsl

    Write-Output "$(Get-Date): Starting heating and sleeping for 10 minutes"
    Set-Tesla -Command auto_conditioning_start

    Start-Sleep 600

        Write-Output "$(Get-Date): Stopping heating"
    Set-Tesla -Command auto_conditioning_stop

}