function start-graphConnectionAppOnlyCertificateThumbprint
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
        [string]$msGraphCertificateThumbprint
    )

    out-logfile -string "Entering start-graphConnectionAppOnlyCertificateThumbprint"

    try
    {
        connect-MGGraph -TenantId $msGraphTenantID -Environment $msGraphEnvironmentName -ClientID $msGraphClientID -CertificateThumbprint $msGraphCertificateThumbprint -ErrorAction Stop
        out-logfile -string "Graph connection established successfully."
    }
    catch
    {
        out-logfile -string "Unable to establish a connection to Microsoft Graph."
        out-logfile -string $_
        out-logfile -string "CONNECT_GRAPH_APPONLYCERTIFICATETHUMBPRINT_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting start-graphConnectionAppOnlyCertificateThumbprint"
}