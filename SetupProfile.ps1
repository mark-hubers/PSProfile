###
###
### (new-object Net.WebClient).DownloadString("https://github.com/mhubers/PSProfile/raw/master/SetupProfile.ps1") | iex 
###

    $WebPath_ThisScript = "https://github.com/mhubers/PSProfile/raw/master/SetupProfile.ps1"
    $WebPath_Profile    = "https://github.com/mhubers/PSProfile/raw/master/Microsoft.PowerShell_Profile.ps1"

    write-host -ForegroundColor Green "---------------------------------------------"
    write-host -ForegroundColor Green "----      Welcome to profile setup       ----"
    write-host -ForegroundColor Green "---------------------------------------------"

    write-host "`n-Test execution policy..."
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

    write-host "`n-Test if user Powershell folder exists ($profilePath)..."
    if (Test-Path $profilePath) {
        write-host "   [Info]  Powershell user folder exist,"    
    } else {
        write-host "   [Warn]  PowerShell user folder not exists.  Creating it now.."
        New-Item -ItemType directory -Path $profilePath -Force | out-null
    }

    write-host "`n-Test if an existing profile exist or not..."
    if (Test-Path $profile ) {
        write-host "   [Warn]  You have an existing profile."

        $caption = "Over-write existing profile"
        $message = "Want to replace it?"
        $yes = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","help"
        $no = new-Object System.Management.Automation.Host.ChoiceDescription "&No","help"
        $choices = [System.Management.Automation.Host.ChoiceDescription[]]($yas,$no)
        $answer = $host.ui.PromptForChoice($caption,$message,$choices,0)

        switch ($answer){
            0 {"Overwriting profile!"}
            1 {"Aborting due to existing profile."; exit 0}
        }
    }  else {
        write-host "   [Info]  No existing profile."
    }

    write-host "`n-Downloading Profile from $WebPath_Profile..."
    $client = (New-Object Net.WebClient)
    $client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    $client.DownloadFile($WebPath_Profile, $profile)

exit 0


