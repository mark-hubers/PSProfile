##==============================================================================
##
##  DESCRIPTION...:  This is my profile aliases.
##  AUTHOR........:  Mark Hubers
##
##==============================================================================
	
    
function Alias:ProfileDisplayMessage {
    write-host "Common Alias loaded into your environment."
}

	 ### Make aliases to notepad++
	 if ( path-test "${Env:ProgramFiles(x86)}" ) {

}
	 
    Set-Alias whoami Ask-Who
    new-alias grep1 findstr
	new-alias grep select-string
    Set-Alias ed      "C:\Program Files\Notepad++\notepad++.exe"
    Set-Alias edit    "C:\Program Files\Notepad++\notepad++.exe"


