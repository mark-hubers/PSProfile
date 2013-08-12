##==============================================================================
##
##  DESCRIPTION...:  This is my Powershell Profile.
##  AUTHOR........:  Mark Hubers
##  REQUIREMENTS..:  Powershell v2.0
##
##==============================================================================

$global:TitleMsg = “$(hostname) – $env:USERDNSDOMAIN\$($env:username)”


##==============================================================================
##  START <CODE>
##==============================================================================
    ##--------------------------------------------------------------------------
    ##  Begin Logging
    ##--------------------------------------------------------------------------
  # Stop-Transcript
  #  $logPath = "D:\PS-Temp\"
  #  $logFileName = "PS_$(get-date -f yyyy-MM-dd).hst"
  #  $logFile = $logPath + $logFileName
  # Start-Transcript -path $logFile -append


    ##--------------------------------------------------------------------------
    ##  Set Aliases
    ##--------------------------------------------------------------------------
    set-alias whoami  Ask-Who
    new-alias grep1 findstr
	new-alias grep select-string
    Set-Alias ed      "C:\Program Files\Notepad++\notepad++.exe"
    Set-Alias edit    "C:\Program Files\Notepad++\notepad++.exe"


    ##--------------------------------------------------------------------------
    ##  FUNCTION.......:  Prompt
    ##  PURPOSE........:  Alters the POSH prompt to output the current 
    ##                    directory, as well as the HistoryID for each command. 
    ##                    Also alters the Window title to display the computer 
    ##                    name and current working directory.
    ##--------------------------------------------------------------------------
	function Prompt
    {
        $id = 1
        $historyItem = Get-History -Count 1
        if($historyItem)
        {
            $id = $historyItem.Id +1
        }
		
		$cwd = (get-location).Path
		[array]$cwdt=$()
		$cwdi=-1
		do {$cwdi=$cwd.indexofany(”\\”,$cwdi+1) ; [array]$cwdt+=$cwdi} until($cwdi -eq -1)

		if ($cwdt.count -gt 8) {
			$cwd = $cwd.substring(0,$cwdt[0]) + “\..” + $cwd.substring($cwdt[$cwdt.count-3])
		}

		$host.UI.RawUI.WindowTitle = $global:TitleMsg
		Write-Host -ForegroundColor DarkGray "`n$(get-date -format T) [$cwd]"
    }


    ##--------------------------------------------------------------------------
    ##  FUNCTION.......:  Title
    ##  PURPOSE........:  Shortcut for setting the window title.
    ##  ARGUMENTS......:  
    ##  EXAMPLE........:  title "Powershell Rules"
    ##--------------------------------------------------------------------------
	function Title {
		param(
			[Parameter(ValueFromPipeline=$true, Position=0)] [string] $_tileMsg = ''
		)
		$global:TitleMsg = $_tileMsg
        $Host.UI.RawUI.WindowTitle = $global:TitleMsg 		
    }

  
	
    ##--------------------------------------------------------------------------
    ##  FUNCTION.......:  Ask-Who
    ##  PURPOSE........:  Returns the current username and domain.
    ##  ARGUMENTS......:  
    ##  EXAMPLE........:  Ask-Who
    ##  REQUIREMENTS...:  
    ##  NOTES..........:  
    ##--------------------------------------------------------------------------
    function Ask-Who
    {
        [System.Security.Principal.WindowsIdentity]::GetCurrent().Name		
    }

    ##--------------------------------------------------------------------------
    ##  FUNCTION.......:  more
    ##  PURPOSE........:  replace the more.exe with a powershell more.  Much faster and save lots of memory.
    ##  ARGUMENTS......:  
    ##  EXAMPLE........:  dir | more
    ##  REQUIREMENTS...:  
    ##  NOTES..........:  
    ##--------------------------------------------------------------------------
	function more {
		param(
			[Parameter(ValueFromPipeline=$true)]
			[System.Management.Automation.PSObject]
			$InputObject
		)

		begin
		{
			$type = [System.Management.Automation.CommandTypes]::Cmdlet
			$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Out-Host', $type)
			$scriptCmd = {& $wrappedCmd @PSBoundParameters -Paging }
			$steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
			$steppablePipeline.Begin($PSCmdlet)
		}

		process { $steppablePipeline.Process($_) }
		end { $steppablePipeline.End() }
		#.ForwardHelpTargetName Out-Host
		#.ForwardHelpCategory Cmdlet
	}

	
