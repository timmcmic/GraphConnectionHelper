function test-CertificateThumbprint
{
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$msGraphCertificateThumbprint
    )

    out-logfile -string "Entering test-CertificateThumbprint"

    out-logfile -string "Testing to ensure that certificate thumbprint is propertly formatted string."

    $cleanTP = $msGraphCertificateThumbprint -replace '\s+', '' -replace '[\u200E\u200F]', ''

    if ($cleanTP -match '^(?:[0-9A-Fa-f]{40}|[0-9A-Fa-f]{64})$')
    {
        out-logfile -string "Certificate thumbprint is properly formatted."
    }
    else
    {
        out-logfile -string "Certificate thumbprint is not properly formatted."
        out-logfile -string "CERTIFICATE_THUMBPRINT_FORMAT_EXCEPTION: Certificate thumbprint is not properly formatted" -isError:$TRUE
    }   

    out-logfile -string "Testing to ensure that certificate is in LocalMachine\My or CurrentUser\My"

    if (Test-Path "Cert:\LocalMachine\My\$msGraphCertificateThumbprint")
    {
        out-logfile -string "Certificate found in LocalMachine\My"
    }
    elseif (Test-Path "Cert:\CurrentUser\My\$msGraphCertificateThumbprint")
    {
        out-logfile -string "Certificate found in CurrentUser\My"
    }
    else
    {
        out-logfile -string "Certificate not found in LocalMachine\My or CurrentUser\My"
        out-logfile -string "CERTIFICATE_NOT_FOUND_BY_THUMBPRINT_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting test-CertificateThumbprint"
}