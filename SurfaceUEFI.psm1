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

  Write-Debug "Unlocking the UEFI BIOS with password [$UEFIPassword]"
  Write-Verbose "Unlocking the UEFI BIOS with password [$UEFIPassword]"

  [Microsoft.Surface.FirmwareOption]::Unlock($UEFIPassword)
}


<#
.Synopsis
   Sets UEFI BIOS settings
.DESCRIPTION
   Sets UEFI BIOS settings
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "All" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "Password" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "TPM" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "SecureBoot" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "PxeBoot" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "SideUsb" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "DockingPorts" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "FrontCamera" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "RearCamera" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "WiFi" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "Bluetooth" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "Audio" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "SdPort" -UEFIPassword "1234"
.EXAMPLE
   Get-SurfaceUEFISetting -Setting "AltBootOrder" -Value "4" -UEFIPassword "1234"
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
Function Get-SurfaceUEFISetting
{
	[CmdletBinding()]
  param(
    [ValidateSet('All','Password','TPM','SecureBoot','PxeBoot','SideUsb','DockingPorts','FrontCamera','RearCamera','WiFi','Bluetooth','Audio','SdPort','AltBootOrder')]
    [Parameter(mandatory=$true)]$Setting
    #,[Parameter(mandatory=$true)][string]$UEFIPassword
  ) 
  # Get the collection of all configurable settings

  #Unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

  Write-Debug "Getting setting [$Setting] with password [$UEFIPassword]"
  Write-Verbose "Getting setting [$Setting] with password [$UEFIPassword]"


  If($Setting -eq 'All'){
    $Settings = [Microsoft.Surface.FirmwareOption]::All() 
  } else {
  $Settings =[Microsoft.Surface.FirmwareOption]::Find($Setting) }

  $Settings
}

<#
.Synopsis
   Sets UEFI BIOS settings
.DESCRIPTION
   Sets UEFI BIOS settings
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "Password" -Value "" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "TPM" -Value "1" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "SecureBoot" -Value "1" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "PxeBoot" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "SideUsb" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "DockingPorts" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "FrontCamera" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "RearCamera" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "WiFi" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "Bluetooth" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "Audio" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "SdPort" -Value "FF" -UEFIPassword "1234"
.EXAMPLE
   Set-SurfaceUEFISetting -Setting "AltBootOrder" -Value "4" -UEFIPassword "1234"
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
    [Parameter(mandatory=$true)]$Value
    #,[Parameter(mandatory=$true)]$UEFIPassword
  )  

  #Unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

  Write-Debug "Setting setting [$Setting] with password [$UEFIPassword] to value [$Value]"
  Write-Verbose "Setting setting [$Setting] with password [$UEFIPassword] to value [$Value]"

  $UEFISetting = [Microsoft.Surface.FirmwareOption]::Find($Setting)   
  Write-Debug "RegEx is [$($UEFISetting.RegEx)]"
  Write-Verbose "RegEx is [$($UEFISetting.RegEx)]"
   
  $UEFISetting.RegEx
  if($value -match $UEFISetting.RegEx ) {
    $UEFISetting.ProposedValue = $Value
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
    [switch]$ProposedValue
    #,[Parameter(mandatory=$true)]$UEFIPassword
  ) 
  # Get the collection of all configurable settings

  Write-Debug "Testing setting [$Setting] with password [$UEFIPassword] for value [$Value]"
  Write-Verbose "Testing setting [$Setting] with password [$UEFIPassword] for value [$Value]"

  #Unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

  $CurrentSetting =[Microsoft.Surface.FirmwareOption]::Find($Setting) 

  if($ProposedValue) {
    $CurrentSetting.ProposedValue -eq $Value
  } else {
    $CurrentSetting.CurrentValue -eq $Value
  }
}
