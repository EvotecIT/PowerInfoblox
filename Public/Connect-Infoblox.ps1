function Connect-Infoblox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Server,
        [Parameter(Mandatory)][pscredential] $Credential,
        [Parameter()][string] $ApiVersion = '1.0',
        [switch] $EnableTLS12,
        [switch] $AllowSelfSignedCerts
    )

    if ($AllowSelfSignedCerts) {
        Hide-SelfSignedCerts
    }
    if ($EnableTLS12) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }

    $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = $Credential
    $PSDefaultParameterValues['Invoke-InfobloxQuery:Server'] = $Server
    #$PSDefaultParameterValues['Invoke-InfobloxQuery:ApiVersion'] = $ApiVersion
    $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = "https://$Server/wapi/v$apiVersion"

    $Script:InfobloxConfiguration = [ordered] @{
        ApiVersion = $ApiVersion
        Credential = $Credential
        Server     = $Server
        BaseUri    = "https://$Server/wapi/v$apiVersion"
    }
}