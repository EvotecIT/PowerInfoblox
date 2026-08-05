function Connect-Infoblox {
    <#
    .SYNOPSIS
    Configures a connection to an Infoblox WAPI endpoint.

    .DESCRIPTION
    Stores the server, authentication, API version, web session, and request timeout used by PowerInfoblox commands.

    .PARAMETER Server
    The Infoblox server name or IP address.

    .PARAMETER Username
    The user name used with an encrypted password.

    .PARAMETER EncryptedPassword
    A string created from a secure string for the specified user name.

    .PARAMETER Credential
    The credential used to authenticate to Infoblox.

    .PARAMETER ApiVersion
    The WAPI version used to build the base URI.

    .PARAMETER EnableTLS12
    Enables TLS 1.2 for the current PowerShell process.

    .PARAMETER AllowSelfSignedCerts
    Allows self-signed server certificates.

    .PARAMETER SkipInitialConnection
    Skips the initial schema request that verifies the connection.

    .PARAMETER TimeoutSec
    The request timeout in seconds. The default is 600 seconds.

    .PARAMETER ReturnObject
    Returns the stored connection configuration.

    .EXAMPLE
    Connect-Infoblox -Server 'grid.example.com' -Credential $Credential

    .EXAMPLE
    Connect-Infoblox -Server 'grid.example.com' -Credential $Credential -TimeoutSec 3600
    #>
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
        [string] $ApiVersion = '2.11',
        [Parameter(ParameterSetName = 'UserName')]
        [Parameter(ParameterSetName = 'Credential')]
        [switch] $EnableTLS12,
        [Parameter(ParameterSetName = 'UserName')]
        [Parameter(ParameterSetName = 'Credential')]
        [switch] $AllowSelfSignedCerts,
        [Parameter(ParameterSetName = 'UserName')]
        [Parameter(ParameterSetName = 'Credential')]
        [switch] $SkipInitialConnection,
        [ValidateRange(1, 2147483647)]
        [int] $TimeoutSec = 600,
        [switch] $ReturnObject
    )

    if ($EnableTLS12) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }

    # lets clear sessions if any exists
    Disconnect-Infoblox

    if ($Username -and $EncryptedPassword) {
        try {
            $Password = $EncryptedPassword | ConvertTo-SecureString -ErrorAction Stop
            $Credential = [pscredential]::new($Username, $Password)
        } catch {
            if ($ErrorActionPreference -eq 'Stop') {
                throw
            }
            Write-Warning -Message "Connect-Infoblox - Unable to convert password to secure string. Error: $($_.Exception.Message)"
            return
        }
    }

    $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = $Credential
    $PSDefaultParameterValues['Invoke-InfobloxQuery:Server'] = $Server
    $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = "https://$Server/wapi/v$apiVersion"
    $PSDefaultParameterValues['Invoke-InfobloxQuery:WebSession'] = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $PSDefaultParameterValues['Invoke-InfobloxQuery:TimeoutSec'] = $TimeoutSec

    # The infoblox configuration is not really used anywhere. It's just a placeholder
    # It's basecause we use $PSDefaultParameterValues to pass the parameters to Invoke-InfobloxQuery
    # But this placeholder is used to check if we're connected or not in other functions
    $Script:InfobloxConfiguration = [ordered] @{
        ApiVersion = $ApiVersion
        Server     = $Server
        BaseUri    = "https://$Server/wapi/v$apiVersion"
        TimeoutSec = $TimeoutSec
    }

    if ($AllowSelfSignedCerts) {
        Hide-SelfSignedCerts
    }

    # we do inital query to make sure we're connected
    if (-not $SkipInitialConnection) {
        $Schema = Get-InfobloxSchema -WarningAction SilentlyContinue -WarningVariable SchemaWarning
        if (-not $Schema) {
            if ($SchemaWarning) {
                if ($ErrorActionPreference -eq 'Stop') {
                    throw $SchemaWarning
                } else {
                    Write-Warning -Message "Connect-Infoblox - Unable to retrieve schema. Connection failed. Error: $($SchemaWarning)"
                }
            } else {
                Write-Warning -Message "Connect-Infoblox - Unable to retrieve schema. Connection failed."
            }
            Disconnect-Infoblox
            return
        }
    }

    if ($ReturnObject) {
        $Script:InfobloxConfiguration
    }
}
