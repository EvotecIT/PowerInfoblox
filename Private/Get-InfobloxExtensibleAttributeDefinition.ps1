function Get-InfobloxExtensibleAttributeDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Name,
        [switch] $SkipCache
    )

    if (-not $Script:InfobloxExtensibleAttributeDefCache) {
        $Script:InfobloxExtensibleAttributeDefCache = @{}
    }

    $CacheKey = if ($Script:InfobloxConfiguration -and $Script:InfobloxConfiguration.BaseUri) {
        "$($Script:InfobloxConfiguration.BaseUri)|$Name"
    } else {
        $Name
    }

    if (-not $SkipCache -and $Script:InfobloxExtensibleAttributeDefCache.ContainsKey($CacheKey)) {
        return $Script:InfobloxExtensibleAttributeDefCache[$CacheKey]
    }

    $QueryParameter = @{
        name           = $Name
        _return_fields = 'name,type,list_values'
    }

    $Result = $null
    $FirstError = $null
    $PreviousErrorAction = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Stop'
        $Result = Invoke-InfobloxQuery -RelativeUri "extensibleattributedef" -Method 'GET' -QueryParameter $QueryParameter -WhatIf:$false
    } catch {
        $FirstError = $_
        $Result = $null
    } finally {
        $ErrorActionPreference = $PreviousErrorAction
    }

    if ($FirstError) {
        # As a last resort, let the API decide default fields.
        $QueryParameter.Remove('_return_fields')
        try {
            $ErrorActionPreference = 'Stop'
            $Result = Invoke-InfobloxQuery -RelativeUri "extensibleattributedef" -Method 'GET' -QueryParameter $QueryParameter -WhatIf:$false
        } catch {
            if ($PreviousErrorAction -eq 'Stop') {
                throw $FirstError
            }
            $Result = $null
        } finally {
            $ErrorActionPreference = $PreviousErrorAction
        }
    }
    if ($Result -is [array]) {
        $Result = $Result | Select-Object -First 1
    }

    if (-not $SkipCache) {
        $Script:InfobloxExtensibleAttributeDefCache[$CacheKey] = $Result
    }

    $Result
}
