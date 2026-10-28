function test-msGraphVersions
{
    out-logfile -string "Entering test-msGraphVersions"

    $msGraphModuleName = "Microsoft.Graph.Authentication"

    $installedVersion = Test-PowershellModule -powershellModuleName $msGraphModuleName -getInstalledVersion $TRUE
    $galleryVersion = Test-PowershellModule -powershellModuleName $msGraphModuleName -getInstalledVersion $FALSE

    if ($galleryVersion -ne $installedVersion)
    {
        out-logfile -string "The installed version of the Microsoft.Graph.Authentication module is not the same as the gallery version."
        out-logfile -string ("Installed Version: "+$installedVersion)
        out-logfile -string ("Gallery Version: "+$galleryVersion)
        out-logfile -string ("************************************")
        out-logfile -string ("Run Get-InstalledModule -name 'Microsoft.Graph.*' | update-module -force -confirm:$FALSE")
        out-logfile -string ("Exit and restart powershell to load new module versions.")
        out-logfile -string ("GRAPH_VERSIONS_NOT_UP_TO_DATE_EXCEPTION") -iserror:$TRUE  
        out-logfile -string ("************************************")
    }
    else
    {
        out-logfile -string "The installed version of the Microsoft.Graph.Authentication module is the same as the gallery version."
        out-logfile -string ("Installed Version: "+$installedVersion)
        out-logfile -string ("Gallery Version: "+$galleryVersion)
    }

    out-logfile -string "Exiting test-msGraphVersions"
}