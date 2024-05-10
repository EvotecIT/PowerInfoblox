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
        [switch] $ReturnObject
    )

    if ($EnableTLS12) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }

    # lets clear sessions if any exists
    Disconnect-Infoblox

    if ($Username -and $EncryptedPassword) {
        try {
            $Password = $SecurePassword | ConvertTo-SecureString -ErrorAction Stop
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

    # $WebSession = New-WebSession -Cookies @{
    #     security_setting = @{
    #         session_timeout = 60000
    #     }
    # } -For $BaseUri

    # The infoblox configuration is not really used anywhere. It's just a placeholder
    $Script:InfobloxConfiguration = [ordered] @{
        ApiVersion = $ApiVersion
        #Credential = $Credential
        Server     = $Server
        BaseUri    = "https://$Server/wapi/v$apiVersion"
        # Create a WebSession object to store cookies
        # Session    = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        #WebSession = $WebSession

    }

    if ($AllowSelfSignedCerts) {
        Hide-SelfSignedCerts
    }

    # we do inital query to make sure we're connected
    if (-not $SkipInitialConnection) {
        $Schema = Get-InfobloxSchema -WarningAction SilentlyContinue
        if (-not $Schema) {
            Disconnect-Infoblox
            return
        }
    }

    if ($ReturnObject) {
        $Script:InfobloxConfiguration
    }
}