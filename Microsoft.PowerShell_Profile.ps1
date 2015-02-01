##=============================================================================================================================
##
##  DESCRIPTION...:  This is my Powershell Profile.
##  AUTHOR........:  Mark Hubers
##
##  To setup a new profile on a new system,  Just copy the line below in a PowerShell window and run it.  It will setup the profile.
##  PS> (new-object Net.WebClient).DownloadString("https://github.com/mhubers/PSProfile/raw/master/SetupProfile.ps1") | iex 
##
## Note: git clone git@github.com:mhubers/PSProfile %USERPROFILE%\Documents\WindowsPowershell
##=============================================================================================================================

##=====================================================================================================
##  START
##=====================================================================================================
    ##--------------------------------------------------------------------------
    ##  Begin Logging
    ##--------------------------------------------------------------------------
    # Stop-Transcript
    #  $logPath = "D:\PS-Temp\"
    #  $logFileName = "PS_$(get-date -f yyyy-MM-dd).hst"
    #  $logFile = $logPath + $logFileName
    # Start-Transcript -path $logFile -append

##=====================================================================================================
##  Setup some main vars
##=====================================================================================================
    $profilePath = Split-Path $profile -Parent
    $profileFile = Split-Path $profile -Leaf

    $WebFile_Profile = "https://github.com/mhubers/PSProfile/raw/master/Microsoft.PowerShell_Profile.ps1"
    $CommonProfile = "$profilePath\Microsoft.PowerShell_Profile.ps1"
    
    $WebFile_CommonFunct = "https://github.com/mhubers/PSProfile/raw/master/Common_Functions.ps1"
    $CommonFunFile = "$profilePath\Common_Functions.ps1"

    $WebFile_LocalProfile = "https://github.com/mhubers/PSProfile/raw/master/Local_Profile.ps1"
    $LocalProfile = "$profilePath\Local_Profile.ps1"

    $32Or64BitOS="?"
    if ([System.IntPtr]::Size -eq 4) { $32Or64BitOS="32-bit" } else { $32Or64BitOS="64-bit" }


##=====================================================================================================
##  Profile core functions.
##=====================================================================================================
    function DownLoadWebFile {
	    [cmdletbinding()]
	    Param(
            [Parameter(Position=0, Mandatory=$false)] [String] $WebFile ='',
		    [Parameter(Position=1, Mandatory=$false)] [String] $TargetFile = 0
	    )

        write-host "`n-WebFileDownload:  Downloading from $WebFile."
        $client = (New-Object Net.WebClient)
        $client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
        $client.DownloadFile($WebFile, $TargetFile)

        if (Test-Path $TargetFile ) {
            write-host "   [Info]  File downloaded.`n"
        } else {
            write-host "   [ERROR]  Was not able to download the file." -BackgroundColor Black -ForegroundColor Red
        }
    }

    function Prompt {
        $id = 1
        $historyItem = Get-History -Count 1
        if($historyItem)
        {
            $id = $historyItem.Id +1
        }
		
	    ### Get current path and shorten it if it is to long.
        $cwd = (get-location).Path
	    [array]$cwdt=$()
	    $cwdi=-1
	    do {$cwdi=$cwd.indexofany(”\\”,$cwdi+1) ; [array]$cwdt+=$cwdi} until($cwdi -eq -1)

	    if ($cwdt.count -gt 8) {
		    $cwd = $cwd.substring(0,$cwdt[0]) + “\..” + $cwd.substring($cwdt[$cwdt.count-3])
	    }

	    $host.UI.RawUI.WindowTitle = $global:TitleMsg
	    Write-Host -ForegroundColor DarkGray "`n[$cwd]"
    }

    function Update-Profile {
	    [cmdletbinding()]
	    Param(
            [switch] $UpdateCommonProfile  = $false,
            [switch] $UpdateCommonFunction = $false,
            [switch] $UpdateAll            = $false
	    )

        if ($UpdateCommonProfile -or $UpdateAll) {
            DownLoadWebFile $WebFile_Profile $CommonProfile
            write-host "Downloaded '$WebFile_Profile' to '$CommonProfile'."
        }
        if ($UpdateCommonFunction -or $UpdateAll) {
            DownLoadWebFile $WebFile_CommonFunct $CommonFunFile
            write-host "Downloaded '$WebFile_CommonFunct' to '$CommonFunFile'."
        }
    }


##=====================================================================================================
##  Display message to screen.  This is part 1 of 3
##=====================================================================================================
    write-host "---- Some helpful alias functions and path updates added to your profile -------"
    write-host "--                                                                            --"


