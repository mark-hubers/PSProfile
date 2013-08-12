##==============================================================================
##
##  DESCRIPTION...:  This is my Powershell Profile.
##  AUTHOR........:  Mark Hubers
##  REQUIREMENTS..:  Powershell v2.0
##
##==============================================================================

##==============================================================================
##  START
##==============================================================================
    ##--------------------------------------------------------------------------
    ##  Begin Logging
    ##--------------------------------------------------------------------------
    # Stop-Transcript
    #  $logPath = "D:\PS-Temp\"
    #  $logFileName = "PS_$(get-date -f yyyy-MM-dd).hst"
    #  $logFile = $logPath + $logFileName
    # Start-Transcript -path $logFile -append

##==============================================================================
##  Setup some main vars
##==============================================================================
    $profilePath = Split-Path $profile -Parent
    $profileFile = Split-Path $profile -Leaf

    $WebFile_CommonFunct = "https://github.com/mhubers/PSProfile/raw/master/Common_Functions.ps1"
    $WebFile_CommonAlias = "https://github.com/mhubers/PSProfile/raw/master/Common_Alias.ps1"


##==============================================================================
##  Profile core functions.
##==============================================================================
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


##==============================================================================
##  Load common functions
##==============================================================================
    ### Test if common_function exits and if not download one.
    $CommonFunFile = "$profilePath\Common_Functions.ps1"
    if (Test-Path $CommonFunFile) {
        ### File exists so lets load it.
        . $CommonFunFile
    } else {
        ### File not exists so download it and then lod it.
        DownLoadWebFile $WebFile_CommonFunct $CommonFunFile
        . $CommonFunFile
    }






	
##==============================================================================
##  END </CODE>
##==============================================================================

