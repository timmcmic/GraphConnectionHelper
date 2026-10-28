function test-loginHint
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$msGraphLoginHint
    )
    
    out-logfile -string "Entering test-loginHint"

    if ($msGraphLoginHint -eq "")
    {
        out-logfile -string "No login hint provided."
    }
    else
    {
        if ($msGraphLoginHint -match '^[A-Za-z0-9.!#$%&''*+/=?^_`{|}~-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
        {
            out-logfile -string "Login hint is a valid upn address."
        }
        else
        {
            out-logfile -string "Login hint is not a valid upn address."
            out-logfile -string "TEST_LOGINHINT_EXCEPTION: Login hint is not a valid upn address." -isError:$TRUE
        }
    }

    out-logfile -string "Exiting test-loginHint"
}