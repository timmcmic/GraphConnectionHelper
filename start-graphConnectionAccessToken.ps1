function start-graphConnectionAccessToken
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        $msGraphAccessToken
    )

    out-logfile -string "Entering start-graphConnectionAccessToken"

    try
    {
        connect-MGGraph -accessToken $msGraphAccessToken -ErrorAction Stop
        out-logfile -string "Graph connection established successfully."
    }
    catch
    {
        out-logfile -string "Unable to establish a connection to Microsoft Graph."
        out-logfile -string $_ 
        out-logfile -string "CONNECT_GRAPH_ACCESSTOKEN_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting start-graphConnectionAccessToken"
}