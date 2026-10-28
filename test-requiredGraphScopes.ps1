Function test-requiredGraphScopes
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [array]$msGraphScopesRequired
    )

    $scopesMissing = @()

    #Initiate the test.
    
    out-logfile -string "Entering test-requiredGraphScopes"

    out-logfile -string "Obtain the graph context."

    try
    {
        $graphContext = Get-MgContext -errorAction STOP
    }
    catch
    {
        out-logfile -string "Unable to obtain the graph context."
        out-logfile -string $_
        out-logfile -string "UNABLE_GET_GRAPH_CONTEXT_EXCEPTION: Unable to obtain the graph context" -isError:$TRUE
    }

    out-logfile -string "The following graph scopes are contained in the graph context."

    foreach ($scope in $graphContext.Scopes)
    {
        out-logfile -string $scope
    }

    out-logfile -string "Testing context for required scopes."

    foreach ($requiredScope in $msGraphScopesRequired)
    {
        if ($graphContext.Scopes -notcontains $requiredScope)
        {
            $scopesMissing += $requiredScope
        }
        else
        {
            out-logfile -string "Required scope $requiredScope is present in the graph context."
        }
    }

    if ($scopesMissing.Count -gt 0)
    {
        out-logfile -string "The following required scopes are missing from the graph context:"

        foreach ($missingScope in $scopesMissing)
        {
            out-logfile -string $missingScope
        }

        out-logfile -string "REQUIRED_SCOPES_MISSING_EXCEPTION: One or more requested scopes are missing from the graph context."
    }

    out-logfile -string "Exiting test-requiredGraphScopes"
}