function test-CertificateProvided
{
    Param
    (
        [Parameter(Mandatory = $true)]
        $msGraphCertificate
    )

    out-logfile -string "Entering test-CertificateProvided"

    try
    {
        Test-Certificate $msGraphCertificate -allowUntrusted -errorAction STOP
        out-logfile -string "Provided certificate is an actual certificate - whether it will work is not determined."
    }
    catch
    {
        out-logfile -string "Certificate is not valid."
        out-logfile -string "CERTIFICATE_INVALID_EXCEPTION: Certificate is not valid" -isError:$TRUE
    }

    out-logfile -string "Exiting test-CertificateProvided"
}