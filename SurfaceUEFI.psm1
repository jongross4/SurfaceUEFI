#Source and inspiration from http://blogs.technet.com/b/askpfeplat/archive/2015/04/20/how-to-manage-surface-pro-3-uefi-through-powershell.aspx
#Some code borrowed from Mark Morowczynski 

#'Password','TPM','SecureBoot','PxeBoot','SideUsb','DockingPorts','FrontCamera','RearCamera','WiFi','Bluetooth','Audio','SdPort','AltBootOrder'

function Unlock-SurfaceUEFI
{
	[CmdletBinding()]
  Param
  (
    [Parameter(mandatory=$true)][string]$UEFIPassword
  )

  [System.Reflection.Assembly]::Load('SurfaceUefiManager, Version=1.0.5483.22783, Culture=neutral, PublicKeyToken=20606f4b5276c705') | Out-Null

  Write-Debug "Unlocking the UEFI BIOS with password [$UEFIPassword]"
  Write-Verbose "Unlocking the UEFI BIOS with password [$UEFIPassword]"

  [Microsoft.Surface.FirmwareOption]::Unlock($UEFIPassword)
}


Function Get-SurfaceUEFISetting
{
	[CmdletBinding()]
  param(
    [ValidateSet('All','Password','TPM','SecureBoot','PxeBoot','SideUsb','DockingPorts','FrontCamera','RearCamera','WiFi','Bluetooth','Audio','SdPort','AltBootOrder')]
    [Parameter(mandatory=$true)]$Setting,
    [Parameter(mandatory=$true)][string]$UEFIPassword
  ) 
  # Get the collection of all configurable settings

  Unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

  Write-Debug "Getting setting [$Setting] with password [$UEFIPassword]"
  Write-Verbose "Getting setting [$Setting] with password [$UEFIPassword]"


  If($Setting -eq 'All'){
    $Settings = [Microsoft.Surface.FirmwareOption]::All() 
  } else {
  $Settings =[Microsoft.Surface.FirmwareOption]::Equals($Setting) }

  $Settings
}

<#
.Synopsis
   Sets UEFI BIOS settings
.DESCRIPTION
   Sets UEFI BIOS settings
.EXAMPLE
   set-SurfaceUEFISetting -Setting "Password" -Value "" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "TPM" -Value "1" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "SecureBoot" -Value "1" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "PxeBoot" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "SideUsb" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "DockingPorts" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "FrontCamera" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "RearCamera" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "WiFi" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "Bluetooth" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "Audio" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "SdPort" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   set-SurfaceUEFISetting -Setting "AltBootOrder" -Value "4" -UEFIPassword "1234"
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   This cmdlet must be run with Administrative priveledges
.COMPONENT
   The component this cmdlet belongs to SurfaceUEFI
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
Function Set-SurfaceUEFISetting
{
	[CmdletBinding()]
  param(
    [ValidateSet('Password','TPM','SecureBoot','PxeBoot','SideUsb','DockingPorts','FrontCamera','RearCamera','WiFi','Bluetooth','Audio','SdPort','AltBootOrder')]
    [Parameter(mandatory=$true)]$Setting,
    [Parameter(mandatory=$true)]$Value,
    [Parameter(mandatory=$true)]$UEFIPassword
  )  

  Unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

  Write-Debug "Setting setting [$Setting] with password [$UEFIPassword] to value [$Value]"
  Write-Verbose "Setting setting [$Setting] with password [$UEFIPassword] to value [$Value]"

  $UEFISetting = [Microsoft.Surface.FirmwareOption]::Equals($Setting)   
  Write-Debug "RegEx is [$($UEFISetting.RegEx)]"
  Write-Verbose "RegEx is [$($UEFISetting.RegEx)]"
   
  $UEFISetting.RegEx
  if($value -match $UEFISetting.RegEx ) {
    $UEFISetting.ProposedValue = “$Value”
  } else {
    "The value [$Value] for [$Setting] is not valid"
  }

}

function Test-SurfaceUEFISetting
{
	[CmdletBinding()]
  param(
    [ValidateSet('Password','TPM','SecureBoot','PxeBoot','SideUsb','DockingPorts','FrontCamera','RearCamera','WiFi','Bluetooth','Audio','SdPort','AltBootOrder')]
    [Parameter(mandatory=$true)]$Setting,
    [Parameter(mandatory=$true)]$Value,
    [switch]$ProposedValue,
    [Parameter(mandatory=$true)]$UEFIPassword
  ) 
  # Get the collection of all configurable settings

  Write-Debug "Testing setting [$Setting] with password [$UEFIPassword] for value [$Value]"
  Write-Verbose "Testing setting [$Setting] with password [$UEFIPassword] for value [$Value]"

  Unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

  $CurrentSetting =[Microsoft.Surface.FirmwareOption]::Equals($Setting) 

  if($ProposedValue) {
    $CurrentSetting.ProposedValue -eq $Value
  } else {
    $CurrentSetting.CurrentValue -eq $Value
  }
}