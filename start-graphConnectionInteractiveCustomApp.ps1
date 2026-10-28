function start-graphConnectionInteractiveCustomApp
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$msGraphTenantID,
        [Parameter(Mandatory = $true)]
        [string]$msGraphEnvironmentName,
        [Parameter(Mandatory = $true)]
        [string]$msGraphClientID,
        [Parameter(Mandatory = $true)]
        [array]$msGraphScopesRequired,
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]$msGraphLoginHint
    )

    out-logfile -string "Entering start-graphConnectionInteractiveCustomApp"

    try
    {
        if($msGraphLoginHint -eq "")
        {
            connect-MGGraph -TenantId $msGraphTenantID -Scopes $msGraphScopesRequired -Environment $msGraphEnvironmentName -ClientID $msGraphClientID -ErrorAction Stop
            out-logfile -string "Graph connection established successfully."
        }
        else
        {
            connect-MGGraph -TenantId $msGraphTenantID -Scopes $msGraphScopesRequired -Environment $msGraphEnvironmentName -ClientID $msGraphClientID -LoginHint $msGraphLoginHint -ErrorAction Stop
            out-logfile -string "Graph connection established successfully."
        }
    }
    catch
    {
        out-logfile -string "Unable to establish a connection to Microsoft Graph."
        out-logfile -string $_
        out-logfile -string "CONNECT_GRAPH_INTERACTIVECUSTOMAPP_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting start-graphConnectionInteractiveCustomApp"
}