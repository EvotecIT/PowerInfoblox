function Invoke-InfobloxQuery {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory)][string] $BaseUri,
        [parameter(Mandatory)][string] $RelativeUri,
        [parameter(Mandatory)][pscredential] $Credential,
        [parameter()][System.Collections.IDictionary] $QueryParameter,
        [parameter(Mandatory)][string] $Method
    )

    $joinUriQuerySplat = @{
        BaseUri               = $BaseUri
        RelativeOrAbsoluteUri = $RelativeUri
    }
    if ($QueryParameter) {
        $joinUriQuerySplat['QueryParameter'] = $QueryParameter
    }

    $Url = Join-UriQuery @joinUriQuerySplat

    if ($PSCmdlet.ShouldProcess($Url, "Invoke-InfobloxQuery - $Method")) {
        Write-Verbose -Message "Invoke-InfobloxQuery - Querying $Url with $Method"
        try {
            Invoke-RestMethod -Uri $Url -Method $Method -Credential $Credential -ContentType 'application/json' -ErrorAction Stop -Verbose:$false
        } catch {
            if ($ErrorActionPreference -eq 'Stop') {
                throw
            }
            Write-Warning -Message "Invoke-InfobloxQuery - QUerying $Url failed. Error: $($_.Exception.Message)"
        }
    }
}