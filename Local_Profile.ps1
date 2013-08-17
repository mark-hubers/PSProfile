##==============================================================================
##
##  DESCRIPTION:  system specific profile.
##
##==============================================================================
	
    
function SystemSpecificProfileDisplayMessage {
    write-host "`nSystem specific profile now loaded into your environment.`n"
}


### Override Aspect production TFS settings with home TFS Server settings
    $TFSServer     = "http://darkstar:8080/tfs"
    $TFSCollection = "defaultcollection"
    $TFSProject    = "TestPrj"
    $TFSFullPath   = "$TFSServerUrl/$TFSCollection"

    
    # CollectionUrl = 'http://darkstar:8080/tfs/defaultcollection'

    
### Some emaples what this file can be useful for.  Here I am creating a shortcut to a snapshot.
# function cdmako
# {
#    set-location D:\Snapshot\NB_Mako_bosbld9_ss\release_eng\Build_scripts\scripts\PS
#    title "PSBuild using view NB_Mako_bosbld9_ss"
# }

