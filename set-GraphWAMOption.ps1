function set-GraphWAMOption
{
    Param
    (
        [Parameter(Mandatory = $true)]
        [bool]$disable
    )

    out-logfile -string "Entering set-GraphWAMOption"

    try
    {
        if ($disable)
        {
            out-logfile -string "Disabling graph WAM."
            Set-MgGraphOption -DisableLoginByWAM $true -errorAction STOP
        }
        else
        {
            out-logfile -string "Enabling graph WAM."
            Set-MgGraphOption -DisableLoginByWAM $false -errorAction STOP
        }
    }
    catch
    {
        out-logfile -string "Unable to set Graph WAM option."
        out-logfile -string $_
        out-logfile -string "SET_GRAPHWAMOPTION_EXCEPTION: Unable to set Graph WAM option" -isError:$TRUE
    }

    out-logfile -string "Exiting set-GraphWAMOption"
}