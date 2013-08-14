##==============================================================================
##
##  DESCRIPTION...:  This is my profile aliases.
##  AUTHOR........:  Mark Hubers
##
##==============================================================================
 
    Set-Alias grepf findstr
	Set-Alias grep select-string
   
    ### Make aliases to notepad++
    if ( Test-Path "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe" ) {
        Set-Alias ed      "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
        Set-Alias edit    "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
        Set-Alias notepad "${Env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
    } 
    
    ### Make aliases to notepad++
    if ( Test-Path "C:\Program Files\Notepad++\notepad++.exe" ) {
        Set-Alias ed      "C:\Program Files\Notepad++\notepad++.exe"
        Set-Alias edit    "C:\Program Files\Notepad++\notepad++.exe"
        Set-Alias notepad "C:\Program Files\Notepad++\notepad++.exe"
    } 

    ### Make aliases to cleartool
    if ( Test-Path "C:\Program Files (x86)\IBM\RationalSDLC\ClearCase\bin\cleartool.exe" ) {
        Set-Alias ct "C:\Program Files (x86)\IBM\RationalSDLC\ClearCase\bin\cleartool.exe"
    } 

    ### Make aliases to cleartool
    if ( Test-Path "C:\Program Files\IBM\RationalSDLC\ClearCase\bin\cleartool.exe" ) {
        Set-Alias ct "C:\Program Files\IBM\RationalSDLC\ClearCase\bin\cleartool.exe"
    } 
	 


    
function Alias:ProfileDisplayMessage {
    ### this get display in start of a new PowerShell session.  Part 2 of 2.
        write-host "--    Grep    -> Select-String              Grepf -> findstr.exe              --"
        write-host "--                                                                            --"

    if (Test-Path Alias:\ed) {
        write-host "--    Notepad++ detected, created alias ed,edit,notepad to notepad++.exe      --"
    }
    if (Test-Path Alias:\ct) {
        write-host "--    cleartool.exe detected, created alias ct to cleartool.exe               --"
    }
        write-host "--                                                                            --"
        write-host "-- To update to latest profile,  PS> Update-Profile -UpdateAll                --"
        write-host "--------------------------------------------------------------------------------"
}


    


