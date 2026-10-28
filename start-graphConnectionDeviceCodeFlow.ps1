function start-graphConnectionDeviceCodeFlow
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [array]$msGraphScopesRequired
    )

    out-logfile -string "Entering start-graphConnectionDeviceCodeFlow"

    try
    {
        connect-MGGraph -UseDeviceCode -Scopes $msGraphScopesRequired -ErrorAction Stop
        out-logfile -string "Graph connection established successfully."
    }
    catch
    {
        out-logfile -string "Unable to establish a connection to Microsoft Graph."
        out-logfile -string $_
        out-logfile -string "CONNECT_GRAPH_DEVICECODEFLOW_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting start-graphConnectionDeviceCodeFlow"
}