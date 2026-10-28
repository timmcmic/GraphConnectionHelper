Function convert-ClientSecret
{
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$msGraphClientSecret,
        [Parameter(Mandatory = $true)]
        [string]$msGraphClientID
    )

    #Initiate the conversion.
    
    out-logfile -string "Entering convert-ClientSecret"

    try{
        $securePassword = ConvertTo-SecureString -String $msGraphClientSecret -AsPlainText -Force -errorAction STOP
    }
    catch
    {
        out-logfile -string "Error converting client secret to secure string."
        out-logfile -string $_
        out-logfile -string "CONVERT_CLIENT_SECRET_SECURESTRING_EXCEPTION" -isError:$TRUE
    }

    try
    {
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -argumentList $msGraphClientID,$securePassword -errorAction Stop
    }
    catch
    {
        out-logfile -string "Error creating PSCredential object."
        out-logfile -string $_
        out-logfile -string "CONVERT_CLIENT_SECRET_PSCREDENTIAL_EXCEPTION" -isError:$TRUE
    }
    
    out-logfile -string "Exiting convert-ClientSecret"

    return $credential
}