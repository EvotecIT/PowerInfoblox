function Hide-SelfSignedCerts {
    [cmdletbinding()]
    param(

    )
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        #Write-Warning -Message "Hide-SelfSignedCerts - This function is only supported in PowerShell 6 and later"
        $Script:InfobloxConfiguration['SkipCertificateValidation'] = $true
        return
    }
    try {
        Add-Type -TypeDefinition @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@

        [System.Net.ServicePointManager]::CertificatePolicy = [TrustAllCertsPolicy]::new()
    } catch {
        Write-Warning -Message "Hide-SelfSignedCerts - Error when trying to hide self-signed certificates: $($_.Exception.Message)"
    }
}