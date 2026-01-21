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
        _return_fields = 'name,type,list_values,allow_multiple'
    }

    $Result = Invoke-InfobloxQuery -RelativeUri "extensibleattributedef" -Method 'GET' -QueryParameter $QueryParameter -WhatIf:$false
    if ($Result -is [array]) {
        $Result = $Result | Select-Object -First 1
    }

    if (-not $SkipCache) {
        $Script:InfobloxExtensibleAttributeDefCache[$CacheKey] = $Result
    }

    $Result
}
