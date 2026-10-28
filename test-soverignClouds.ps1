function test-SoverignClouds
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$msGraphEnvironmentName,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$msGraphClientID
    )
    
    out-logfile -string "Entering test-SoverignClouds"

    $nonSoverignClouds = @("Global","USGovDOD","USGov","China")

    if ($nonSoverignClouds -contains $msGraphEnvironmentName)
    {
        out-logfile -string ("The provided environment is a non-sovereign cloud: "+$msGraphEnvironmentName)
    }
    else
    {
        out-logfile -string ("The provided environment is a sovereign cloud: "+$msGraphEnvironmentName)

        if ($msGraphClientID -eq "")
        {
            out-logfile -string "Connections to sovereign clouds require a client ID."
            out-logfile -string "CLIENTID_REQUIRED_FOR_SOVERIGN_CLOUDS_EXCEPTION: Connections to sovereign clouds require a client ID." -isError:$TRUE
        }
    }

    out-logfile -string "Exiting test-SoverignClouds"
}