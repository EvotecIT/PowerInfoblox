function Invoke-InfobloxQuery {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory)][string] $BaseUri,
        [parameter(Mandatory)][string] $RelativeUri,
        [parameter()][pscredential] $Credential,
        [Parameter()][Microsoft.PowerShell.Commands.WebRequestSession] $WebSession,
        [parameter()][System.Collections.IDictionary] $QueryParameter,
        [parameter()][string] $Method = 'GET',
        [parameter()][System.Collections.IDictionary] $Body
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

    # if ($Method -eq 'GET') {
    #     if (-not $QueryParameter) {
    #         $joinUriQuerySplat['QueryParameter'] = [ordered] @{}
    #     }
    #     #_paging           = 1
    #     #_return_as_object = 1
    #     #_max_results      = 100000
    #     $joinUriQuerySplat['QueryParameter']._max_results = 1000000
    # }

    $Url = Join-UriQuery @joinUriQuerySplat

    if ($PSCmdlet.ShouldProcess($Url, "Invoke-InfobloxQuery - $Method")) {
        Write-Verbose -Message "Invoke-InfobloxQuery - Querying $Url with $Method"


        # $WebSession = New-WebSession -Cookies @{
        #     timeout = 600
        #     mtime   = 144631868
        #     client  = 'API'
        # } -For $BaseUri

        try {
            $invokeRestMethodSplat = @{
                Uri         = $Url
                Method      = $Method
                Credential  = $Credential
                ContentType = 'application/json'
                ErrorAction = 'Stop'
                Verbose     = $false
                WebSession  = $WebSession #$PSDefaultParameterValues['Invoke-InfobloxQuery:WebSession']
                TimeoutSec  = 600
            }
            if ($Body) {
                $invokeRestMethodSplat.Body = $Body | ConvertTo-Json -Depth 10
            }
            if ($Script:InfobloxConfiguration['SkipCertificateValidation'] -eq $true) {
                $invokeRestMethodSplat.SkipCertificateCheck  = $true
            }
            Remove-EmptyValue -Hashtable $invokeRestMethodSplat -Recursive -Rerun 2
            Invoke-RestMethod @invokeRestMethodSplat
            # we connected to the server, so we can reset the default Credentials value
            $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = $null
        } catch {
            if ($ErrorActionPreference -eq 'Stop') {
                throw
            }
            Write-Warning -Message "Invoke-InfobloxQuery - Querying $Url failed. Error: $($_.Exception.Message)"
        }
    }
}