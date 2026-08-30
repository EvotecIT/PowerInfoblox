function Get-InfobloxDNSRecordAll {
    [alias('Get-InfobloxDNSRecordsAll')]
    [cmdletbinding()]
    param(
        [string] $Name,
        [string] $Zone,
        [string] $View,
        [switch] $PartialMatch,
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDNSRecordAll - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = "allrecords"
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
        }
    }

    $PreferredFields = 'address,comment,creator,ddns_principal,ddns_protected,disable,dtc_obscured,name,reclaimable,record,ttl,type,view,zone' -split ','

    if ($FetchFromSchema) {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = Get-FieldsFromSchema -SchemaObject "allrecords"
    } else {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = Get-FieldsFromSchema -SchemaObject 'allrecords' -RequestedFields $PreferredFields
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
