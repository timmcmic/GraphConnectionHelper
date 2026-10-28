function start-graphConnectionAppOnlyCertificate    
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
        $msGraphCertificate
    )

    out-logfile -string "Entering start-graphConnectionAppOnlyCertificate"

    try
    {
        connect-MGGraph -TenantId $msGraphTenantID -Environment $msGraphEnvironmentName -ClientID $msGraphClientID -Certificate $msGraphCertificate -ErrorAction Stop
        out-logfile -string "Graph connection established successfully."
    }
    catch
    {
        out-logfile -string "Unable to establish a connection to Microsoft Graph."
        out-logfile -string $_
        out-logfile -string "CONNECT_GRAPH_APPONLYCERTIFICATE_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting start-graphConnectionAppOnlyCertificate"
}