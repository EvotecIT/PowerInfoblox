function Get-InfobloxSchema {
    [CmdletBinding()]
    param()
    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxSchema - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $Query = Invoke-InfobloxQuery -RelativeUri "?_schema" -Method Get
    if ($Query) {
        [PSCustomObject] @{
            RequestedVersion  = $Query.requested_version
            SupportedObjects  = $Query.supported_objects
            SupportedVersions = $Query.supported_versions
        }
    } else {
        Write-Warning -Message 'Get-InfobloxSchema - No schema returned'
    }
}

