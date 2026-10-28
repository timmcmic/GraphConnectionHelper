function start-graphConnectionAppOnlyClientSecret
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$msGraphTenantID,
        [Parameter(Mandatory = $true)]
        [string]$msGraphEnvironmentName,
        [Parameter(Mandatory = $true)]
        $msGraphClientSecret
    )

    out-logfile -string "Entering start-graphConnectionAppOnlyClientSecret"

    try
    {
        connect-MGGraph -TenantId $msGraphTenantID -Environment $msGraphEnvironmentName -ClientSecretCredential $msGraphClientSecret -ErrorAction Stop
        out-logfile -string "Graph connection established successfully."
    }
    catch
    {
        out-logfile -string "Unable to establish a connection to Microsoft Graph."
        out-logfile -string $_
        out-logfile -string "CONNECT_GRAPH_APPONLYCLIENTSECRET_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting start-graphConnectionAppOnlyClientSecret"
}