##==============================================================================

	
    ##--------------------------------------------------------------------------
    ##  FUNCTION.......:  uptime
    ##  PURPOSE........:  Return out long as system been running.
    ##  ARGUMENTS......:  
    ##  EXAMPLE........:  uptime   | uptime hostname
    ##  REQUIREMENTS...:  
    ##  NOTES..........:  
    ##--------------------------------------------------------------------------
	function uptime {
		param(
			[Parameter(ValueFromPipeline=$true)]
			[string]
			$Hostname = 'localhost'
		)
		
		$lastboottime = (Get-WmiObject -Class Win32_OperatingSystem -computername $Hostname).LastBootUpTime

		$sysuptime = (Get-Date) – [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime) 
  
		Write-Host "$Hostname has been up for: " $sysuptime.days "days" $sysuptime.hours "hours" $sysuptime.minutes "minutes" $sysuptime.seconds "seconds"
	}

# Author: 	Hal Rottenberg <hal@halr9000.com>
# Url:		http://halr9000.com/article/tag/lib-authentication.ps1
# Purpose:	These functions allow one to easily save network credentials to disk in a relatively
#			secure manner.  The resulting on-disk credential file can only [1] be decrypted
#			by the same user account which performed the encryption.  For more details, see
#			the help files for ConvertFrom-SecureString and ConvertTo-SecureString as well as
#			MSDN pages about Windows Data Protection API.
#			[1]: So far as I know today.  Next week I'm sure a script kiddie will break it.
#
# Usage:	Export-PSCredential [-Credential <PSCredential object>] [-Path <file to export>]
#			Export-PSCredential [-Credential <username>] [-Path <file to export>]
#			If Credential is not specififed, user is prompted by Get-Credential cmdlet.
#			If a username is specified, then Get-Credential will prompt for password.
#			If the Path is not specififed, it will default to "./credentials.enc.xml".
#			Output: FileInfo object referring to saved credentials
#
#			Import-PSCredential [-Path <file to import>]
#
#			If not specififed, Path is "./credentials.enc.xml".
#			Output: PSCredential object
function Export-PSCredential {
	param ( $Credential = (Get-Credential), $Path = "credentials.enc.xml" )

	# Look at the object type of the $Credential parameter to determine how to handle it
	switch ( $Credential.GetType().Name ) {
		# It is a credential, so continue
		PSCredential		{ continue }
		# It is a string, so use that as the username and prompt for the password
		String				{ $Credential = Get-Credential -credential $Credential }
		# In all other caess, throw an error and exit
		default				{ Throw "You must specify a credential object to export to disk." }
	}

	# Create temporary object to be serialized to disk
	$export = "" | Select-Object Username, EncryptedPassword

	# Give object a type name which can be identified later
	$export.PSObject.TypeNames.Insert(0,’ExportedPSCredential’)

	$export.Username = $Credential.Username

	# Encrypt SecureString password using Data Protection API
	# Only the current user account can decrypt this cipher
	$export.EncryptedPassword = $Credential.Password | ConvertFrom-SecureString

	# Export using the Export-Clixml cmdlet
	$export | Export-Clixml $Path
	Write-Host -foregroundcolor Green "Credentials saved to: $Path" -noNewLine

	# Return FileInfo object referring to saved credentials
	# Get-Item $Path
}

function Import-PSCredential {
	param ( $Path = "credentials.enc.xml" )

	# Import credential file
	$import = Import-Clixml $Path 

	# Test for valid import
	if ( !$import.UserName -or !$import.EncryptedPassword ) {
		Throw "Input is not a valid ExportedPSCredential object, exiting."
	}
	$Username = $import.Username

	# Decrypt the password and store as a SecureString object for safekeeping
	$SecurePass = $import.EncryptedPassword | ConvertTo-SecureString

	# Build the new credential object
	$Credential = New-Object System.Management.Automation.PSCredential $Username, $SecurePass
	return $Credential
}


    function cdmako
    {
        set-location D:\Snapshot\NB_Mako_bosbld9_ss\release_eng\Build_scripts\scripts\PS
        title "PSBuild using view NB_Mako_bosbld9_ss"
    }
	 
	function cdmakost
    {
        set-location E:\Snapshot\NB_Mako-st_bosbld-uip9_ss\release_eng\Build_scripts\scripts\PS
		
        title "PSBuild using view NB_Mako-st_bosbld-uip9_ss"
    }
	
	function cdmakohub
    {
        set-location E:\Snapshot\hubers_MakoST_DVL_bosbld-uip9\release_eng\Build_scripts\scripts\PS
		
        title "PSBuild using view hubers_MakoST_DVL_bosbld-uip9"
    }

	
##==============================================================================
##  END </CODE>
##==============================================================================