##=====================================================================================================
##  Load common functions
##=====================================================================================================
    ### Test if common_function exits and if not download one.
    if (Test-Path $CommonFunFile) {
        ### File exists so lets load it.
        . $CommonFunFile
    } else {
        ### File not exists so download it and then load it.
        DownLoadWebFile $WebFile_CommonFunct $CommonFunFile
        . $CommonFunFile
    }



##=====================================================================================================
##  Setup some common alias and path here.
##=====================================================================================================
    Set-Alias grepf findstr
	Set-Alias grep select-string
    New-Alias which get-command
   
    ### Make aliases to notepad++
    if ( Test-Path "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe" ) {
        Set-Alias ed      "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
        Set-Alias edit    "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
        Set-Alias notepad "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
    } 
    
    ### Make aliases to notepad++
    if ( Test-Path "${Env:ProgramFiles}\Notepad++\notepad++.exe"  ) {
        Set-Alias ed      "${Env:ProgramFiles}\Notepad++\notepad++.exe"
        Set-Alias edit    "${Env:ProgramFiles}\Notepad++\notepad++.exe"
        Set-Alias notepad "${Env:ProgramFiles}\Notepad++\notepad++.exe"
    } 

    ### Make aliases to cleartool on 64bit OS
    if ( Test-Path "${Env:ProgramFiles(x86)}\IBM\RationalSDLC\ClearCase\bin\cleartool.exe" ) {
        Set-Alias ct "${Env:ProgramFiles(x86)}\IBM\RationalSDLC\ClearCase\bin\cleartool.exe"
    } 

    ### Make aliases to cleartool on 32bit OS
    if ( Test-Path "${Env:ProgramFiles}\IBM\RationalSDLC\ClearCase\bin\cleartool.exe" ) {
        Set-Alias ct "${Env:ProgramFiles}\IBM\RationalSDLC\ClearCase\bin\cleartool.exe"
    } 
	 


##=====================================================================================================
##  Test if this system have TFS client and if so set path and alias to it. Setup some main values as
##   well for using TFS at command line.  
##=====================================================================================================
    $TFSServerUrl  = "http://bostfs-app1:8080/tfs"
    $TFSCollection = "aspect"
    $TFSProject    = "AspectPrj"
    $TFSFullPath   = "$TFSServerUrl/$TFSCollection"

    ### Set path to VS2012 if exists.
    if (Test-Path $env:VS110COMNTOOLS) {
        $env:path += ";$($env:VS110COMNTOOLS)\..IDE"
        Set-Alias tf "$($env:VS110COMNTOOLS)\..IDE\tf.exe" 
    }
#
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -PSConsoleFile "C:\Program Files (x86)\Microsoft Team Foundation Server 2012 Power Tools\tfshell.psc1" -noexit -command ". 'C:\Program Files (x86)\Microsoft Team Foundation Server 2012 Power Tools\TFSS
$Lync2013DLL = "C:\Program Files\Microsoft Office\Office15\LyncSDK\Assemblies\Desktop\Microsoft.Lync.Model.DLL"


##=====================================================================================================
##  Display message to screen.  This is part 2 of 3
##=====================================================================================================
    Common:ProfileDisplayMessage

##=====================================================================================================
##  Display message to screen.  This is part 3 of 3
##=====================================================================================================
        write-host "--    Grep    -> Select-String              Grepf -> findstr.exe              --"
        write-host "--    which   -> get-command                                                  --"
        write-host "--                                                                            --"
    if (Test-Path Alias:\tf) {
        write-host "--    TFS detected, created alias tf to tf.exe                                --"
    }
    if (Test-Path Alias:\ed) {
        write-host "--    Notepad++ detected, created alias ed,edit,notepad to notepad++.exe      --"
    }
    if (Test-Path Alias:\ct) {
        write-host "--    cleartool.exe detected, created alias ct to cleartool.exe               --"
    }
        write-host "--                                                                            --"
        write-host "-- To update to latest profile,  PS> Update-Profile -UpdateAll                --"
        write-host "--------------------------------------------------------------------------------"

### Git settings
	$global:GitPromptSettings.WorkingForegroundColor    = [ConsoleColor]::Yellow
	$global:GitPromptSettings.UntrackedForegroundColor  = [ConsoleColor]::Yellow

	
##=====================================================================================================
##  Load system specific profile.
##=====================================================================================================
    ### Test if a system specific profile exist or not.
    if (Test-Path $LocalProfile) {
        ### File exists so lets load it.
        . $LocalProfile
    } else {
        ### File not exists so download it and then load it.
        DownLoadWebFile $WebFile_LocalProfile $LocalProfile
        . $LocalProfile
    }

