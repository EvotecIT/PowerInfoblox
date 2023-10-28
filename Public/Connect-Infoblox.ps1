function Connect-Infoblox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Server,
        [Parameter(Mandatory)][pscredential] $Credential,
        [Parameter()][string] $ApiVersion = '1.0',
        [switch] $AllowSelfSignedCerts
    )

    if ($AllowSelfSignedCerts) {
        Hide-SelfSignedCerts
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