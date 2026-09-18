function Get-InfobloxDNSRecordAll {
    <#
    .SYNOPSIS
    Gets DNS records across all record types.

    .DESCRIPTION
    Queries the Infoblox allrecords WAPI object and uses schema-aware preferred fields by default.

    .PARAMETER Name
    The DNS record name to match.

    .PARAMETER Zone
    The DNS zone to match.

    .PARAMETER View
    The DNS view to match.

    .PARAMETER PartialMatch
    Uses WAPI regular-expression matching for Name, Zone, and View.

    .PARAMETER FetchFromSchema
    Requests every field reported as readable by the connected Grid schema.

    .PARAMETER ReturnFields
    Requests the specified fields instead of the default schema-aware field set.

    .PARAMETER MaxResults
    The maximum result count requested from WAPI.

    .EXAMPLE
    Get-InfobloxDNSRecordAll -Zone 'example.com'

    .EXAMPLE
    Get-InfobloxDNSRecordAll -Name 'mail' -PartialMatch -ReturnFields name,type,record -MaxResults 100
    #>
    [alias('Get-InfobloxDNSRecordsAll')]
    [cmdletbinding()]
    param(
        [string] $Name,
        [string] $Zone,
        [string] $View,
        [switch] $PartialMatch,
        [switch] $FetchFromSchema,
        [string[]] $ReturnFields,
        [ValidateRange(1, 2147483647)]
        [int] $MaxResults = 1000000
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDNSRecordAll - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'allrecords'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = $MaxResults
        }
    }

    $PreferredFields = 'address,comment,creator,ddns_principal,ddns_protected,disable,dtc_obscured,name,reclaimable,record,ttl,type,view,zone' -split ','

    if ($FetchFromSchema) {
        $ResolvedReturnFields = Get-FieldsFromSchema -SchemaObject 'allrecords'
    } elseif ($ReturnFields) {
        $ResolvedReturnFields = ($ReturnFields | Sort-Object -Unique) -join ','
    } else {
        $ResolvedReturnFields = Get-FieldsFromSchema -SchemaObject 'allrecords' -RequestedFields $PreferredFields
    }
    if ($ResolvedReturnFields) {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = $ResolvedReturnFields
    }
    if ($Zone) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."zone~" = $Zone.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.zone = $Zone.ToLower()
        }
    }
    if ($View) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."view~" = $View.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.view = $View.ToLower()
        }
    }
    if ($Name) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."name~" = $Name.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.name = $Name.ToLower()
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $AllProperties = Select-Properties -AllProperties -Object $Output
    $Output | Select-ObjectByProperty -LastProperty '_ref' -FirstProperty 'zone', 'type', 'name', 'address', 'disable', 'creator' -AllProperties $AllProperties
}
