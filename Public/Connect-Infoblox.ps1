function Connect-Infoblox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ParameterSetName = 'UserName')]
        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [string] $Server,

        [Parameter(Mandatory, ParameterSetName = 'UserName')][string] $Username,
        [alias('SecurePassword')][Parameter(Mandatory, ParameterSetName = 'UserName')][string] $EncryptedPassword,

        [Parameter(Mandatory, ParameterSetName = 'Credential')][pscredential] $Credential,

        [Parameter(ParameterSetName = 'UserName')]
        [Parameter(ParameterSetName = 'Credential')]
        [string] $ApiVersion = '1.0',
        [Parameter(ParameterSetName = 'UserName')]
        [Parameter(ParameterSetName = 'Credential')]
        [switch] $EnableTLS12,
        [Parameter(ParameterSetName = 'UserName')]
        [Parameter(ParameterSetName = 'Credential')]
        [switch] $AllowSelfSignedCerts
    )

    if ($AllowSelfSignedCerts) {
        Hide-SelfSignedCerts
    }
    if ($EnableTLS12) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }

    if ($Username -and $EncryptedPassword) {
        try {
            $Password = $SecurePassword | ConvertTo-SecureString -ErrorAction Stop
            $Credential = [pscredential]::new($Username, $Password)
        } catch {
            Write-Warning -Message "Connect-Infoblox - Unable to convert password to secure string. Error: $($_.Exception.Message)"
            $Script:InfobloxConfiguration = $null
            return
        }
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