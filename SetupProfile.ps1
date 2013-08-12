###
### https://github.com/mhubers/PSProfile/raw/master/SetupProfile.ps1
### (new-object Net.WebClient).DownloadString("https://github.com/mhubers/PSProfile/raw/master/SetupProfile.ps1") | iex 
###

    write-host "---------------------------------------------"
    write-host "----      Welcome to profile setup       ----"
    write-host "---------------------------------------------`n"

    write-host "-Test execution policy..."
    $exePolicy = (Get-ExecutionPolicy)
    if ($exePolicy -eq "Restricted"){
        Write-Warning "Your execution policy is $executionPolicy, this means you will not be able to use any script files."
        Write-Warning "To fix this change your execution policy to something like RemoteSigned or Bypass."
        Write-Warning "`n  Example: PS> Set-ExecutionPolicy RemoteSigned"
        Write-Warning "`nOr`n  Example: PS> Set-ExecutionPolicy Bypass`n"
    }



### Test if existing profile or path exists.  If so we ask user if we want to overwrite the profile.
if (Test-Path $profile ) {
}   


# https://github.com/mhubers/PSProfile/raw/master/SetupProfile.ps1

Split-Path -
New-Item -ItemType directory -Path C:\Scripts\newDir