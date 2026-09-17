function Get-InfobloxMember {
    <#
    .SYNOPSIS
    Retrieves Infoblox Grid members.

    .DESCRIPTION
    Queries Infoblox WAPI member objects. By default, the command requests a
    curated set of identity, platform, network, and service-status properties.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the member object by the connected WAPI schema.

    .EXAMPLE
    Get-InfobloxMember

    Returns Grid members using the preferred field set.

    .EXAMPLE
    Get-InfobloxMember -FetchFromSchema

    Returns Grid members with all fields advertised by the connected WAPI schema.
    #>
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxMember - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $PreferredFields = 'config_addr_type,host_name,platform,service_type_configuration,vip_setting,node_info,service_status' -split ','
    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "member"
    } else {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject 'member' -RequestedFields $PreferredFields
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'member'
        Method         = 'GET'
        QueryParameter = @{
            _max_results   = 1000000
            _return_fields = $ReturnFields
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $Output | Select-ObjectByProperty -FirstProperty 'host_name' -LastProperty '_ref'
}
