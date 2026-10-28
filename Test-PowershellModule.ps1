Function Test-PowershellModule
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$powershellModuleName,
        [Parameter(Mandatory = $true)]
        [boolean]$getInstalledVersion
    )

    #Initiate the test.
    
    out-logfile -string "Entering Test-PowerShellModule"

    #Write function parameter information and variables to a log file.

    Out-LogFile -string ("PowerShellModuleName = "+$powershellModuleName)
    out-logfile -string $getInstalledVersion

    if ($getInstalledVersion -eq $TRUE)
    {
        try
        {
            out-logfile -string ("Obtain commands for installed module: "+$powershellModuleName)
            $commands = get-command -module $powershellModuleName -errorAction Stop
            out-logfile -string ("Commands version obtained: "+$commands[0].version)
            $returnVersion = $commands[0].version
        }
        catch
        {
            out-logfile -string "Unable to obtain the installed command versions."
            out-logfile -string $_
            out-logfile -string "TEST_POWER_SHELL_COMMAND_EXCEPTION" -isError:$TRUE
        }
    }
    else
    {
        try
        {
            out-logfile -string ("Obtain commands for gallery module: "+$powershellModuleName)
            $commands = find-module -name $powershellModuleName -errorAction Stop
            out-logfile -string ("Commands version obtained: "+$commands.version)
            $returnVersion = $commands.version
        }
        catch
        {
            out-logfile -string "Unable to obtain the gallery command versions."
            out-logfile -string $_
            out-logfile -string "TEST_POWER_SHELL_GALLERY_EXCEPTION" -isError:$TRUE
        }
    }

    out-logfile -string "Exiting Test-PowerShellModule"

    return $returnVersion
}