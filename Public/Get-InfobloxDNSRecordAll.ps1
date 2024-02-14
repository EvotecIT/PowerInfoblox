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

    $invokeInfobloxQuerySplat.QueryParameter._return_fields = 'address,comment,creator,ddns_principal,ddns_protected,disable,dtc_obscured,name,reclaimable,record,ttl,type,view,zone'

    if ($FetchFromSchema) {
        <#
        if (-not $Script:InfobloxSchemaFields) {
            $Script:InfobloxSchemaFields = [ordered] @{}
        }
        if ($Script:InfobloxSchemaFields["allrecords"]) {
            $invokeInfobloxQuerySplat.QueryParameter._return_fields = ($Script:InfobloxSchemaFields["allrecords"])
        } else {
            $Schema = Get-InfobloxSchema -Object "allrecords"
            if ($Schema -and $Schema.fields.name) {
                $invokeInfobloxQuerySplat.QueryParameter._return_fields = ($Schema.fields.Name -join ',')
                $Script:InfobloxSchemaFields["allrecords"] = ($Schema.fields.Name -join ',')
            } else {
                Write-Warning -Message "Get-InfobloxDNSRecordAll - Failed to fetch schema for record type 'allrecords'. Using defaults"
            }
        }
        #>
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = Get-FieldsFromSchema -SchemaObject "allrecords"
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
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    $Output | Select-ObjectByProperty -LastProperty '_ref' -FirstProperty 'zone', 'type', 'name'
}