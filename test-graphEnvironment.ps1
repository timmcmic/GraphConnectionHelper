function test-graphEnvironment
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$msGraphEnvironmentName
    )

    out-logfile -string "Entering test-graphEnvironment"

    out-logfile -string "Gathering all graph environments."

    try
    {
        $graphEnvironments = Get-MgEnvironment -ErrorAction Stop
        out-logfile -string "All graph environments gathered."
    }
    catch
    {
        out-logfile -string "Unable to gather all graph environments."
        out-logfile -string $_ -isError:$TRUE
    }

    out-logfile -string "Determine if provided graph environment is valid."

    if ($graphEnvironments.name -contains $msGraphEnvironmentName)
    {
        out-logfile -string ("The graph environment provided is valid: "+$msGraphEnvironmentName)
    }
    else
    {
        out-logfile -string ("The graph environment provided is not valid: "+$msGraphEnvironmentName)

        foreach ($environment in $graphEnvironments)
        {
            out-logfile -string ("Valid graph environment: "+$environment.name)
        }
        out-logfile -string "GRAPH_ENVIRONMENT_NOT_VALID_EXCEPTION" -iserror:$TRUE
    }

    out-logfile -string "Exiting test-graphEnvironment"
}