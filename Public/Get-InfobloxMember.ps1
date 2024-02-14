function Get-InfobloxMember {
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxMember - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    # defalt return fields
    $ReturnFields = 'config_addr_type,host_name,platform,service_type_configuration,vip_setting,node_info,service_status'
    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "member"
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'member'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            _return_fields = $ReturnFields
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    $Output | Select-ObjectByProperty -FirstProperty 'host_name' -LastProperty '_ref'
}