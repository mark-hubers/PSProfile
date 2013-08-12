##=============================================================================================================================
##
##  DESCRIPTION: Setup profile path if needed and then download latest profile.
##  AUTHOR.....: Mark Hubers
##
##  To run it.  Just copy the line below in a PowerShell window.
##  PS> (new-object Net.WebClient).DownloadString("https://github.com/mhubers/PSProfile/raw/master/SetupProfile.ps1") | iex 
##
##=============================================================================================================================

$WebPath_ThisScript = "https://github.com/mhubers/PSProfile/raw/master/SetupProfile.ps1"
$WebPath_Profile    = "https://github.com/mhubers/PSProfile/raw/master/Microsoft.PowerShell_Profile.ps1"

write-host -ForegroundColor Green "------------------------------------------------------------"
write-host -ForegroundColor Green "----      Welcome to profile downloader and setup       ----"
write-host -ForegroundColor Green "------------------------------------------------------------"

write-host "`n-Test execution policy."
$exePolicy = (Get-ExecutionPolicy)
if ($exePolicy -match "Restricted|AllSigned") {
    Write-Warning "   Your execution policy is $exePolicy, this means you will not be able to use any script files."
    Write-Warning "   To fix this change your execution policy to something like RemoteSigned or Bypass or Unrestricted."
    Write-Warning "`n     Example: PS> Set-ExecutionPolicy RemoteSigned"
    Write-Warning "`n   Or`n     Example: PS> Set-ExecutionPolicy Unrestricted"
} else {
    write-host "   [Info]  Execution Policy set to $exePolicy.  Should be able to run local scripts."
}

$profilePath = Split-Path $profile -Parent
$profileFile = Split-Path $profile -Leaf

write-host "`n-Test if your Powershell folder exists ($profilePath)."
if (Test-Path $profilePath) {
    write-host "   [Info]  Your Powershell folder exist,"    
} else {
    write-host "   [Warn]  Your PowerShell folder does not exists.  Creating it now."
    New-Item -ItemType directory -Path $profilePath -Force | out-null
}

write-host "`n-Test if an existing profile exist or not."
if (Test-Path $profile ) {
    write-host "   [Warn]  You have an existing profile."

    $title = "Existing profile"
    $message = "Want to replace your existnig profile?"
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
        "Overwrite your existing profile."
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
        "Retains your existing profile."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

    $result = $host.ui.PromptForChoice($title, $message, $options, 0) 

    switch ($result){
        0 {"Overwriting profile!";$DoWeDownloadProfile = $true}
        1 {"Aborting due to existing profile."; $DoWeDownloadProfile = $false }
    }
}  else {
    write-host "   [Info]  No existing profile.  Grab latest profile from Git."
    $DoWeDownloadProfile = $true
}

if ($DoWeDownloadProfile) {
    write-host "`n-Downloading Profile from $WebPath_Profile."
    $client = (New-Object Net.WebClient)
    $client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    $client.DownloadFile($WebPath_Profile, $profile)

    if (Test-Path $profile ) {
        write-host "   [Info]  Profile downloaded.`n"
        write-host "Done downloading latest profile.  Please restart a new PowerShell session to pick up the new profile settings."
    } else {
        write-host "   [ERROR]  Was not able to download the profile." -BackgroundColor Black -ForegroundColor Red
    }
}

        