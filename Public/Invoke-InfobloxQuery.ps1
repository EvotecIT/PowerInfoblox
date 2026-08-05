function Invoke-InfobloxQuery {
    <#
    .SYNOPSIS
    Sends a request to an Infoblox WAPI endpoint.

    .DESCRIPTION
    Builds an Infoblox WAPI URI, sends the request, and returns the deserialized response.

    .PARAMETER BaseUri
    The WAPI base URI.

    .PARAMETER RelativeUri
    The object path or URI relative to the WAPI base URI.

    .PARAMETER Credential
    The credential used to authenticate to Infoblox.

    .PARAMETER WebSession
    The web request session used for cookie-based authentication.

    .PARAMETER QueryParameter
    Query parameters appended to the request URI.

    .PARAMETER Method
    The HTTP method. The default is GET.

    .PARAMETER Body
    The request body, serialized as JSON.

    .PARAMETER TimeoutSec
    The request timeout in seconds. The default is 600 seconds.

    .EXAMPLE
    Invoke-InfobloxQuery -BaseUri 'https://grid.example.com/wapi/v2.13.8' -RelativeUri 'network' -Credential $Credential

    .EXAMPLE
    Invoke-InfobloxQuery -BaseUri 'https://grid.example.com/wapi/v2.13.8' -RelativeUri 'network' -Credential $Credential -TimeoutSec 30
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory)][string] $BaseUri,
        [parameter(Mandatory)][string] $RelativeUri,
        [parameter()][pscredential] $Credential,
        [Parameter()][Microsoft.PowerShell.Commands.WebRequestSession] $WebSession,
        [parameter()][System.Collections.IDictionary] $QueryParameter,
        [parameter()][string] $Method = 'GET',
        [parameter()][System.Collections.IDictionary] $Body,
        [parameter()][ValidateRange(1, 2147483647)][int] $TimeoutSec = 600
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Invoke-InfobloxQuery - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }
    if (-not $Credential -and -not $WebSession) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'Invoke-InfobloxQuery - You must provide either a Credential or a WebSession with a cookie from Connect-Infoblox'
        }
        Write-Warning -Message 'Invoke-InfobloxQuery - You must provide either a Credential or a WebSession with a cookie from Connect-Infoblox'
        return
    }

    $joinUriQuerySplat = @{
        BaseUri               = $BaseUri
        RelativeOrAbsoluteUri = $RelativeUri
    }
    if ($QueryParameter) {
        $joinUriQuerySplat['QueryParameter'] = $QueryParameter
    }

    $Url = Join-UriQuery @joinUriQuerySplat

    if ($Body) {
        $JSONBody = $Body | ConvertTo-Json -Depth 10
        Write-Debug -Message "Invoke-InfobloxQuery - Body: $JSONBody"
    }
    if ($PSCmdlet.ShouldProcess($Url, "Invoke-InfobloxQuery - $Method")) {
        Write-Verbose -Message "Invoke-InfobloxQuery - Querying $Url with $Method"
        try {
            $invokeRestMethodSplat = @{
                Uri         = $Url
                Method      = $Method
                Credential  = $Credential
                ContentType = 'application/json'
                ErrorAction = 'Stop'
                Verbose     = $false
                WebSession  = $WebSession
                TimeoutSec  = $TimeoutSec
            }
            if ($Body) {
                $invokeRestMethodSplat.Body = $JSONBody
            }
            if ($Script:InfobloxConfiguration['SkipCertificateValidation'] -eq $true) {
                $invokeRestMethodSplat.SkipCertificateCheck = $true
            }
            Remove-EmptyValue -Hashtable $invokeRestMethodSplat -Recursive -Rerun 2
            Invoke-RestMethod @invokeRestMethodSplat
            # we connected to the server, so we can reset the default Credentials value
            $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = $null
        } catch {
            if ($PSVersionTable.PSVersion.Major -gt 5) {
                $OriginalError = $_.Exception.Message
                if ($_.ErrorDetails.Message) {
                    try {
                        $JSONError = ConvertFrom-Json -InputObject $_.ErrorDetails.Message -ErrorAction Stop
                    } catch {
                        if ($ErrorActionPreference -eq 'Stop') {
                            throw $OriginalError
                        }
                        Write-Warning -Message "Invoke-InfobloxQuery - Querying $Url failed. Error: $OriginalError"
                        return
                    }
                    if ($JSONError -and $JSONError.text) {
                        if ($ErrorActionPreference -eq 'Stop') {
                            throw $JSONError.text
                        }
                        Write-Warning -Message "Invoke-InfobloxQuery - Querying $Url failed. $($JSONError.text)"
                        return
                    } else {
                        if ($ErrorActionPreference -eq 'Stop') {
                            throw $OriginalError
                        }
                        Write-Warning -Message "Invoke-InfobloxQuery - Querying $Url failed. Error: $OriginalError"
                    }
                } else {
                    if ($ErrorActionPreference -eq 'Stop') {
                        throw
                    }
                    Write-Warning -Message "Invoke-InfobloxQuery - Querying $Url failed. Error: $OriginalError"
                }
            } else {
                if ($ErrorActionPreference -eq 'Stop') {
                    throw
                }
                Write-Warning -Message "Invoke-InfobloxQuery - Querying $Url failed. Error: $($_.Exception.Message)"
            }
        }
    }
}
