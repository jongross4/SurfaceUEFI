#Source and inspiration from http://blogs.technet.com/b/askpfeplat/archive/2015/04/20/how-to-manage-surface-pro-3-uefi-through-powershell.aspx
#Some code borrowed from Mark Morowczynski 

function unlock-SurfaceUEFI
{
Param
    (
        [Parameter(mandatory=$true)][string]$UEFIPassword
    )

    [System.Reflection.Assembly]::Load("SurfaceUefiManager, Version=1.0.5483.22783, Culture=neutral, PublicKeyToken=20606f4b5276c705") | Out-Null

    [Microsoft.Surface.FirmwareOption]::Unlock($UEFIPassword)


}


Function Get-SurfaceUEFISetting
{
   param(
        [Parameter(mandatory=$true)]$Setting,
        [Parameter(mandatory=$true)][string]$UEFIPassword
        ) 
    # Get the collection of all configurable settings

    unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

    If($Setting -eq 'All'){
        $Settings = [Microsoft.Surface.FirmwareOption]::All() 
    } else {
        $Settings =[Microsoft.Surface.FirmwareOption]::Find($Setting) }

    $Settings | Foreach {
        [PSCustomObject]@{
             Name              = $_.Name
             Description       = $_.Description
             CurrentValue      = $_.CurrentValue
             DefaultValue      = $_.DefaultValue
             ProposedValue     = $_.ProposedValue
             AllowedValues     = $_.FriendlyRegEx
             RegularExpression = $_.RegEx
             }
        }
}

Function Set-SurfaceUEFISetting
{
  param(
        [Parameter(mandatory=$true)]$Setting,
        [Parameter(mandatory=$true)]$Value,
        [Parameter(mandatory=$true)]$UEFIPassword
        )  

       unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

       $UEFISetting = [Microsoft.Surface.FirmwareOption]::Find($Setting)   
       $UEFISetting.RegEx
       if($value -match $UEFISetting.RegEx ) {
       $UEFISetting.ProposedValue = “$Value”} else {"The $Value for $Setting is not valid"}

}

function test-SurfaceUEFISetting
{
   param(
        [Parameter(mandatory=$true)]$Setting,
        [Parameter(mandatory=$true)]$Value,
        [switch]$ProposedValue,
        [Parameter(mandatory=$true)]$UEFIPassword
        ) 
    # Get the collection of all configurable settings

    unlock-SurfaceUEFI -UEFIPassword $UEFIPassword

    $CurrentSetting =[Microsoft.Surface.FirmwareOption]::Find($Setting) 

    if($ProposedValue) {$CurrentSetting.ProposedValue -eq $Value} else {
    $CurrentSetting.CurrentValue -eq $Value}
}
