function test-GUIDFormat
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$GUID
    )

    $guidRegex = "^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$"
    
    out-logfile -string "Entering test-GUIDFormat"

    out-logfile -string "Testing the provided GUID format."

    if ($GUID -match $guidRegex)
    {
        out-logfile -string ("The provided GUID is in the correct format: "+$GUID)
    }
    else
    {
        out-logfile -string ("The provided GUID is not in the correct format: "+$GUID)
        out-logfile -string "GUID_FORMAT_NOT_VALID_EXCEPTION" -iserror:$TRUE
    }

    out-logfile -string "Exiting test-GUIDFormat"
}