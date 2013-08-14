##==============================================================================
##
##  DESCRIPTION...:  This is my profile aliases.
##  AUTHOR........:  Mark Hubers
##
##==============================================================================
	
    
function Alias:ProfileDisplayMessage {
    Common:Write-MixColorsHost "---  ~C=Green:ORG~Some helpful aliases~ORG~ ----------------------------------------------------"
    Common:Write-MixColorsHost "-~C=Green:ORG~  grep  more  head    ~ORG~-"
}

    ### Make aliases to notepad++
    if ( Test-Path "${Env:ProgramFiles(x86)}" ) {
        Set-Alias ed      "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
        Set-Alias edit    "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
    } else {
        Set-Alias ed      "C:\Program Files\Notepad++\notepad++.exe"
        Set-Alias edit    "C:\Program Files\Notepad++\notepad++.exe"
    }
	 
    Set-Alias whoami Ask-Who
    new-alias grep1 findstr
	new-alias grep select-string
    


