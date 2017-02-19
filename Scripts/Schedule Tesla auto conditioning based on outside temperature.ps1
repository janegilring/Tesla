Import-Module -Name Tesla

# Configure credential mode to ScheduledTask or AzureAutomation
$CredentialMode = 'ScheduledTask'

switch ($CredentialMode) {

  'ScheduledTask' {
  
      $TeslaCredentialPath = "$env:HOMEPATH\$($env:USERNAME)_Tesla.cred.xml"

      if (-not (Test-Path $TeslaCredentialPath)) {

        Get-Credential -Message 'Specify your MyTesla credentials' | Export-Clixml -Path $TeslaCredentialPath
  
      } else {
      
      $MyTeslaCredential = Import-Clixml -Path $TeslaCredentialPath
      
      }

  
  }
  
  'AzureAutomation' {
  
      $MyTeslaCredential = Get-AutomationPSCredential -Name cred-MyTesla
  
  }

}



# Optionally add -VehicleIndex if the account has access to more than 1 vehicle
Connect-Tesla -Credential $MyTeslaCredential

$OutsideTemp = (Get-Tesla -Command climate_state).outside_temp

Write-Output "Outside temp is: $OutsideTemp"

if($OutsideTemp -lt 1) {

    Write-Output "$(Get-Date): Starting heating and sleeping for 10 minutes"
    Set-Tesla -Command auto_conditioning_start

    Start-Sleep 600

    Write-Output "$(Get-Date): Stopping heating"
    Set-Tesla -Command auto_conditioning_stop

}