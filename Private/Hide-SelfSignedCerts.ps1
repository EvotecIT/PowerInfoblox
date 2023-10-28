function Hide-SelfSignedCerts {
    [cmdletbinding()]
    param(

    )
    
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