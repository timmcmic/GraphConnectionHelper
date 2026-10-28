function start-GraphConnectionInteractive
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$msGraphTenantID,
        [Parameter(Mandatory = $true)]
        [string]$msGraphEnvironmentName,
        [Parameter(Mandatory = $true)]
        [array]$msGraphScopesRequired,
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]$msGraphLoginHint
    )

    out-logfile -string "Entering start-GraphConnectionInteractive"

    try
    {
        if($msGraphLoginHint -eq "")
        {
            connect-MGGraph -TenantId $msGraphTenantID -Scopes $msGraphScopesRequired -Environment $msGraphEnvironmentName -ErrorAction Stop
            out-logfile -string "Graph connection established successfully."
        }
        else
        {
            connect-MGGraph -TenantId $msGraphTenantID -Scopes $msGraphScopesRequired -Environment $msGraphEnvironmentName -LoginHint $msGraphLoginHint -ErrorAction Stop
            out-logfile -string "Graph connection established successfully."
        }
    }
    catch
    {
        out-logfile -string "Unable to establish a connection to Microsoft Graph."
        out-logfile -string $_
        out-logfile -string "CONNECT_GRAPH_INTERACTIVE_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting start-GraphConnectionInteractive"
}