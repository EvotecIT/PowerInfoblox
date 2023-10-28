function Invoke-InfobloxQuery {
    [CmdletBinding()]
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

    Write-Verbose -Message "Invoke-InfobloxQuery - Querying $Url"
    try {
        Invoke-RestMethod -Uri $Url -Method $Method -Credential $Credential -ContentType 'application/json' -ErrorAction Stop
    } catch {
        if ($ErrorActionPreference -eq 'Stop') {
            throw
        }
        Write-Warning -Message "Invoke-InfobloxQuery - QUerying $Url failed. Error: $($_.Exception.Message)"
    }
}