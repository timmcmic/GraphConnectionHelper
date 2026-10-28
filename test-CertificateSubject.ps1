function test-CertificateSubject
{
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$msGraphCertificateSubject
    )

    out-logfile -string "Entering test-CertificateSubject"

    out-logfile -string "Testing to ensure that certificate subject is propertly x500 distinguished name (DN) formatted string."

    try
    {
        $null = [System.Security.Cryptography.X509Certificates.X500DistinguishedName]::new($msGraphCertificateSubject)
    }
    catch
    {
        out-logfile -string "Certificate subject is not properly x500 distinguished name (DN) formatted."
        out-logfile -string "CERTIFICATE_SUBJECT_FORMAT_EXCEPTION: Certificate subject is not properly x500 distinguished name (DN) formatted" -isError:$TRUE
    }

    out-logfile -string "Testing to ensure that certificate is in LocalMachine\My or CurrentUser\My"

    if (Get-ChildItem "Cert:\LocalMachine\My\*" | where-object {$_.subject -eq $msGraphCertificateSubject})
    {
        out-logfile -string "Certificate found in LocalMachine\My"
    }
    elseif (Get-ChildItem "Cert:\CurrentUser\My\*" | where-object {$_.subject -eq $msGraphCertificateSubject})
    {
        out-logfile -string "Certificate found in CurrentUser\My"
    }
    else
    {
        out-logfile -string "Certificate not found in LocalMachine\My or CurrentUser\My"
        out-logfile -string "CERTIFICATE_NOT_FOUND_BY_SUBJECT_EXCEPTION" -isError:$TRUE
    }

    out-logfile -string "Exiting test-CertificateSubject"
}